package org.ihtsdo.snomed.rf2torf1conversion;

import org.junit.*;

public class DBManagerTest {

	DBManager db;

	@Before
	public void before() throws RF1ConversionException {
		db = new DBManager();
		db.init();
	}

	@Test
	public void executeResourceTest() throws RF1ConversionException {
		db.executeResource("test_scripts.sql");
	}

}
