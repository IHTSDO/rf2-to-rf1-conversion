/*
Title        : SNOMED CT Release Format 2 - Table Schema
Author       : Jeremy Rogers
Date         : 3rd April 2014
Copyright    : Crown Coyright
Source       : United Kingdom Terminology Centre, Data Standards and Products, NHS Technology Office
License      : Open Government License http://www.nationalarchives.gov.uk/doc/open-government-licence/
Purpose      : Define a table schema into which to load an RF2 FULL release
*/

DELIMITER $$

DROP PROCEDURE IF EXISTS `snomed`.`RF2_CreateTables` $$

CREATE PROCEDURE snomed.RF2_CreateTables(strOPT VARCHAR(10))

BEGIN

SET @strSchema = strOPT;

IF @strSchema = '' THEN 
	SET @strSchema = 'FULL';
END IF;

INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '  START Create RF2 table schema', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

IF @strSchema IN ('ALL','SNAPSHOT') THEN

	DROP TABLE IF EXISTS snomed.rf2_concept;
	DROP TABLE IF EXISTS snomed.rf2_rel;
	DROP TABLE IF EXISTS snomed.rf2_statedrel;
	DROP TABLE IF EXISTS snomed.rf2_term;
	DROP TABLE IF EXISTS snomed.rf2_identifier;
	DROP TABLE IF EXISTS snomed.rf2_def;
	DROP TABLE IF EXISTS snomed.rf2_transitiveclosure;
	DROP TABLE IF EXISTS snomed.rf2_refset;
	DROP TABLE IF EXISTS snomed.rf2_crefset;
	DROP TABLE IF EXISTS snomed.rf2_icrefset;
	DROP TABLE IF EXISTS snomed.rf2_srefset;
	DROP TABLE IF EXISTS snomed.rf2_ccirefset;
	DROP TABLE IF EXISTS snomed.rf2_cirefset;
	DROP TABLE IF EXISTS snomed.rf2_ssrefset;
	DROP TABLE IF EXISTS snomed.rf2_iissscrefset;
	DROP TABLE IF EXISTS snomed.rf2_iisssccrefset;
	DROP TABLE IF EXISTS snomed.rf2_iissscirefset;
	DROP TABLE IF EXISTS snomed.rf2_subset2refset;

	CREATE TABLE snomed.rf2_concept (
	  id VARBINARY (18) NOT NULL,
	  effectiveTime VARBINARY(14) NOT NULL,
	  active BOOLEAN NOT NULL,
	  moduleId VARBINARY(18) NOT NULL,
	  definitionStatusId VARBINARY(18) NOT NULL);

	CREATE TABLE snomed.rf2_term (
	  id VARBINARY (18) NOT NULL,
	  effectiveTime VARBINARY(14) NOT NULL,
	  active BOOLEAN NOT NULL,
	  moduleId VARBINARY(18) NOT NULL,
	  conceptId VARBINARY(18) NOT NULL,
	  languageCode VARBINARY(8) NOT NULL,
	  typeId VARBINARY(18) NOT NULL,
	  term VARCHAR (255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
	  caseSignificanceId VARBINARY(18) NOT NULL);

	CREATE TABLE snomed.rf2_def (
	  id VARBINARY (18) NOT NULL,
	  effectiveTime VARBINARY(14) NOT NULL,
	  active BOOLEAN NOT NULL,
	  moduleId VARBINARY(18) NOT NULL,
	  conceptId VARBINARY(18) NOT NULL,
	  languageCode VARBINARY(8) NOT NULL,
	  typeId VARBINARY(18) NOT NULL,
	  term VARCHAR (450) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
	  caseSignificanceId VARBINARY(18) NOT NULL);

	CREATE TABLE snomed.rf2_rel (
	  id VARBINARY (18) NOT NULL,
	  effectiveTime VARBINARY(14) NOT NULL,
	  active BOOLEAN NOT NULL,
	  moduleId VARBINARY(18) NOT NULL,
	  sourceId VARBINARY(18) NOT NULL,
	  destinationId VARBINARY(18) NOT NULL,
	  relationshipGroup INT NOT NULL,
	  typeId VARBINARY(18) NOT NULL,
	  characteristicTypeId VARBINARY(18) NOT NULL,
	  modifierId VARBINARY(18) NOT NULL);

	CREATE TABLE snomed.rf2_identifier (
	  identifierSchemeId VARBINARY (18) NOT NULL,           /* From metadata hierarchy */
	  alternateIdentifier VARCHAR(100) BINARY NOT NULL,
	  effectiveTime VARBINARY(14) NOT NULL,
	  active BOOLEAN NOT NULL,
	  moduleId VARBINARY(18) NOT NULL,
	  referencedComponentId VARBINARY(18) NOT NULL);

	CREATE TABLE snomed.rf2_transitiveclosure (
		  subtypeId VARBINARY(18) NOT NULL,
		  supertypeId VARBINARY(18) NOT NULL,
		  effectiveTime VARBINARY(14) NOT NULL,
		  active BOOLEAN NOT NULL);

	CREATE TABLE snomed.rf2_refset (
	  id VARCHAR(38) BINARY NOT NULL,  /* UUID instead of MemberID */
	  effectiveTime VARBINARY(14) NOT NULL,
	  active BOOLEAN NOT NULL,
	  moduleId VARBINARY(18) NOT NULL,
	  refSetId VARBINARY(18) NOT NULL,  /* From metadata hierarchy */
	  referencedComponentId VARBINARY(18) NOT NULL);

	CREATE TABLE snomed.rf2_crefset (
	  id VARCHAR(38) BINARY NOT NULL,  /* UUID instead of MemberID */
	  effectiveTime VARBINARY(14) NOT NULL,
	  active BOOLEAN NOT NULL,
	  moduleId VARBINARY(18) NOT NULL,
	  refSetId VARBINARY(18) NOT NULL,  /* From metadata hierarchy */
	  referencedComponentId VARBINARY(18) NOT NULL,
	  linkedComponentId VARBINARY(18) NOT NULL);

	CREATE TABLE snomed.rf2_icrefset (
	  id VARCHAR(38) BINARY NOT NULL,  /* UUID instead of MemberID */
	  effectiveTime VARBINARY(14) NOT NULL,
	  active BOOLEAN NOT NULL,
	  moduleId VARBINARY(18) NOT NULL,
	  refSetId VARBINARY(18) NOT NULL,  /* From metadata hierarchy */
	  referencedComponentId VARBINARY(18) NOT NULL,
	  componentOrder TINYINT NOT NULL,
	  LinkedTo TINYINT NOT NULL);

	CREATE TABLE snomed.rf2_srefset (
	  id VARCHAR(38) BINARY NOT NULL,  /* UUID instead of MemberID */
	  effectiveTime VARBINARY(14) NOT NULL,
	  active BOOLEAN NOT NULL,
	  moduleId VARBINARY(18) NOT NULL,
	  refSetId VARBINARY(18) NOT NULL,  /* From metadata hierarchy */
	  referencedComponentId VARBINARY(18) NOT NULL,
	  linkedString VARCHAR(255) NOT NULL);

	CREATE TABLE snomed.rf2_ccirefset (
	  id VARCHAR(38) BINARY NOT NULL,  /* UUID instead of MemberID */
	  effectiveTime VARBINARY(14) NOT NULL,
	  active BOOLEAN NOT NULL,
	  moduleId VARBINARY(18) NOT NULL,
	  refSetId VARBINARY(18) NOT NULL,  /* From metadata hierarchy */
	  referencedComponentId VARBINARY(18) NOT NULL,
	  linkedComponentId1 VARBINARY(18) NOT NULL,
	  linkedComponentId2 VARBINARY(18) NOT NULL,
	  linkedInteger INT NOT NULL);

	CREATE TABLE snomed.rf2_cirefset (
	  id VARCHAR(38) BINARY NOT NULL,  /* UUID instead of MemberID */
	  effectiveTime VARBINARY(14) NOT NULL,
	  active BOOLEAN NOT NULL,
	  moduleId VARBINARY(18) NOT NULL,
	  refSetId VARBINARY(18) NOT NULL,  /* From metadata hierarchy */
	  referencedComponentId VARBINARY(18) NOT NULL,
	  linkedComponentId VARBINARY(18) NOT NULL,
	  linkedInteger INT NOT NULL);

	CREATE TABLE snomed.rf2_ssrefset (
	  id VARCHAR(38) BINARY NOT NULL,  /* UUID instead of MemberID */
	  effectiveTime VARBINARY(14) NOT NULL,
	  active BOOLEAN NOT NULL,
	  moduleId VARBINARY(18) NOT NULL,
	  refSetId VARBINARY(18) NOT NULL,  /* From metadata hierarchy */
	  referencedComponentId VARBINARY(18) NOT NULL,
	  linkedString1 VARCHAR(255) NOT NULL,
	  linkedString2 VARCHAR(255) NOT NULL);

	CREATE TABLE snomed.rf2_iissscrefset (
	  id VARCHAR(38) BINARY NOT NULL,  /* UUID instead of MemberID */
	  effectiveTime VARBINARY(14) NOT NULL,
	  active BOOLEAN NOT NULL,
	  moduleId VARBINARY(18) NOT NULL,
	  refSetId VARBINARY(18) NOT NULL,  /* From metadata hierarchy */
	  referencedComponentId VARBINARY(18) NOT NULL,
	  mapGroup TINYINT NOT NULL,
	  mapPriority TINYINT NOT NULL,
	  mapRule VARCHAR(255) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
	  mapAdvice VARCHAR(255) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
	  mapTarget VARCHAR(255) CHARACTER SET latin1 COLLATE latin1_general_ci,
	  corelationId VARBINARY(18) NOT NULL);

	CREATE TABLE snomed.rf2_iisssccrefset (
	  id VARCHAR(38) BINARY NOT NULL,  /* UUID instead of MemberID */
	  effectiveTime VARBINARY(14) NOT NULL,
	  active BOOLEAN NOT NULL,
	  moduleId VARBINARY(18) NOT NULL,
	  refSetId VARBINARY(18) NOT NULL,  /* From metadata hierarchy */
	  referencedComponentId VARBINARY(18) NOT NULL,
	  mapGroup TINYINT NOT NULL,
	  mapPriority TINYINT NOT NULL,
	  mapRule VARCHAR(255) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
	  mapAdvice VARCHAR(512) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
	  mapTarget VARCHAR(255) CHARACTER SET latin1 COLLATE latin1_general_ci,
	  corelationId VARBINARY(18) NOT NULL,
	  mapCategoryId VARBINARY(18) NOT NULL);

	CREATE TABLE snomed.rf2_iissscirefset (
	  id VARCHAR(38) BINARY NOT NULL,  /* UUID instead of MemberID */
	  effectiveTime VARBINARY(14) NOT NULL,
	  active BOOLEAN NOT NULL,
	  moduleId VARBINARY(18) NOT NULL,
	  refSetId VARBINARY(18) NOT NULL,  /* From metadata hierarchy */
	  referencedComponentId VARBINARY(18) NOT NULL,
	  mapGroup TINYINT NOT NULL,
	  mapPriority INT NOT NULL,
	  mapRule VARCHAR(255) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
	  mapAdvice VARCHAR(255) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
	  mapTarget VARCHAR(255) CHARACTER SET latin1 COLLATE latin1_general_ci,
	  corelationId VARBINARY(18) NOT NULL,
	  mapBlock TINYINT NOT NULL);

	CREATE TABLE snomed.rf2_subset2refset (
	  OriginalSubsetId VARBINARY(18) NOT NULL,
	  SubsetName VARCHAR(255) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
	  refsetId VARBINARY(18) NOT NULL,
      FSN VARCHAR(255) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
      Location VARCHAR(255) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL);

END IF;

IF @strSchema IN ('ALL','SV','STATEVALID') THEN
	DROP TABLE IF EXISTS snomed.rf2_concept_sv;
	DROP TABLE IF EXISTS snomed.rf2_rel_sv;
	DROP TABLE IF EXISTS snomed.rf2_term_sv;
	DROP TABLE IF EXISTS snomed.rf2_identifier_sv;
	DROP TABLE IF EXISTS snomed.rf2_def_sv;
	DROP TABLE IF EXISTS snomed.rf2_refset_sv;
	DROP TABLE IF EXISTS snomed.rf2_crefset_sv;
	DROP TABLE IF EXISTS snomed.rf2_icrefset_sv;
	DROP TABLE IF EXISTS snomed.rf2_srefset_sv;
	DROP TABLE IF EXISTS snomed.rf2_ccirefset_sv;
	DROP TABLE IF EXISTS snomed.rf2_cirefset_sv;
	DROP TABLE IF EXISTS snomed.rf2_ssrefset_sv;
	DROP TABLE IF EXISTS snomed.rf2_iissscrefset_sv;
	DROP TABLE IF EXISTS snomed.rf2_iisssccrefset_sv;
	DROP TABLE IF EXISTS snomed.rf2_iissscirefset_sv;

	CREATE TABLE snomed.rf2_concept_sv LIKE snomed.rf2_concept;
	CREATE TABLE snomed.rf2_rel_sv LIKE snomed.rf2_rel;
	CREATE TABLE snomed.rf2_term_sv LIKE snomed.rf2_term;
	CREATE TABLE snomed.rf2_identifier_sv LIKE snomed.rf2_identifier;
	CREATE TABLE snomed.rf2_def_sv LIKE snomed.rf2_def;
	CREATE TABLE snomed.rf2_refset_sv LIKE snomed.rf2_refset;
	CREATE TABLE snomed.rf2_crefset_sv LIKE snomed.rf2_crefset;
	CREATE TABLE snomed.rf2_icrefset_sv LIKE snomed.rf2_icrefset;
	CREATE TABLE snomed.rf2_srefset_sv LIKE snomed.rf2_srefset;
	CREATE TABLE snomed.rf2_ccirefset_sv LIKE snomed.rf2_ccirefset;
	CREATE TABLE snomed.rf2_cirefset_sv LIKE snomed.rf2_cirefset;
	CREATE TABLE snomed.rf2_ssrefset_sv LIKE snomed.rf2_ssrefset;
	CREATE TABLE snomed.rf2_iissscrefset_sv LIKE snomed.rf2_iissscrefset;
	CREATE TABLE snomed.rf2_iisssccrefset_sv LIKE snomed.rf2_iisssccrefset;
	CREATE TABLE snomed.rf2_iissscirefset_sv LIKE snomed.rf2_iissscirefset;
END IF;

IF @strSchema IN ('ALL','SP') THEN
	DROP TABLE IF EXISTS snomed.rf2_concept_sp;
	DROP TABLE IF EXISTS snomed.rf2_rel_sp;
	DROP TABLE IF EXISTS snomed.rf2_term_sp;
	DROP TABLE IF EXISTS snomed.rf2_identifier_sp;
	DROP TABLE IF EXISTS snomed.rf2_def_sp;
	DROP TABLE IF EXISTS snomed.rf2_refset_sp;
	DROP TABLE IF EXISTS snomed.rf2_crefset_sp;
	DROP TABLE IF EXISTS snomed.rf2_icrefset_sp;
	DROP TABLE IF EXISTS snomed.rf2_srefset_sp;
	DROP TABLE IF EXISTS snomed.rf2_ccirefset_sp;
	DROP TABLE IF EXISTS snomed.rf2_cirefset_sp;
	DROP TABLE IF EXISTS snomed.rf2_ssrefset_sp;
	DROP TABLE IF EXISTS snomed.rf2_iissscrefset_sp;
	DROP TABLE IF EXISTS snomed.rf2_iisssccrefset_sp;
	DROP TABLE IF EXISTS snomed.rf2_iissscirefset_sp;

	CREATE TABLE snomed.rf2_concept_sp LIKE snomed.rf2_concept;
	CREATE TABLE snomed.rf2_rel_sp LIKE snomed.rf2_rel;
	CREATE TABLE snomed.rf2_term_sp LIKE snomed.rf2_term;
	CREATE TABLE snomed.rf2_identifier_sp LIKE snomed.rf2_identifier;
	CREATE TABLE snomed.rf2_def_sp LIKE snomed.rf2_def;
	CREATE TABLE snomed.rf2_refset_sp LIKE snomed.rf2_refset;
	CREATE TABLE snomed.rf2_crefset_sp LIKE snomed.rf2_crefset;
	CREATE TABLE snomed.rf2_icrefset_sp LIKE snomed.rf2_icrefset;
	CREATE TABLE snomed.rf2_srefset_sp LIKE snomed.rf2_srefset;
	CREATE TABLE snomed.rf2_ccirefset_sp LIKE snomed.rf2_ccirefset;
	CREATE TABLE snomed.rf2_cirefset_sp LIKE snomed.rf2_cirefset;
	CREATE TABLE snomed.rf2_ssrefset_sp LIKE snomed.rf2_ssrefset;
	CREATE TABLE snomed.rf2_iissscrefset_sp LIKE snomed.rf2_iissscrefset;
	CREATE TABLE snomed.rf2_iisssccrefset_sp LIKE snomed.rf2_iisssccrefset;
	CREATE TABLE snomed.rf2_iissscirefset_sp LIKE snomed.rf2_iissscirefset;
END IF;

INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '  END Create RF2 table schema', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

END $$

DROP PROCEDURE IF EXISTS `snomed`.`RF2_CreateIndexes` $$

CREATE PROCEDURE snomed.RF2_CreateIndexes()

BEGIN

INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '  START Index RF2 table schemas', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '    START Index IHTSDO RF2 State Valid Tables', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

	INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '      INDEXING Concept.ID', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
	CREATE INDEX ID_X ON snomed.rf2_concept_sv(ID);
	INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '      INDEXING Term.ID', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
	CREATE INDEX ID_X ON snomed.rf2_term_sv(ID);
	CREATE INDEX ID_X ON snomed.rf2_def_sv(ID);
	INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '      INDEXING Rel.ID', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
	CREATE INDEX ID_X ON snomed.rf2_rel_sv(ID);
	INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '      INDEXING Identifier.ID', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
	CREATE INDEX ID_X ON snomed.rf2_identifier_sv(referencedComponentId,identifierSchemeId);
	INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '      INDEXING RefSet iDs', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
	CREATE INDEX ID_X ON snomed.rf2_refset_sv(ID);
	CREATE INDEX ID_X ON snomed.rf2_crefset_sv(ID);
	CREATE INDEX ID_X ON snomed.rf2_icrefset_sv(ID);
	CREATE INDEX ID_X ON snomed.rf2_ccirefset_sv(ID);
	CREATE INDEX ID_X ON snomed.rf2_cirefset_sv(ID);
	CREATE INDEX ID_X ON snomed.rf2_srefset_sv(ID);
	CREATE INDEX ID_X ON snomed.rf2_ssrefset_sv(ID);
	CREATE INDEX ID_X ON snomed.rf2_iissscrefset_sv(ID);
	CREATE INDEX ID_X ON snomed.rf2_iissscirefset_sv(ID);

INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '    END Index IHTSDO RF2 State Valid Tables', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '    START Index IHTSDO RF2 Snapshot Tables', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

	INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '      INDEXING Concept.ID', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
	CREATE INDEX ID_X ON snomed.rf2_concept_sp(ID);
	INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '      INDEXING Term.ID', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
	CREATE INDEX ID_X ON snomed.rf2_term_sp(ID);
	CREATE INDEX ID_X ON snomed.rf2_def_sp(ID);
	INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '      INDEXING Rel.ID', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
	CREATE INDEX ID_X ON snomed.rf2_rel_sp(ID);
	INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '       INDEXING Identifier.ID', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
	CREATE INDEX ID_X ON snomed.rf2_identifier_sp(referencedComponentId,identifierSchemeId);
	INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '      INDEXING RefSet iDs', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
	CREATE INDEX ID_X ON snomed.rf2_refset_sp(ID);
	CREATE INDEX ID_X ON snomed.rf2_crefset_sp(ID);
	CREATE INDEX ID_X ON snomed.rf2_icrefset_sp(ID);
	CREATE INDEX ID_X ON snomed.rf2_ccirefset_sp(ID);
	CREATE INDEX ID_X ON snomed.rf2_cirefset_sp(ID);
	CREATE INDEX ID_X ON snomed.rf2_srefset_sp(ID);
	CREATE INDEX ID_X ON snomed.rf2_ssrefset_sp(ID);
	CREATE INDEX ID_X ON snomed.rf2_iissscrefset_sp(ID);
	CREATE INDEX ID_X ON snomed.rf2_iissscirefset_sp(ID);

	INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '      INDEXING Concept.ConceptStatus', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
	CREATE INDEX CONCEPT_STAT_X ON snomed.rf2_concept_sp(definitionStatusId);
	INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '      INDEXING Term.ConceptID', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
	CREATE INDEX TERM_CUI_X ON snomed.rf2_term_sp(conceptId);
	#INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '  INDEXING Term.LanguageCode', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
	#CREATE INDEX TERM_LANG_X ON snomed.rf2_term_sp(languageCode);
	INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '      INDEXING Term.Term', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
	CREATE INDEX TERM_TERM_X ON snomed.rf2_term_sp(Term);
	INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '      INDEXING Rel.ConceptID1', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
	CREATE INDEX REL_CUI1_X ON snomed.rf2_rel_sp(sourceId);
	INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '      INDEXING Rel.RelationshipType', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
	CREATE INDEX REL_RELATION_X ON snomed.rf2_rel_sp(typeId);
	INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '      INDEXING Rel.ConceptID2', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
	CREATE INDEX REL_CUI2_X ON snomed.rf2_rel_sp(destinationId);
	INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '      INDEXING Rel.CharacteristicType', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
	CREATE INDEX REL_CHARTYPE_X ON snomed.rf2_rel_sp(characteristicTypeId);
	INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '      INDEXING RefSet.refsetId', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
	CREATE INDEX ref_X ON snomed.rf2_refset_sp(refsetId);
	CREATE INDEX ref_X ON snomed.rf2_crefset_sp(refsetId);
	CREATE INDEX ref_X ON snomed.rf2_icrefset_sp(refsetId);
	CREATE INDEX ref_X ON snomed.rf2_srefset_sp(refsetId);
	CREATE INDEX ref_X ON snomed.rf2_ccirefset_sp(refsetId);
	CREATE INDEX ref_X ON snomed.rf2_cirefset_sp(refsetId);
	CREATE INDEX ref_X ON snomed.rf2_ssrefset_sp(refsetId);
	CREATE INDEX ref_X ON snomed.rf2_iissscrefset_sp(refsetId);
	CREATE INDEX ref_X ON snomed.rf2_iissscirefset_sp(refsetId);
	INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '      INDEXING RefSet.referencedComponentId', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
	CREATE INDEX CUI_X ON snomed.rf2_refset_sp(referencedComponentId);
	CREATE INDEX CUI_X ON snomed.rf2_crefset_sp(referencedComponentId);
	CREATE INDEX CUI_X ON snomed.rf2_icrefset_sp(referencedComponentId);
	CREATE INDEX CUI_X ON snomed.rf2_srefset_sp(referencedComponentId);
	CREATE INDEX CUI_X ON snomed.rf2_ccirefset_sp(referencedComponentId);
	CREATE INDEX CUI_X ON snomed.rf2_cirefset_sp(referencedComponentId);
	CREATE INDEX CUI_X ON snomed.rf2_ssrefset_sp(referencedComponentId);
	CREATE INDEX CUI_X ON snomed.rf2_iissscrefset_sp(referencedComponentId);
	CREATE INDEX CUI_X ON snomed.rf2_iissscirefset_sp(referencedComponentId);
	INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '      INDEXING RefSet.linkedComponentIds', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
	CREATE INDEX LUI_X ON snomed.rf2_crefset_sp(linkedComponentId);
	CREATE INDEX LUI_X ON snomed.rf2_cirefset_sp(linkedComponentId);
	CREATE INDEX LUI1_X ON snomed.rf2_ccirefset_sp(linkedComponentId2);
	CREATE INDEX LUI2_X ON snomed.rf2_ccirefset_sp(linkedComponentId1);
	CREATE INDEX LUI_X ON snomed.rf2_iissscrefset_sp(corelationID);
	CREATE INDEX LUI_X ON snomed.rf2_iissscirefset_sp(corelationID);

INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '    END Index IHTSDO RF2 Snapshot Tables', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

	CREATE INDEX r_x ON snomed.RF2_subset2refset(refsetID);

INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '  END Index RF2 table schemas', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

END $$

DELIMITER ;
