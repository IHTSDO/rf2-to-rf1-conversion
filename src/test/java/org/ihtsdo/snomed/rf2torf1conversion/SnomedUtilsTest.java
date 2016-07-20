package org.ihtsdo.snomed.rf2torf1conversion;

import static org.junit.Assert.*;

import org.ihtsdo.snomed.rf2torf1conversion.pojo.RF2SchemaConstants;
import org.junit.Test;

public class SnomedUtilsTest implements RF2SchemaConstants {

	@Test
	public void getEffectiveDatePartsTest() {
		String effectiveDate = "20160711"; 
		int year = SnomedUtils.getEffectiveDatePart(effectiveDate, EFFECTIVE_DATE_PART_YEAR);
		assertEquals(2016, year);
		int month = SnomedUtils.getEffectiveDatePart(effectiveDate, EFFECTIVE_DATE_PART_MONTH);
		assertEquals(7, month);
		int day = SnomedUtils.getEffectiveDatePart(effectiveDate, EFFECTIVE_DATE_PART_DAY);
		assertEquals(11, day);
	}

}
