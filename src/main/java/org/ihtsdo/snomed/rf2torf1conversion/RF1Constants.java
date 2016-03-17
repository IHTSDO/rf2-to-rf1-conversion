package org.ihtsdo.snomed.rf2torf1conversion;

import java.util.HashMap;
import java.util.Map;

public class RF1Constants {

	public static final String FSN = "900000000000003001";
	public static final String DEFINITION = "900000000000550004";
	public static final String ENTIRE_TERM_CS = "900000000000017005";
	public static final String INFERRED = "900000000000011006";
	public static final String STATED = "900000000000010007";
	public static final String ADDITIONAL = "900000000000227009";

	private static Map<String, Byte> rf1Map = new HashMap<String, Byte>();
	static {
		rf1Map.put("900000000000441003", null); /* SNOMED CT Model Component (metadata) */
		rf1Map.put("106237007", null); /* Linkage concept (linkage concept) */
		rf1Map.put("370136006", null); /* Namespace concept (namespace concept) */
		rf1Map.put("900000000000442005", null); /* Core metadata concept (core metadata concept) */
		rf1Map.put("900000000000447004", null); /* Case significance (core metadata concept) */
		rf1Map.put("900000000000016001", (byte) 2); /* AU Entire term case sensitive (core metadata concept) */
		rf1Map.put("900000000000017005", (byte) 2); /* CORE Entire term case sensitive (core metadata concept) */
		rf1Map.put("900000000000022005", (byte) 1); /* AU Only initial character case insensitive (core metadata concept) */
		rf1Map.put("900000000000020002", (byte) 1); /* CORE Only initial character case insensitive (core metadata concept) */
		rf1Map.put("900000000000448009", (byte) 0); /* Entire term case insensitive (core metadata concept) */
		rf1Map.put("900000000000449001", null); /* Characteristic type (core metadata concept) */
		rf1Map.put("900000000000006009", (byte) 0); /* Defining relationship (core metadata concept) */
		rf1Map.put("900000000000011006", (byte) 0); /* Inferred relationship (core metadata concept) */
		rf1Map.put("900000000000010007", (byte) 10); /* Stated relationship (core metadata concept) */
		rf1Map.put("900000000000409009", (byte) 1); /* AU Qualifying relationship (core metadata concept) */
		rf1Map.put("900000000000225001", (byte) 1); /* CORE Qualifying relationship (core metadata concept) */
		rf1Map.put("900000000000412007", (byte) 3); /* AU Additional relationship (core metadata concept) */
		rf1Map.put("900000000000227009", (byte) 3); /* CORE Additional relationship (core metadata concept) */
		rf1Map.put("900000000000444006", null); /* Definition status (core metadata concept) */
		rf1Map.put("900000000000128007", (byte) 0); /* AU Defined Sufficiently defined concept definition status (core metadata concept) */
		rf1Map.put("900000000000130009", (byte) 1); /* AU Primitive Necessary but not sufficient concept definition status (core metadata concept) */
		rf1Map.put("900000000000073002", (byte) 0); /* CORE Sufficiently defined concept definition status (core metadata concept) */
		rf1Map.put("900000000000074008", (byte) 1); /* CORE Necessary but not sufficient concept definition status (core metadata concept) */
		rf1Map.put("900000000000446008", null); /* Description type (core metadata concept) */
		rf1Map.put("??????????????????", (byte) 0); /* Unspecified */
		rf1Map.put("900000000000013009", (byte) 2); /* CORE Synonym (core metadata concept) */
		rf1Map.put("900000000000187000", (byte) 2); /* AU Synonym (core metadata concept) */
		rf1Map.put("900000000000003001", (byte) 3); /* Fully specified name (core metadata concept) */
		rf1Map.put("900000000000550004", (byte) 10); /* Definition (core metadata concept) */
		rf1Map.put("900000000000453004", null); /* Identifier scheme (core metadata concept) */
		rf1Map.put("900000000000294009", null); /* CORE SNOMED CT integer identifier (core metadata concept) */
		rf1Map.put("900000000000118003", null); /* AU SNOMED CT integer identifier (core metadata concept) */
		rf1Map.put("900000000000002006", null); /* SNOMED CT universally unique identifier (core metadata concept) */
		rf1Map.put("900000000000450001", null); /* Modifier (core metadata concept) */
		rf1Map.put("900000000000451002", (byte) 20); /* Existential restriction modifier (core metadata concept) */
		rf1Map.put("900000000000452009", (byte) 21); /* Universal restriction modifier (core metadata concept) */
		rf1Map.put("900000000000443000", null); /* Module (core metadata concept) */
		rf1Map.put("900000000000445007", null); /* International Health Terminology Standards Development Organisation maintained module (core metadata concept) */
		rf1Map.put("449081005", null); /* SNOMED CT Spanish edition module (core metadata concept) */
		rf1Map.put("900000000000207008", null); /* SNOMED CT core module (core metadata concept) */
		rf1Map.put("900000000000012004", null); /* SNOMED CT model component module (core metadata concept) */
		rf1Map.put("449080006", null); /* SNOMED CT to ICD-10 rule-based mapping module (core metadata concept) */
		rf1Map.put("449079008", null); /* SNOMED CT to ICD-9CM equivalency mapping module (core metadata concept) */
		rf1Map.put("900000000000454005", null); /* Foundation metadata concept (foundation metadata concept) */
		rf1Map.put("900000000000455006", null); /* Reference set (foundation metadata concept) */
		rf1Map.put("900000000000456007", null); /* Reference set descriptor reference set (foundation metadata concept) */
		rf1Map.put("900000000000480006", null); /* Attribute value type reference set (foundation metadata concept) */
		rf1Map.put("900000000000488004", null); /* Relationship refinability attribute value reference set (foundation metadata concept) */
		rf1Map.put("900000000000489007", null); /* Concept inactivation indicator attribute value reference set (foundation metadata concept) */
		rf1Map.put("900000000000490003", null); /* Description inactivation indicator attribute value reference set (foundation metadata concept) */
		rf1Map.put("900000000000547002", null); /* Relationship inactivation indicator attribute value reference set (foundation metadata concept) */
		rf1Map.put("900000000000496009", null); /* Simple map type reference set (foundation metadata concept) */
		rf1Map.put("900000000000497000", null); /* CTV3 simple map reference set (foundation metadata concept) */
		rf1Map.put("900000000000498005", null); /* SNOMED RT identifier simple map (foundation metadata concept) */
		rf1Map.put("900000000000506000", null); /* Language type reference set (foundation metadata concept) */
		rf1Map.put("900000000000507009", null); /* English [International Organization for Standardization 639-1 code en] language reference set (foundation metadata concept) */
		rf1Map.put("900000000000512005", null); /* Query specification type reference set (foundation metadata concept) */
		rf1Map.put("900000000000513000", null); /* Simple query specification reference set (foundation metadata concept) */
		rf1Map.put("900000000000516008", null); /* Annotation type reference set (foundation metadata concept) */
		rf1Map.put("900000000000517004", null); /* Associated image reference set (foundation metadata concept) */
		rf1Map.put("900000000000521006", null); /* Association type reference set (foundation metadata concept) */
		rf1Map.put("900000000000522004", null); /* Historical association reference set (foundation metadata concept) */
		rf1Map.put("900000000000534007", null); /* Module dependency reference set (foundation metadata concept) */
		rf1Map.put("900000000000538005", null); /* Description format reference set (foundation metadata concept) */

		rf1Map.put("900000000000457003", null); /* Reference set attribute (foundation metadata concept) */
		rf1Map.put("900000000000491004", null); /* Attribute value (foundation metadata concept) */
		rf1Map.put("900000000000410004", null); /* Refinability value (foundation metadata concept) */
		rf1Map.put("900000000000007000", (byte) 0); /* Not refinable (foundation metadata concept) */
		rf1Map.put("900000000000392005", (byte) 1); /* Optional refinability (foundation metadata concept) */
		rf1Map.put("900000000000391003", (byte) 2); /* Mandatory refinability (foundation metadata concept) */
		rf1Map.put("900000000000481005", null); /* Concept inactivation value (foundation metadata concept) */
		rf1Map.put("900000000000482003", (byte) 2); /* Duplicate component (foundation metadata concept) */
		rf1Map.put("900000000000483008", (byte) 3); /* Outdated component (foundation metadata concept) */
		rf1Map.put("900000000000484002", (byte) 4); /* Ambiguous component (foundation metadata concept) */
		rf1Map.put("900000000000485001", (byte) 5); /* Erroneous component (foundation metadata concept) */
		rf1Map.put("900000000000486000", (byte) 6); /* Limited component (foundation metadata concept) */
		rf1Map.put("900000000000487009", (byte) 10); /* Component moved elsewhere (foundation metadata concept) */
		rf1Map.put("900000000000492006", (byte) 11); /* Pending move (foundation metadata concept) */
		rf1Map.put("900000000000493001", null); /* Description inactivation value (foundation metadata concept) */
		rf1Map.put("900000000000482003", (byte) 2); /* Duplicate component (foundation metadata concept) */
		rf1Map.put("900000000000483008", (byte) 3); /* Outdated component (foundation metadata concept) */
		rf1Map.put("900000000000485001", (byte) 5); /* Erroneous component (foundation metadata concept) */
		rf1Map.put("900000000000486000", (byte) 6); /* Limited component (foundation metadata concept) */
		rf1Map.put("900000000000494007", (byte) 7); /* Inappropriate component (foundation metadata concept) */
		rf1Map.put("900000000000495008", (byte) 8); /* Concept non-current (foundation metadata concept) */
		rf1Map.put("900000000000487009", (byte) 10); /* Component moved elsewhere (foundation metadata concept) */
		rf1Map.put("900000000000492006", (byte) 11); /* Pending move (foundation metadata concept) */
		rf1Map.put("900000000000546006", null); /* Inactive value (foundation metadata concept) */
		rf1Map.put("900000000000545005", null); /* Active value (foundation metadata concept) */
		rf1Map.put("900000000000458008", null); /* Attribute description (foundation metadata concept) */
		rf1Map.put("900000000000459000", null); /* Attribute type (foundation metadata concept) */
		rf1Map.put("900000000000460005", null); /* Component type (foundation metadata concept) */
		rf1Map.put("900000000000461009", null); /* Concept type component (foundation metadata concept) */
		rf1Map.put("900000000000462002", null); /* Description type component (foundation metadata concept) */
		rf1Map.put("900000000000463007", null); /* Relationship type component (foundation metadata concept) */
		rf1Map.put("900000000000464001", null); /* Reference set member type component (foundation metadata concept) */
		rf1Map.put("900000000000465000", null); /* String (foundation metadata concept) */
		rf1Map.put("900000000000466004", null); /* Text (foundation metadata concept) */
		rf1Map.put("900000000000469006", null); /* Uniform resource locator (foundation metadata concept) */
		rf1Map.put("900000000000474003", null); /* Universally Unique Identifier (foundation metadata concept) */
		rf1Map.put("900000000000475002", null); /* Time (foundation metadata concept) */
		rf1Map.put("900000000000476001", null); /* Integer (foundation metadata concept) */
		rf1Map.put("900000000000477005", null); /* Signed integer (foundation metadata concept) */
		rf1Map.put("900000000000478000", null); /* Unsigned integer (foundation metadata concept) */
		rf1Map.put("900000000000479008", null); /* Attribute order (foundation metadata concept) */
		rf1Map.put("900000000000499002", null); /* Scheme value (foundation metadata concept) */
		rf1Map.put("900000000000500006", null); /* Map source concept (foundation metadata concept) */
		rf1Map.put("900000000000501005", null); /* Map group (foundation metadata concept) */
		rf1Map.put("900000000000502003", null); /* Map priority (foundation metadata concept) */
		rf1Map.put("900000000000503008", null); /* Map rule (foundation metadata concept) */
		rf1Map.put("900000000000504002", null); /* Map advice (foundation metadata concept) */
		rf1Map.put("900000000000505001", null); /* Map target (foundation metadata concept) */
		rf1Map.put("900000000000510002", null); /* Description in dialect (foundation metadata concept) */
		rf1Map.put("900000000000511003", null); /* Acceptability (foundation metadata concept) */
		rf1Map.put("900000000000548007", (byte) 1); /* Preferred (foundation metadata concept) */
		rf1Map.put("900000000000549004", (byte) 2); /* Acceptable (foundation metadata concept) */
		rf1Map.put("900000000000514006", null); /* Generated reference set (foundation metadata concept) */
		rf1Map.put("900000000000515007", null); /* Query (foundation metadata concept) */
		rf1Map.put("900000000000518009", null); /* Annotated component (foundation metadata concept) */
		rf1Map.put("900000000000519001", null); /* Annotation (foundation metadata concept) */
		rf1Map.put("900000000000520007", null); /* Image (foundation metadata concept) */
		rf1Map.put("900000000000532006", null); /* Association source component (foundation metadata concept) */
		rf1Map.put("900000000000533001", null); /* Association target component (foundation metadata concept) */
		rf1Map.put("900000000000535008", null); /* Dependency target (foundation metadata concept) */
		rf1Map.put("900000000000536009", null); /* Source effective time (foundation metadata concept) */
		rf1Map.put("900000000000537000", null); /* Target effective time (foundation metadata concept) */
		rf1Map.put("900000000000539002", null); /* Description format (foundation metadata concept) */
		rf1Map.put("900000000000540000", null); /* Plain text (foundation metadata concept) */
		rf1Map.put("900000000000541001", null); /* Limited HyperText Markup Language (foundation metadata concept) */
		rf1Map.put("900000000000542008", null); /* Extensible HyperText Markup Language (foundation metadata concept) */
		rf1Map.put("900000000000543003", null); /* Darwin Information Typing Architecture (foundation metadata concept) */
		rf1Map.put("900000000000544009", null); /* Description length (foundation metadata concept) */
	}

