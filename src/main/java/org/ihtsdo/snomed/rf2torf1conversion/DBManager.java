package org.ihtsdo.snomed.rf2torf1conversion;

import static org.ihtsdo.snomed.rf2torf1conversion.GlobalUtils.*;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.ExecutorService;

import org.apache.commons.io.IOUtils;
import org.h2.jdbcx.JdbcConnectionPool;

import com.google.common.base.Charsets;
import com.google.common.io.Resources;

public class DBManager {

	private static final String DB_DRIVER = "org.h2.Driver";
	//private static final String DB_OPTIONS = "MULTI_THREADED=0;LOG=0;CACHE_SIZE=1048576;LOCK_MODE=3";
	private static final String DB_OPTIONS = "";
	private static final String DEFAULT_FILE_SEPARATOR = "/";
	private static final String SQL_DELIMITER = ";";

	// In Memory Database fails when we try to load in the full relationship file
	// private static final String DB_CONNECTION = "jdbc:h2:mem:rf1_conversion;DB_CLOSE_DELAY=-1";
	private static final String DB_USER = "";
	private static final String DB_PASSWORD = "";

	private ExecutorService executor = null;
	private boolean parallelMode = false;
	private JdbcConnectionPool dbPool = null;
	private boolean failureDetected = false;

	synchronized public void startParallelProcessing(int threadCount) throws RF1ConversionException {
		/*
		 * if (parallelMode == true) { throw new
		 * RF1ConversionException("Cannot start parallel processing while existing parallel processes exist."); }
		 * print("\nStarting Parallel Processing"); parallelMode = true; 
		 * executor = Executors.newFixedThreadPool(threadCount);
		 */
	}

	synchronized public void finishParallelProcessing() throws RF1ConversionException {
		// When we stop running in parallel, we have to wait for all threads to catch up
		/*
		 * debug("Ensuring all currently running processes complete..."); try { executor.shutdown(); if (!executor.awaitTermination(20,
		 * TimeUnit.MINUTES)) { throw new RF1ConversionException("Processing threads failed to complete within 5 minutes."); }
		 * 
		 * if (failureDetected) { throw new RF1ConversionException("Failure detected in one or more processing threads."); } parallelMode =
		 * false; print("\nParallel tasks now all complete"); } catch (InterruptedException e) { throw new
		 * RF1ConversionException("Processing threads interrupted while awaiting completion."); }
		 */
	}

	public void init(File dbLocation) throws RF1ConversionException {
		print("Initialising Database");
		getDBConnection(dbLocation);
	}

	private void getDBConnection(File dbLocationParent) throws RF1ConversionException {
		try {
			Class.forName(DB_DRIVER);
			String dblocation = dbLocationParent.getPath() + File.separator + "rf2-to-rf1-conversion";
			debug("Creating temporary data in folder: " + dblocation);
			String dbConnectionStr = "jdbc:h2:" + dblocation + DB_OPTIONS;
			dbPool = JdbcConnectionPool.create(dbConnectionStr, DB_USER, DB_PASSWORD);
		} catch (ClassNotFoundException e) {
			throw new RF1ConversionException("Failed to initialise in memory database", e);
		}
	}

	public void executeResource(String resourceName) throws RF1ConversionException {
		try {
			debug("\nExcecuting resource: " + resourceName);
			List<String> sqlStatements = loadSqlStatements(resourceName);
			for (String sql : sqlStatements) {
				sql = sql.trim();
				if (sql.length() > 0) {
					if (sql.equals("-- PARALLEL_START")) {
						startParallelProcessing(3);
					} else if (sql.equals("-- PARALLEL_END")) {
						finishParallelProcessing();
					} else {
						runStatement(sql);
					}
				}
			}
		} catch (IOException e) {
			throw new RF1ConversionException("Failed to execute resource " + resourceName, e);
		}
	}

	private List<String> loadSqlStatements(String resourceName) throws IOException {
		URL url = Resources.getResource(resourceName);
		String text = Resources.toString(url, Charsets.UTF_8);
		return Arrays.asList(text.split(SQL_DELIMITER));
	}

