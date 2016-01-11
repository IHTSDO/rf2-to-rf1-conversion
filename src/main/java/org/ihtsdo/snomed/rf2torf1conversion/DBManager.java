package org.ihtsdo.snomed.rf2torf1conversion;

import static org.ihtsdo.snomed.rf2torf1conversion.GlobalUtils.*;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import com.google.common.base.Charsets;
import com.google.common.io.Resources;

public class DBManager {

	private static final String DB_DRIVER = "org.h2.Driver";
	// In Memory Database fails when we try to load in the full relationship file
	// private static final String DB_CONNECTION = "jdbc:h2:mem:rf1_conversion;DB_CLOSE_DELAY=-1";
	private static final String DB_USER = "";
	private static final String DB_PASSWORD = "";

	private static final String DELIMITER_SEQUENCE = "DELIMITER $$";
	private static final String DELIMITER_RESET = "DELIMITER ;";

	private Connection dbConn;

	public void init(File dbLocation) throws RF1ConversionException {
		print("Initialising Database");
		getDBConnection(dbLocation);
	}

	private void getDBConnection(File dbLocation) throws RF1ConversionException {
		try {
			Class.forName(DB_DRIVER);
			String dbConnectionStr = "jdbc:h2:" + dbLocation.getPath();
			dbConn = DriverManager.getConnection(dbConnectionStr, DB_USER, DB_PASSWORD);
		} catch (ClassNotFoundException | SQLException e) {
			throw new RF1ConversionException("Failed to initialise in memory database", e);
		}
	}

	public void executeResource(String resourceName) throws RF1ConversionException {
		try {
			print("Excecuting resource: " + resourceName);
			List<String> sqlStatements = loadSqlStatements(resourceName);
			for (String sql : sqlStatements) {
				sql = sql.trim();
				if (sql.length() > 0) {
					debug("Running: " + sql);
					dbConn.createStatement().execute(sql);
				}
			}
		} catch (IOException | SQLException e) {
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
			dbConn.createStatement().execute(sql);
		} catch (SQLException e) {
			throw new RF1ConversionException("Failed to load data into " + tableName, e);
		}
	}

	public void shutDown() throws RF1ConversionException {
		try {
			dbConn.createStatement().execute("SHUTDOWN");
		} catch (SQLException e) {
			throw new RF1ConversionException("Failed to shutdown database");
		}
	}
}
