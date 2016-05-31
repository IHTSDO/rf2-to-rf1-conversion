package org.ihtsdo.snomed.rf2torf1conversion;

import org.junit.*;

public class ConversionManagerTest {
	
	ConversionManager cm;

	@Before
	public void init() {
		cm = new ConversionManager();
	}
	
	@Test
	public void calculateReleaseIndexTest() {
		String test1 = "20160731";
		int idx = cm.calculateReleaseIndex(test1);
		Assert.assertTrue(idx == 7);
		
		String test2 = "20161030";  //Prep for Spanish release
		idx = cm.calculateReleaseIndex(test2);
		Assert.assertTrue(idx == 10);
		
		String test3 = "20170131";
		idx = cm.calculateReleaseIndex(test3);
		Assert.assertTrue(idx == 11);
	}
}
