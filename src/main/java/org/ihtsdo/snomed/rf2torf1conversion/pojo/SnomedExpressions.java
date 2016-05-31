package org.ihtsdo.snomed.rf2torf1conversion.pojo;

public interface SnomedExpressions {
	
	public static String DELIMITER = "\\|";
	
	public enum CONSTRAINT {
		DESCENDENT ("< "),
		DESCENDENT_OR_SELF ("<< ");
		
		private final String symbol;
		private CONSTRAINT (String symbol) {
			this.symbol = symbol;
		}
		
		public String toString() {
			return symbol;
		}
	}
}
