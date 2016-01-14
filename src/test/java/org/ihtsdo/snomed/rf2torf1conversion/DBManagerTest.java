package org.ihtsdo.snomed.rf2torf1conversion;

import java.io.File;
import java.io.IOException;

import org.apache.commons.io.FileUtils;
import org.junit.*;

import com.google.common.io.Files;

public class DBManagerTest {

	File dbLocation;
	DBManager db;

	@Before
	public void before() throws RF1ConversionException {
		dbLocation = Files.createTempDir();
		db = new DBManager();
		db.init(dbLocation);
	}

	@Test
	public void executeResourceTest() throws RF1ConversionException {
		db.executeResource("test_scripts.sql");
	}

	@After
	public void after() throws IOException, RF1ConversionException {
		db.shutDown(true);
		FileUtils.deleteDirectory(dbLocation);
	}

}
