
	CREATE TABLE rf2_concept (
		id BIGINT NOT NULL,
		effectiveTime BIGINT NOT NULL,
		active BOOLEAN NOT NULL,
		moduleId BIGINT NOT NULL,
		definitionStatusId BIGINT NOT NULL);

	CREATE TABLE rf2_term (
		id BIGINT NOT NULL,
		effectiveTime BIGINT NOT NULL,
		active BOOLEAN NOT NULL,
		moduleId BIGINT NOT NULL,
		conceptId BIGINT NOT NULL,
		languageCode VARCHAR(2) NOT NULL,
		typeId BIGINT NOT NULL,
		term VARCHAR (255) NOT NULL,
		caseSignificanceId BIGINT NOT NULL);

	CREATE TABLE rf2_def (
		id BIGINT NOT NULL,
		effectiveTime BIGINT NOT NULL,
		active BOOLEAN NOT NULL,
		moduleId BIGINT NOT NULL,
		conceptId BIGINT NOT NULL,
		languageCode VARCHAR(2) NOT NULL,
		typeId BIGINT NOT NULL,
		term VARCHAR (2048)  NOT NULL,
		caseSignificanceId BIGINT NOT NULL);

	CREATE TABLE rf2_rel (
		id BIGINT NOT NULL,
		effectiveTime BIGINT NOT NULL,
		active BOOLEAN NOT NULL,
		moduleId BIGINT NOT NULL,
		sourceId BIGINT NOT NULL,
		destinationId BIGINT NOT NULL,
		relationshipGroup INT NOT NULL,
		typeId BIGINT NOT NULL,
		characteristicTypeId BIGINT NOT NULL,
		modifierId BIGINT NOT NULL);

	CREATE TABLE rf2_identifier (
		identifierSchemeId BIGINT NOT NULL,
		alternateIdentifier VARCHAR(100) NOT NULL,
		effectiveTime BIGINT NOT NULL,
		active BOOLEAN NOT NULL,
		moduleId BIGINT NOT NULL,
		referencedComponentId BIGINT NOT NULL);

	CREATE TABLE rf2_transitiveclosure (
		subtypeId BIGINT NOT NULL,
		supertypeId BIGINT NOT NULL,
		effectiveTime BIGINT NOT NULL,
		active BOOLEAN NOT NULL);

	CREATE TABLE rf2_refset (
		id VARCHAR(38) NOT NULL,
		effectiveTime BIGINT NOT NULL,
		active BOOLEAN NOT NULL,
		moduleId BIGINT NOT NULL,
		refSetId BIGINT NOT NULL,	
		referencedComponentId BIGINT NOT NULL);

	CREATE TABLE rf2_crefset (
		id VARCHAR(38) NOT NULL,
		effectiveTime BIGINT NOT NULL,
		active BOOLEAN NOT NULL,
		moduleId BIGINT NOT NULL,
		refSetId BIGINT NOT NULL,	
		referencedComponentId BIGINT NOT NULL,
		linkedComponentId BIGINT NOT NULL);

	CREATE TABLE rf2_icrefset (
		id VARCHAR(38) NOT NULL,
		effectiveTime BIGINT NOT NULL,
		active BOOLEAN NOT NULL,
		moduleId BIGINT NOT NULL,
		refSetId BIGINT NOT NULL,	
		referencedComponentId BIGINT NOT NULL,
		componentOrder TINYINT NOT NULL,
		LinkedTo TINYINT NOT NULL);

	CREATE TABLE rf2_srefset (
		id VARCHAR(38) NOT NULL,
		effectiveTime BIGINT NOT NULL,
		active BOOLEAN NOT NULL,
		moduleId BIGINT NOT NULL,
		refSetId BIGINT NOT NULL,	
		referencedComponentId BIGINT NOT NULL,
		linkedString VARCHAR(255) NOT NULL);

	CREATE TABLE rf2_ccirefset (
		id VARCHAR(38) NOT NULL,
		effectiveTime BIGINT NOT NULL,
		active BOOLEAN NOT NULL,
		moduleId BIGINT NOT NULL,
		refSetId BIGINT NOT NULL,	
		referencedComponentId BIGINT NOT NULL,
		linkedComponentId1 BIGINT NOT NULL,
		linkedComponentId2 BIGINT NOT NULL,
		linkedInteger INT NOT NULL);

	CREATE TABLE rf2_cirefset (
		id VARCHAR(38) NOT NULL,
		effectiveTime BIGINT NOT NULL,
		active BOOLEAN NOT NULL,
		moduleId BIGINT NOT NULL,
		refSetId BIGINT NOT NULL,	
		referencedComponentId BIGINT NOT NULL,
		linkedComponentId BIGINT NOT NULL,
		linkedInteger INT NOT NULL);

	CREATE TABLE rf2_ssrefset (
		id VARCHAR(38) NOT NULL,
		effectiveTime BIGINT NOT NULL,
		active BOOLEAN NOT NULL,
		moduleId BIGINT NOT NULL,
		refSetId BIGINT NOT NULL,	
		referencedComponentId BIGINT NOT NULL,
		linkedString1 VARCHAR(255) NOT NULL,
		linkedString2 VARCHAR(255) NOT NULL);

	CREATE TABLE rf2_iissscrefset (
		id VARCHAR(38) NOT NULL,
		effectiveTime BIGINT NOT NULL,
		active BOOLEAN NOT NULL,
		moduleId BIGINT NOT NULL,
		refSetId BIGINT NOT NULL,	
		referencedComponentId BIGINT NOT NULL,
		mapGroup TINYINT NOT NULL,
		mapPriority TINYINT NOT NULL,
		mapRule VARCHAR(255),
		mapAdvice VARCHAR(255),
		mapTarget VARCHAR(255) ,
		corelationId BIGINT NOT NULL);

	CREATE TABLE rf2_iisssccrefset (
		id VARCHAR(38) NOT NULL,
		effectiveTime BIGINT NOT NULL,
		active BOOLEAN NOT NULL,
		moduleId BIGINT NOT NULL,
		refSetId BIGINT NOT NULL,	
		referencedComponentId BIGINT NOT NULL,
		mapGroup TINYINT NOT NULL,
		mapPriority TINYINT NOT NULL,
		mapRule VARCHAR(255),
		mapAdvice VARCHAR(512),
		mapTarget VARCHAR(255) ,
		corelationId BIGINT NOT NULL,
		mapCategoryId BIGINT NOT NULL);

	CREATE TABLE rf2_iissscirefset (
		id VARCHAR(38) NOT NULL,
		effectiveTime BIGINT NOT NULL,
		active BOOLEAN NOT NULL,
		moduleId BIGINT NOT NULL,
		refSetId BIGINT NOT NULL,	
		referencedComponentId BIGINT NOT NULL,
		mapGroup TINYINT NOT NULL,
		mapPriority INT NOT NULL,
		mapRule VARCHAR(255),
		mapAdvice VARCHAR(255),
		mapTarget VARCHAR(255),
		corelationId BIGINT NOT NULL,
		mapBlock TINYINT NOT NULL);

	CREATE TABLE rf2_subset2refset (
		OriginalSubsetId BIGINT NOT NULL,
		SubsetName VARCHAR(255)  NOT NULL,
		refsetId BIGINT NOT NULL,
		FSN VARCHAR(255)  NOT NULL,
		Location VARCHAR(255)  NOT NULL);
		
	CREATE TABLE rf2_concept_sv AS SELECT * FROM rf2_concept where 1 = 0;
	CREATE TABLE rf2_rel_sv AS SELECT * FROM rf2_rel where 1 = 0;
	CREATE TABLE rf2_term_sv AS SELECT * FROM rf2_term where 1 = 0;
	CREATE TABLE rf2_identifier_sv AS SELECT * FROM rf2_identifier where 1 = 0;
	CREATE TABLE rf2_def_sv AS SELECT * FROM rf2_def where 1 = 0;
	CREATE TABLE rf2_refset_sv AS SELECT * FROM rf2_refset where 1 = 0;
	CREATE TABLE rf2_crefset_sv AS SELECT * FROM rf2_crefset where 1 = 0;
	CREATE TABLE rf2_icrefset_sv AS SELECT * FROM rf2_icrefset where 1 = 0;
	CREATE TABLE rf2_srefset_sv AS SELECT * FROM rf2_srefset where 1 = 0;
	CREATE TABLE rf2_ccirefset_sv AS SELECT * FROM rf2_ccirefset where 1 = 0;
	CREATE TABLE rf2_cirefset_sv AS SELECT * FROM rf2_cirefset where 1 = 0;
	CREATE TABLE rf2_ssrefset_sv AS SELECT * FROM rf2_ssrefset where 1 = 0;
	CREATE TABLE rf2_iissscrefset_sv AS SELECT * FROM rf2_iissscrefset where 1 = 0;
	CREATE TABLE rf2_iisssccrefset_sv AS SELECT * FROM rf2_iisssccrefset where 1 = 0;
	CREATE TABLE rf2_iissscirefset_sv AS SELECT * FROM rf2_iissscirefset where 1 = 0;
	
	CREATE TABLE rf2_concept_sp AS SELECT * FROM rf2_concept where 1 = 0;
	CREATE TABLE rf2_rel_sp AS SELECT * FROM rf2_rel where 1 = 0;
	CREATE TABLE rf2_term_sp AS SELECT * FROM rf2_term where 1 = 0;
	CREATE TABLE rf2_identifier_sp AS SELECT * FROM rf2_identifier where 1 = 0;
	CREATE TABLE rf2_def_sp AS SELECT * FROM rf2_def where 1 = 0;
	CREATE TABLE rf2_refset_sp AS SELECT * FROM rf2_refset where 1 = 0;
	CREATE TABLE rf2_crefset_sp AS SELECT * FROM rf2_crefset where 1 = 0;
	CREATE TABLE rf2_icrefset_sp AS SELECT * FROM rf2_icrefset where 1 = 0;
	CREATE TABLE rf2_srefset_sp AS SELECT * FROM rf2_srefset where 1 = 0;
	CREATE TABLE rf2_ccirefset_sp AS SELECT * FROM rf2_ccirefset where 1 = 0;
	CREATE TABLE rf2_cirefset_sp AS SELECT * FROM rf2_cirefset where 1 = 0;
	CREATE TABLE rf2_ssrefset_sp AS SELECT * FROM rf2_ssrefset where 1 = 0;
	CREATE TABLE rf2_iissscrefset_sp AS SELECT * FROM rf2_iissscrefset where 1 = 0;
	CREATE TABLE rf2_iisssccrefset_sp AS SELECT * FROM rf2_iisssccrefset where 1 = 0;
	CREATE TABLE rf2_iissscirefset_sp AS SELECT * FROM rf2_iissscirefset where 1 = 0;	
