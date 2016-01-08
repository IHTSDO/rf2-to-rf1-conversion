package org.ihtsdo.snomed.rf2torf1conversion;

import static org.ihtsdo.snomed.rf2torf1conversion.GlobalUtils.*;

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
	private static final String DB_CONNECTION = "jdbc:h2:mem:rf1_conversion;DB_CLOSE_DELAY=-1";
	private static final String DB_USER = "";
	private static final String DB_PASSWORD = "";

	private Connection dbConnection;

	public void init() throws RF1ConversionException {
		print("Initialising In-Memory Database");
		getDBConnection();
	}

	private void getDBConnection() throws RF1ConversionException {
		try {
			Class.forName(DB_DRIVER);
			dbConnection = DriverManager.getConnection(DB_CONNECTION, DB_USER, DB_PASSWORD);
		} catch (ClassNotFoundException | SQLException e) {
			throw new RF1ConversionException("Failed to initialise in memory database", e);
		}
	}

	public void executeResource(String resourceName) throws RF1ConversionException {
		try {
			List<String> sqlStatements = loadSqlStatements(resourceName);
			for (String sql : sqlStatements) {
				print("Running: " + sql);
			}
		} catch (IOException e) {
			throw new RF1ConversionException("Failed to execute resource " + resourceName, e);
		}

	}

	private List<String> loadSqlStatements(String resourceName) throws IOException {
		URL url = Resources.getResource(resourceName);
		String text = Resources.toString(url, Charsets.UTF_8);
		return Arrays.asList(text.split(";"));
	}
}
