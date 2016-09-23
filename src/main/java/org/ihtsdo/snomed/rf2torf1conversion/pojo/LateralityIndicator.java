package org.ihtsdo.snomed.rf2torf1conversion.pojo;

import java.util.HashSet;
import java.util.Set;

public class LateralityIndicator implements RF2SchemaConstants{
	static Set<Long> lateralityIndicators = new HashSet<Long>();
	
	public static void registerIndicator(String sctid) {
		lateralityIndicators.add(Long.parseLong(sctid));
	}
	
	public static boolean hasLateralityIndicator (Long sctId) {
		return lateralityIndicators.contains(sctId);
	}
}
