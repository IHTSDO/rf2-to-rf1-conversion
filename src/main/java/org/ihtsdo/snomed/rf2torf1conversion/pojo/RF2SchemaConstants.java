package org.ihtsdo.snomed.rf2torf1conversion.pojo;

public interface RF2SchemaConstants {

	public final Long SNOMED_ROOT_CONCEPT = 138875005L;
	public final String ADDITIONAL_RELATIONSHIP = "900000000000227009";
	public final String LATERALITY_ATTRIB = "272741003";
	public final String LATERALITY_REFSET_ID = "703870008";
	public final String SIDE_VALUE = "182353008";	
	// id effectiveTime active moduleId sourceId destinationId relationshipGroup typeId characteristicTypeId modifierId
	public static final String ISA = "116680003";
	public static final Long ISA_ID = Long.parseLong(ISA);
	
	public static final String UNGROUPED = "0";
	
	public static int EFFECTIVE_DATE_PART_YEAR = 0;
	public static int EFFECTIVE_DATE_PART_MONTH = 1;
	public static int EFFECTIVE_DATE_PART_DAY = 2;

	public static final String CHARACTERISTIC_STATED_SCTID = "900000000000010007";
	public static final String FIELD_DELIMITER = "\t";
	public static final String LINE_DELIMITER = "\r\n";
	public static final String ACTIVE_FLAG = "1";
	public static final String INACTIVE_FLAG = "0";
	public static final String HEADER_ROW = "id\teffectiveTime\tactive\tmoduleId\tsourceId\tdestinationId\trelationshipGroup\ttypeId\tcharacteristicTypeId\tmodifierId\r\n";

	// Relationship columns
	public static final int REL_IDX_ID = 0;
	public static final int REL_IDX_EFFECTIVETIME = 1;
	public static final int REL_IDX_ACTIVE = 2;
	public static final int REL_IDX_MODULEID = 3;
	public static final int REL_IDX_SOURCEID = 4;
	public static final int REL_IDX_DESTINATIONID = 5;
	public static final int REL_IDX_RELATIONSHIPGROUP = 6;
	public static final int REL_IDX_TYPEID = 7;
	public static final int REL_IDX_CHARACTERISTICTYPEID = 8;
	public static final int REL_IDX_MODIFIERID = 9;
	public static final int REL_MAX_COLUMN = 9;

	// Concept columns
	// id effectiveTime active moduleId definitionStatusId
	public static final int CON_IDX_ID = 0;
	public static final int CON_IDX_EFFECTIVETIME = 1;
	public static final int CON_IDX_ACTIVE = 2;
	public static final int CON_IDX_MODULID = 3;
	public static final int CON_IDX_DEFINITIONSTATUSID = 4;

	// Description columns
	// id effectiveTime active moduleId conceptId languageCode typeId term caseSignificanceId
	public static final int DES_IDX_ID = 0;
	public static final int DES_IDX_EFFECTIVETIME = 1;
	public static final int DES_IDX_ACTIVE = 2;
	public static final int DES_IDX_MODULID = 3;
	public static final int DES_IDX_CONCEPTID = 4;
	public static final int DES_IDX_LANGUAGECODE = 5;
	public static final int DES_IDX_TYPEID = 6;
	public static final int DES_IDX_TERM = 7;
	public static final int DES_IDX_CASESIGNIFICANCEID = 8;
	
	// Simple Refset columns
	// id effectiveTime active moduleId refsetId referencedComponentId
	public static final int SIMP_IDX_ID = 0;
	public static final int SIMP_IDX_EFFECTIVETIME = 1;
	public static final int SIMP_IDX_ACTIVE = 2;
	public static final int SIMP_IDX_MODULID = 3;
	public static final int SIMP_IDX_REFSETID = 4;
	public static final int SIMP_IDX_REFCOMPID = 5;

	public static final String FULLY_DEFINED_SCTID = "900000000000073002";
	public static final String FULLY_SPECIFIED_NAME = "900000000000003001";

	public static enum CHARACTERISTIC {
		STATED, INFERRED, ADDITIONAL, QUALIFYING
	};
}