	public static Byte getMagicNumber(String sctid) {
		if (rf1Map.containsKey(sctid)) {
			return rf1Map.get(sctid);
		}
		return null;
	}

	private static Map<String, String> sourceMap = new HashMap<String, String>();
	static {
		sourceMap.put("900000000000207008","CORE"); /* SNOMED CT core module (core metadata concept) */
		sourceMap.put("900000000000012004","META"); /* SNOMED CT model component module (core metadata concept) */
		sourceMap.put("999000011000000103","UKEX"); /* SNOMED CT United Kingdom clinical extension module (core metadata concept) */
		sourceMap.put("999000011000001104","UKDG"); /* SNOMED CT United Kingdom drug extension module (core metadata concept) */
		sourceMap.put("999000021000000109","UKXR"); /* SNOMED CT United Kingdom clinical extension reference set module (core metadata concept) */
		sourceMap.put("999000021000001108","UKDR"); /* SNOMED CT United Kingdom pharmacy extension reference set module (core metadata concept) */
	}	
	
	public static String getModuleSource(String sctid) {
		if (sourceMap.containsKey(sctid)) {
			return sourceMap.get(sctid);
		}
		return "ERRR";
	}

	public static byte translateActive(boolean rf2Active) {
		return rf2Active ? (byte) 0 : (byte) 1;
	}

	public static byte translateDescType(String sctid) {
		return sctid.equals(FSN) ? (byte) 3 : (byte) 2;
	}

	public static byte translateCaseSensitive(String sctid) {
		return sctid.equals(ENTIRE_TERM_CS) ? (byte) 1 : (byte) 0;
	}
	
	public static byte translateRefinability(String characteristicType) {
		// Qualifying Relationships (1) are Mandatory Refinable (2)
		// everything else is no refinable (0)
		return characteristicType.equals(1) ? (byte) 2 : (byte) 0;
	}

	public static byte translateCharacteristic(String sctid) {
		switch (sctid) {
			case STATED: return 1;
			case INFERRED: return 0;
			case ADDITIONAL: return 3;
		}
		return 9;  //Invalid value
	}
}
