package org.ihtsdo.snomed.rf2torf1conversion;

import static org.ihtsdo.snomed.rf2torf1conversion.GlobalUtils.*;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.util.Arrays;
import java.util.List;

import com.google.common.base.Charsets;
import com.google.common.base.Stopwatch;
import com.google.common.io.Resources;

public class DBManager {

	private static final String DB_DRIVER = "org.h2.Driver";
	// In Memory Database fails when we try to load in the full relationship file
	// private static final String DB_CONNECTION = "jdbc:h2:mem:rf1_conversion;DB_CLOSE_DELAY=-1";
	private static final String DB_USER = "";
	private static final String DB_PASSWORD = "";

	private static final String DELIMITER_SEQUENCE = "DELIMITER $$";
	private static final String DELIMITER_RESET = "DELIMITER ;";
	private static final String DEFAULT_FILE_SEPARATOR = "/";

	private Connection dbConn;

	public void init(File dbLocation) throws RF1ConversionException {
		print("Initialising Database");
		getDBConnection(dbLocation);
	}

	private void getDBConnection(File dbLocationParent) throws RF1ConversionException {
		try {
			Class.forName(DB_DRIVER);
			String dblocation = dbLocationParent.getPath() + File.separator + "rf2-to-rf1-conversion";
			debug("Creating temporary data in folder: " + dblocation);
			String dbConnectionStr = "jdbc:h2:" + dblocation;
			dbConn = DriverManager.getConnection(dbConnectionStr, DB_USER, DB_PASSWORD);
		} catch (ClassNotFoundException | SQLException e) {
			throw new RF1ConversionException("Failed to initialise in memory database", e);
		}
	}

	public void executeResource(String resourceName, boolean multiPass) throws RF1ConversionException {
		try {
			print("Excecuting resource: " + resourceName + (multiPass ? " multiple Times." : ""));
			List<String> sqlStatements = loadSqlStatements(resourceName);
			Long rowsUpdated = null;
			for (String sql : sqlStatements) {
				sql = sql.trim();
				if (sql.length() > 0) {
					do {
						rowsUpdated = executeSql(sql);
					} while (multiPass && rowsUpdated != null && rowsUpdated.longValue() > 0);
				}
			}
		} catch (IOException | RF1ConversionException e) {
			throw new RF1ConversionException("Failed to execute resource " + resourceName, e);
		}
	}

	private List<String> loadSqlStatements(String resourceName) throws IOException {
		URL url = Resources.getResource(resourceName);
		String text = Resources.toString(url, Charsets.UTF_8);
		String delimiter = ";";
		if (text.contains(DELIMITER_SEQUENCE)) {
			text = text.replace(DELIMITER_SEQUENCE, "");
			text = text.replace(DELIMITER_RESET, "");
			delimiter = "\\$\\$";
		}
		return Arrays.asList(text.split(delimiter));
	}

	public void load(File file, String tableName) throws RF1ConversionException {
		try {
			debug("Loading data into " + tableName + " from " + file.getName());
			// Field separator set to ASCII 21 = NAK to ensure double quotes (the default separator) are ignored
			String sql = "INSERT INTO " + tableName + " SELECT * FROM CSVREAD('" + file.getPath() + "', null, 'UTF-8', chr(9), chr(21));";
			executeSql(sql);
		} catch (RF1ConversionException e) {
			throw new RF1ConversionException("Failed to load data into " + tableName, e);
		}
	}

	public Long executeSql(String sql) throws RF1ConversionException {
		try {
			debug("Running: " + sql);
			Long rowsUpdated = null;
			long startTime = System.currentTimeMillis();
			if (sql.startsWith("STOP")) {
				throw new RF1ConversionException("Manually stated \"STOP\" encountered");
			} else if (sql.startsWith("SELECT")) {
				executeSelect(sql);
			} else {
				Statement stmt = dbConn.createStatement();
				stmt.execute(sql);
				if (sql.contains("INSERT") || sql.contains("UPDATE")) {
					String elapsed = new DecimalFormat("#.##").format((System.currentTimeMillis() - startTime) / 1000.00d);
					rowsUpdated = new Long(stmt.getUpdateCount());
					debug("Rows updated: " + rowsUpdated + " in " + elapsed + " secs.");
				}
			}
			return rowsUpdated;
		} catch (SQLException e) {
			throw new RF1ConversionException("Failed to execute SQL Statement", e);
		}
	}

	private void executeSelect(String sql) throws SQLException {
		Statement stmt = dbConn.createStatement();
		ResultSet rs = stmt.executeQuery(sql);
		ResultSetMetaData md = rs.getMetaData();
		int columnCount = md.getColumnCount();
		String header = "";
		for (int i=1; i <= columnCount; i++ ) {
			header += md.getColumnLabel(i) + "\t";
		}
		print (header);
		print (new String(new char[header.length()]).replace("\0", "="));
		
		StringBuilder sb = new StringBuilder();
		while (rs.next()) {
			sb.setLength(0);  //Empty the string
			for (int i=1; i <= columnCount; i++ ) {
				sb.append(rs.getString(i)).append("\t");
			}
			print (sb.toString());
		}

	}

	public void shutDown(boolean deleteFiles) throws RF1ConversionException {
		try {
			if (deleteFiles) {
				dbConn.createStatement().execute("DROP ALL OBJECTS DELETE FILES");
			}
			dbConn.createStatement().execute("SHUTDOWN");
		} catch (SQLException e) {
			throw new RF1ConversionException("Failed to shutdown database");
		}
	}

	public void export(String outputFilePath, String selectionSql) throws RF1ConversionException {
		try {
			// Make the path separator compatible with the OS
			outputFilePath = outputFilePath.replace(DEFAULT_FILE_SEPARATOR, File.separator);

			// Create the parent directory structure if required
			File outputFile = new File(outputFilePath);
			outputFile.getParentFile().mkdirs();

			debug("Exporting data into " + outputFile.getName());
			// Field separator set to ASCII 21 = NAK to ensure double quotes (the default separator) are ignored
			// Use Windows line terminators, tab field separator and no delimiter (double quote by default)
			String sql = "CALL CSVWRITE('" + outputFile.getPath() + "', '" + selectionSql + "',"
					+ "'charset=UTF-8 lineSeparator=' || CHAR(13) || CHAR(10) ||' fieldSeparator=' || CHAR(9) || ' fieldDelimiter=');";
			dbConn.createStatement().execute(sql);
		} catch (SQLException e) {
			throw new RF1ConversionException("Failed to export data to file " + outputFilePath, e);
		}
	}

}
