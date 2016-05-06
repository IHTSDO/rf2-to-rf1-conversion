package org.ihtsdo.snomed.rf2torf1conversion.pojo;

import java.util.HashMap;
import java.util.Map;

public class LateralityIndicator {
	//Map of SCTIDS to Lattomidsag value
	static Map<Long, Lattomidsag> lateralityIndicators = new HashMap<Long, Lattomidsag>();
	
	public static enum Lattomidsag { YES, NO, LEFT, RIGHT };
	
	public static int IDX_SCTID = 0;
	public static int IDX_FSN = 1;
	public static int IDX_LATTOMIDSAG = 2;
	public static int IDX_LR_SELECTOR = 3;
	
	public static void registerIndicator(String line) {
		String[] parts = line.split("\t");
		Long sctid = Long.parseLong(parts[IDX_SCTID]);
		Lattomidsag l = parseLattomidsag(parts[IDX_LATTOMIDSAG]);
		lateralityIndicators.put(sctid, l);
	}
	
	private static Lattomidsag parseLattomidsag(String value) {
		switch (value) {
			case "Y" :
			case "y" : return Lattomidsag.YES;
			case "L" : return Lattomidsag.LEFT;
			case "R" : return Lattomidsag.RIGHT;
			default : return Lattomidsag.NO;
		}
	}
	
	public static boolean hasLateralityIndicator (Long sctId, Lattomidsag targetIndicator) {
		Lattomidsag indicator = lateralityIndicators.get(sctId);
		if (indicator == null) {
			return false;
		}
		return indicator.equals(targetIndicator);
	}
}
