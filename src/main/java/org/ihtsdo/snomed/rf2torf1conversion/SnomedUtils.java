package org.ihtsdo.snomed.rf2torf1conversion;

import org.ihtsdo.snomed.rf2torf1conversion.pojo.RF2SchemaConstants;

public class SnomedUtils implements RF2SchemaConstants{

	public static int getEffectiveDatePart(String effectiveDate, int partIdx) {
		switch (partIdx) {
		case EFFECTIVE_DATE_PART_YEAR:  return Integer.parseInt(effectiveDate.substring(0, 4));
		case EFFECTIVE_DATE_PART_MONTH:  return Integer.parseInt(effectiveDate.substring(4, 6));
		case EFFECTIVE_DATE_PART_DAY:  return Integer.parseInt( effectiveDate.substring(6, 8));
		default: return -1;
		}
	}
}