	public void load(File file, String tableName) throws RF1ConversionException {
		debug("Loading data into " + tableName + " from " + file.getName());
		// Field separator set to ASCII 21 = NAK to ensure double quotes (the default separator) are ignored
		String sql = "INSERT INTO " + tableName + " SELECT * FROM CSVREAD('" + file.getPath() + "', null, 'UTF-8', chr(9), chr(21));";
		runStatement(sql);
	}

	public void shutDown(boolean deleteFiles) throws RF1ConversionException {
			if (deleteFiles) {
				runStatement("DROP ALL OBJECTS DELETE FILES");
			}
			runStatement("SHUTDOWN");
			dbPool.dispose();
	}

	public void export(String outputFilePath, String selectionSql, InputStream includeStream) throws RF1ConversionException {
			// Make the path separator compatible with the OS
			outputFilePath = outputFilePath.replace(DEFAULT_FILE_SEPARATOR, File.separator);

			// Create the parent directory structure if required
			File outputFile = new File(outputFilePath);
			outputFile.getParentFile().mkdirs();

			debug("Exporting data into " + outputFile.getName());
			// Field separator set to ASCII 21 = NAK to ensure double quotes (the default separator) are ignored
			// Use Windows line terminators, tab field separator and no delimiter (double quote by default)
			String sql = "CALL CSVWRITE('" + outputFile.getPath() + "', '" + selectionSql + "',"
					+ "'charset=UTF-8 lineSeparator=' || CHAR(13) || CHAR(10) ||' fieldSeparator=' || CHAR(9) || ' fieldDelimiter= escape=');";
			runStatement(sql);
			
			if (includeStream != null) {
				debug ("Including additional resource...");
				try {
					OutputStream os = new FileOutputStream (outputFile, true);
					IOUtils.copy(includeStream, os);
					os.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
	}
	
	public void runStatement(String sql) {
		// Are we running this synchronously or in parallel?
		if (parallelMode) {
			Runnable asyncWorker = new StatementRunner(sql);
			executor.execute(asyncWorker);
		} else {
			Runnable syncWorker = new StatementRunner(sql);
			syncWorker.run();
		}
	}

	public class StatementRunner implements Runnable {
		private String sql;
		
		public StatementRunner (String sql) {
			this.sql = sql;
		}

		public void run() {
			// Only need to do these if we're outputting verbose debug information
			try {
				debug("\nRunning: " + sql);
				Long rowsUpdated = null;
				long startTime = System.currentTimeMillis();
				if (sql.startsWith("STOP")) {
					throw new RuntimeException("Manually stated \"STOP\" encountered");
				} else if (sql.startsWith("SELECT") || sql.startsWith("SHOW")) {
					executeSelect();
				} else {
					Connection conn = dbPool.getConnection();
					Statement stmt = conn.createStatement();
					stmt.execute(sql);
					if (sql.contains("INSERT") || sql.contains("UPDATE") || sql.contains("DELETE")) {
						String elapsed = new DecimalFormat("#.##").format((System.currentTimeMillis() - startTime) / 1000.00d);
						rowsUpdated = new Long(stmt.getUpdateCount());
						debug("Rows updated: " + rowsUpdated + " in " + elapsed + " secs.");
					}
					conn.close();
				}
				updateProgress();
			} catch (SQLException e) {
				failureDetected = true;
				throw new RuntimeException("Failed to execute SQL Statement", e);
			}
		}
		
		public void executeSelect() {
			//if (verbose) {
				try{
					Connection conn = dbPool.getConnection();
					Statement stmt = conn.createStatement();
					ResultSet rs = stmt.executeQuery(sql);
					ResultSetMetaData md = rs.getMetaData();
					int columnCount = md.getColumnCount();
					String header = "";
					for (int i=1; i <= columnCount; i++ ) {
						header += md.getColumnLabel(i) + "\t";
					}
					print("\n" + header);
					print(new String(new char[header.length()]).replace("\0", "="));
	
					StringBuilder sb = new StringBuilder();
					while (rs.next()) {
						sb.setLength(0); // Empty the string
						for (int i = 1; i <= columnCount; i++) {
							sb.append(rs.getString(i)).append("\t");
						}
						print(sb.toString());
					}
					conn.close();
				} catch (Exception e) {
					print("Exception during select statement: " + sql + " - " + e.getMessage());
				}
			//}
			updateProgress();
		}
	}

}
