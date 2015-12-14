/*
Title        : SNOMED CT Release Format 2 - Populate RF1 Schema
Author       : Jeremy Rogers
Date         : 3rd April 2014
Copyright    : Crown Coyright
Source       : United Kingdom Terminology Centre, Data Standards and Products, NHS Technology Office
License      : Open Government License http://www.nationalarchives.gov.uk/doc/open-government-licence/
Purpose      : Populate an RF1 Scheme a from an RF2 Snapshot
*/

DELIMITER $$

DROP FUNCTION IF EXISTS `magicNumberFor` $$
CREATE FUNCTION magicNumberFor(ID VARBINARY(18))
RETURNS TINYINT
BEGIN

DECLARE MagicNumber TINYINT;

SET MagicNumber = (SELECT CASE ID
  WHEN '900000000000441003' THEN 99 /*SNOMED CT Model Component (metadata)*/
    WHEN '106237007' THEN 99 /*Linkage concept (linkage concept)*/
    WHEN '370136006' THEN 99 /*Namespace concept (namespace concept)*/

    WHEN '900000000000442005' THEN 99 /*Core metadata concept (core metadata concept)*/
      WHEN '900000000000447004' THEN 99 /*Case significance (core metadata concept)*/
        WHEN '900000000000016001' THEN 2 /*AU   Entire term case sensitive (core metadata concept)*/
        WHEN '900000000000017005' THEN 2 /*CORE Entire term case sensitive (core metadata concept)*/
        WHEN '900000000000022005' THEN 1 /*AU   Only initial character case insensitive (core metadata concept)*/
        WHEN '900000000000020002' THEN 1 /*CORE Only initial character case insensitive (core metadata concept)*/
        WHEN '900000000000448009' THEN 0 /*Entire term case insensitive (core metadata concept)*/
      WHEN '900000000000449001' THEN 99 /*Characteristic type (core metadata concept)*/
        WHEN '900000000000006009' THEN 0 /*Defining relationship (core metadata concept)*/
          WHEN '900000000000011006' THEN 0 /*Inferred relationship (core metadata concept)*/
          WHEN '900000000000010007' THEN 10 /*Stated relationship (core metadata concept)*/
        WHEN '900000000000409009' THEN 1 /*AU   Qualifying relationship (core metadata concept)*/
        WHEN '900000000000225001' THEN 1 /*CORE Qualifying relationship (core metadata concept)*/
        WHEN '900000000000412007' THEN 3 /*AU   Additional relationship (core metadata concept)*/
        WHEN '900000000000227009' THEN 3 /*CORE Additional relationship (core metadata concept)*/
      WHEN '900000000000444006' THEN 99 /*Definition status (core metadata concept)*/
        WHEN '900000000000128007' THEN 0 /*AU   Defined Sufficiently defined concept definition status (core metadata concept)*/
        WHEN '900000000000130009' THEN 1 /*AU   Primitive Necessary but not sufficient concept definition status (core metadata concept)*/
        WHEN '900000000000073002' THEN 0 /*CORE Sufficiently defined concept definition status (core metadata concept)*/
        WHEN '900000000000074008' THEN 1 /*CORE Necessary but not sufficient concept definition status (core metadata concept)*/
      WHEN '900000000000446008' THEN 99 /*Description type (core metadata concept)*/
        WHEN '??????????????????' THEN 0 /*Unspecified*/
        WHEN '900000000000013009' THEN 2 /*CORE Synonym (core metadata concept)*/
        WHEN '900000000000187000' THEN 2 /*AU   Synonym (core metadata concept)*/
        WHEN '900000000000003001' THEN 3 /*Fully specified name (core metadata concept)*/
        WHEN '900000000000550004' THEN 10 /*Definition (core metadata concept)*/
      WHEN '900000000000453004' THEN 99 /*Identifier scheme (core metadata concept)*/
        WHEN '900000000000294009' THEN 99 /*CORE SNOMED CT integer identifier (core metadata concept)*/
        WHEN '900000000000118003' THEN 99 /*AU   SNOMED CT integer identifier (core metadata concept)*/
        WHEN '900000000000002006' THEN 99 /*SNOMED CT universally unique identifier (core metadata concept)*/
      WHEN '900000000000450001' THEN 99 /*Modifier (core metadata concept)*/
        WHEN '900000000000451002' THEN 20 /*Existential restriction modifier (core metadata concept)*/
        WHEN '900000000000452009' THEN 21 /*Universal restriction modifier (core metadata concept)*/
      WHEN '900000000000443000' THEN 99 /*Module (core metadata concept)*/
	      WHEN '900000000000445007' THEN 99 /* International Health Terminology Standards Development Organisation maintained module (core metadata concept) */
		      WHEN '449081005' THEN 99 /* SNOMED CT Spanish edition module (core metadata concept) */
		      WHEN '900000000000207008' THEN 99 /* SNOMED CT core module (core metadata concept) */
		      WHEN '900000000000012004' THEN 99 /* SNOMED CT model component module (core metadata concept) */
	      	WHEN '449080006' THEN 99 /* SNOMED CT to ICD-10 rule-based mapping module (core metadata concept) */
      		WHEN '449079008' THEN 99 /* SNOMED CT to ICD-9CM equivalency mapping module (core metadata concept) */
      	WHEN '999000051000000104' THEN 99 /* [UK] United Kingdom Terminology Centre maintained module (core metadata concept) */
      		WHEN '999000041000000102' THEN 99 /* [UK] SNOMED CT United Kingdom Edition module (core metadata concept) */
            WHEN '999000031000000106' THEN 99 /* [UK] SNOMED CT United Kingdom Edition reference set module (core metadata concept) */
      			WHEN '999000011000000103' THEN 99 /* [UK] SNOMED CT United Kingdom clinical extension module (core metadata concept) */
      			WHEN '999000021000000109' THEN 99 /* [UK] SNOMED CT United Kingdom clinical extension reference set module (core metadata concept) */
      			WHEN '999000011000001104' THEN 99 /* [UKDRG] SNOMED CT United Kingdom drug extension module (core metadata concept) */
      			WHEN '999000021000001108' THEN 99 /* [UKDRG] SNOMED CT United Kingdom drug extension reference set module (core metadata concept) */

    WHEN '900000000000454005' THEN 99 /*Foundation metadata concept (foundation metadata concept)*/
      WHEN '900000000000455006' THEN 99 /*Reference set (foundation metadata concept)*/
        WHEN '900000000000456007' THEN 99 /*Reference set descriptor reference set (foundation metadata concept)*/
        WHEN '900000000000480006' THEN 99 /*Attribute value type reference set (foundation metadata concept)*/
          WHEN '900000000000488004' THEN 99 /*Relationship refinability attribute value reference set (foundation metadata concept)*/
          WHEN '900000000000489007' THEN 99 /*Concept inactivation indicator attribute value reference set (foundation metadata concept)*/
          WHEN '900000000000490003' THEN 99 /*Description inactivation indicator attribute value reference set (foundation metadata concept)*/
          WHEN '900000000000547002' THEN 99 /*Relationship inactivation indicator attribute value reference set (foundation metadata concept)*/
        WHEN '900000000000496009' THEN 99 /*Simple map type reference set (foundation metadata concept)*/
          WHEN '900000000000497000' THEN 99 /*CTV3 simple map reference set (foundation metadata concept)*/
          WHEN '900000000000498005' THEN 99 /*SNOMED RT identifier simple map (foundation metadata concept)*/
        WHEN '900000000000506000' THEN 99 /*Language type reference set (foundation metadata concept)*/
          WHEN '900000000000507009' THEN 99 /*English [International Organization for Standardization 639-1 code en] language reference set (foundation metadata concept)*/
        WHEN '900000000000512005' THEN 99 /*Query specification type reference set (foundation metadata concept)*/
          WHEN '900000000000513000' THEN 99 /*Simple query specification reference set (foundation metadata concept)*/
        WHEN '900000000000516008' THEN 99 /*Annotation type reference set (foundation metadata concept)*/
          WHEN '900000000000517004' THEN 99 /*Associated image reference set (foundation metadata concept)*/
        WHEN '900000000000521006' THEN 99 /*Association type reference set (foundation metadata concept)*/
          WHEN '900000000000522004' THEN 99 /*Historical association reference set (foundation metadata concept)*/
        WHEN '900000000000534007' THEN 99 /*Module dependency reference set (foundation metadata concept)*/
        WHEN '900000000000538005' THEN 99 /*Description format reference set (foundation metadata concept)*/

      WHEN '900000000000457003' THEN 99 /*Reference set attribute (foundation metadata concept)*/
        WHEN '900000000000491004' THEN 99 /*Attribute value (foundation metadata concept)*/
          WHEN '900000000000410004' THEN 99 /*Refinability value (foundation metadata concept)*/
            WHEN '900000000000007000' THEN 0 /*Not refinable (foundation metadata concept)*/
            WHEN '900000000000392005' THEN 1 /*Optional refinability (foundation metadata concept)*/
            WHEN '900000000000391003' THEN 2 /*Mandatory refinability (foundation metadata concept)*/
          WHEN '900000000000481005' THEN 99 /*Concept inactivation value (foundation metadata concept)*/
            WHEN '900000000000482003' THEN 2  /*Duplicate component (foundation metadata concept)*/
            WHEN '900000000000483008' THEN 3  /*Outdated component (foundation metadata concept)*/
            WHEN '900000000000484002' THEN 4  /*Ambiguous component (foundation metadata concept)*/
            WHEN '900000000000485001' THEN 5  /*Erroneous component (foundation metadata concept)*/
            WHEN '900000000000486000' THEN 6  /*Limited component (foundation metadata concept)*/
            WHEN '900000000000487009' THEN 10 /*Component moved elsewhere (foundation metadata concept)*/
            WHEN '900000000000492006' THEN 11 /*Pending move (foundation metadata concept)*/
          WHEN '900000000000493001' THEN 99 /*Description inactivation value (foundation metadata concept)*/
            WHEN '900000000000482003' THEN 2 /*Duplicate component (foundation metadata concept)*/
            WHEN '900000000000483008' THEN 3 /*Outdated component (foundation metadata concept)*/
            WHEN '900000000000485001' THEN 5 /*Erroneous component (foundation metadata concept)*/
            WHEN '900000000000486000' THEN 6 /*Limited component (foundation metadata concept)*/
            WHEN '900000000000494007' THEN 7 /*Inappropriate component (foundation metadata concept)*/
            WHEN '900000000000495008' THEN 8 /*Concept non-current (foundation metadata concept)*/
            WHEN '900000000000487009' THEN 10 /*Component moved elsewhere (foundation metadata concept)*/
            WHEN '900000000000492006' THEN 11 /*Pending move (foundation metadata concept)*/
          WHEN '900000000000546006' THEN 99 /*Inactive value (foundation metadata concept)*/
          WHEN '900000000000545005' THEN 99 /*Active value (foundation metadata concept)*/
        WHEN '900000000000458008' THEN 99 /*Attribute description (foundation metadata concept)*/
        WHEN '900000000000459000' THEN 99 /*Attribute type (foundation metadata concept)*/
          WHEN '900000000000460005' THEN 99 /*Component type (foundation metadata concept)*/
            WHEN '900000000000461009' THEN 99 /*Concept type component (foundation metadata concept)*/
            WHEN '900000000000462002' THEN 99 /*Description type component (foundation metadata concept)*/
            WHEN '900000000000463007' THEN 99 /*Relationship type component (foundation metadata concept)*/
            WHEN '900000000000464001' THEN 99 /*Reference set member type component (foundation metadata concept)*/
          WHEN '900000000000465000' THEN 99 /*String (foundation metadata concept)*/
            WHEN '900000000000466004' THEN 99 /*Text (foundation metadata concept)*/
            WHEN '900000000000469006' THEN 99 /*Uniform resource locator (foundation metadata concept)*/
            WHEN '900000000000474003' THEN 99 /*Universally Unique Identifier (foundation metadata concept)*/
            WHEN '900000000000475002' THEN 99 /*Time (foundation metadata concept)*/
          WHEN '900000000000476001' THEN 99 /*Integer (foundation metadata concept)*/
            WHEN '900000000000477005' THEN 99 /*Signed integer (foundation metadata concept)*/
            WHEN '900000000000478000' THEN 99 /*Unsigned integer (foundation metadata concept)*/
        WHEN '900000000000479008' THEN 99 /*Attribute order (foundation metadata concept)*/
        WHEN '900000000000499002' THEN 99 /*Scheme value (foundation metadata concept)*/
        WHEN '900000000000500006' THEN 99 /*Map source concept (foundation metadata concept)*/
        WHEN '900000000000501005' THEN 99 /*Map group (foundation metadata concept)*/
        WHEN '900000000000502003' THEN 99 /*Map priority (foundation metadata concept)*/
        WHEN '900000000000503008' THEN 99 /*Map rule (foundation metadata concept)*/
        WHEN '900000000000504002' THEN 99 /*Map advice (foundation metadata concept)*/
        WHEN '900000000000505001' THEN 99 /*Map target (foundation metadata concept)*/
        WHEN '900000000000510002' THEN 99 /*Description in dialect (foundation metadata concept)*/
        WHEN '900000000000511003' THEN 99 /*Acceptability (foundation metadata concept)*/
          WHEN '900000000000548007' THEN 1 /*Preferred (foundation metadata concept)*/
          WHEN '900000000000549004' THEN 2 /*Acceptable (foundation metadata concept)*/
        WHEN '900000000000514006' THEN 99 /*Generated reference set (foundation metadata concept)*/
        WHEN '900000000000515007' THEN 99 /*Query (foundation metadata concept)*/
        WHEN '900000000000518009' THEN 99 /*Annotated component (foundation metadata concept)*/
        WHEN '900000000000519001' THEN 99 /*Annotation (foundation metadata concept)*/
          WHEN '900000000000520007' THEN 99 /*Image (foundation metadata concept)*/
        WHEN '900000000000532006' THEN 99 /*Association source component (foundation metadata concept)*/
        WHEN '900000000000533001' THEN 99 /*Association target component (foundation metadata concept)*/
        WHEN '900000000000535008' THEN 99 /*Dependency target (foundation metadata concept)*/
        WHEN '900000000000536009' THEN 99 /*Source effective time (foundation metadata concept)*/
        WHEN '900000000000537000' THEN 99 /*Target effective time (foundation metadata concept)*/
        WHEN '900000000000539002' THEN 99 /*Description format (foundation metadata concept)*/
          WHEN '900000000000540000' THEN 99 /*Plain text (foundation metadata concept)*/
          WHEN '900000000000541001' THEN 99 /*Limited HyperText Markup Language (foundation metadata concept)*/
          WHEN '900000000000542008' THEN 99 /*Extensible HyperText Markup Language (foundation metadata concept)*/
          WHEN '900000000000543003' THEN 99 /*Darwin Information Typing Architecture (foundation metadata concept)*/
        WHEN '900000000000544009' THEN 99 /*Description length (foundation metadata concept)*/


        ELSE '99'
END);

RETURN MagicNumber;
END $$

DROP PROCEDURE IF EXISTS `RF2_PopulateRF1` $$

CREATE PROCEDURE RF2_PopulateRF1()

BEGIN

INSERT INTO IMPORTTIME_RF2 SET Event = 'START Extract RF1 snapshot', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

DROP TABLE IF EXISTS rf21_CONCEPT;
CREATE TABLE rf21_CONCEPT (
	CONCEPTID	         VARCHAR (18) NOT NULL,
	CONCEPTSTATUS        TINYINT (2) UNSIGNED NOT NULL,
	FULLYSPECIFIEDNAME   VARCHAR (255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
	CTV3ID               BINARY (5) NOT NULL,
    SNOMEDID             VARBINARY (8) NOT NULL,
    ISPRIMITIVE          TINYINT (1) UNSIGNED NOT NULL,
    SOURCE               BINARY (4) NOT NULL);

/* Table: TERM : Table of unique Terms and their IDs*/
DROP TABLE IF EXISTS rf21_TERM;
CREATE TABLE rf21_TERM (
	DESCRIPTIONID	     VARCHAR (18) NOT NULL,
	DESCRIPTIONSTATUS    TINYINT (2) UNSIGNED NOT NULL,
	CONCEPTID	         VARCHAR (18) NOT NULL,
	TERM                 VARCHAR (255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
	INITIALCAPITALSTATUS TINYINT (1) UNSIGNED NOT NULL,
    DESCRIPTIONTYPE      TINYINT (1) UNSIGNED NOT NULL,
	DEFAULTDESCTYPE      TINYINT (1) UNSIGNED NOT NULL,
    LANGUAGECODE         VARBINARY (8) NOT NULL,
    SOURCE               BINARY(4) NOT NULL);

/* Table: DEF : Table of text definitions */
DROP TABLE IF EXISTS rf21_DEF;
CREATE TABLE rf21_DEF (
 CONCEPTID             VARCHAR (18) NOT NULL,
 SNOMEDID              VARBINARY (8) NOT NULL,
 FULLYSPECIFIEDNAME    VARCHAR (255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
 DEFINITION            VARCHAR (450) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL);

/* Table: REL : Templates*/
DROP TABLE IF EXISTS rf21_REL;
CREATE TABLE rf21_REL (
	RELATIONSHIPID		VARCHAR (18) NOT NULL,
	CONCEPTID1			VARCHAR (18) NOT NULL,
	RELATIONSHIPTYPE	VARCHAR (18) NOT NULL,
	CONCEPTID2			VARCHAR (18) NOT NULL,
	CHARACTERISTICTYPE	TINYINT (1) UNSIGNED NOT NULL,
	REFINABILITY		TINYINT (1) UNSIGNED NOT NULL,
	RELATIONSHIPGROUP	TINYINT (2) UNSIGNED NOT NULL,
	SOURCE				BINARY (4) NOT NULL);

DROP TABLE IF EXISTS rf21_SUBSETLIST;
CREATE TABLE rf21_SUBSETLIST (
  SubsetId         VARCHAR (18) NOT NULL,
  SubsetOriginalID VARCHAR (18) NOT NULL,
  SubsetVersion    VARBINARY(4) NOT NULL,
  SubsetName       VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  SubsetType       TINYINT (1) UNSIGNED NOT NULL,
  LanguageCode     VARBINARY(5),
  SubsetRealmID    VARBINARY (10) NOT NULL,
  ContextID        TINYINT (1) UNSIGNED NOT NULL);

DROP TABLE IF EXISTS rf21_SUBSETS;
CREATE TABLE rf21_SUBSETS (
  SubsetId     VARCHAR (18) NOT NULL,
  MemberID     VARCHAR (18) NOT NULL,
  MemberStatus TINYINT (1) UNSIGNED NOT NULL,
  LinkedID     VARCHAR(18) CHARACTER SET latin1 COLLATE latin1_general_ci);

DROP TABLE IF EXISTS rf21_XMAPLIST;
CREATE TABLE rf21_XMAPLIST (
  MapSetId             VARCHAR (18) NOT NULL,
  MapSetName           VARCHAR (255) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  MapSetType           BINARY (1) NOT NULL,
  MapSetSchemeID       VARBINARY (64) NOT NULL,
  MapSetSchemeName     VARCHAR (255) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  MapSetSchemeVersion  VARBINARY(10) NOT NULL,
  MapSetRealmID        VARCHAR (18) NOT NULL,
  MapSetSeparator      BINARY (1) NOT NULL,
  MapSetRuleType       VARBINARY (2) NOT NULL);

DROP TABLE IF EXISTS rf21_XMAPS;
CREATE TABLE rf21_XMAPS (
  MapSetID       VARCHAR (18) NOT NULL,
  MapConceptID   VARCHAR (18) NOT NULL,
  MapOption      INTEGER UNSIGNED,
  MapPriority    TINYINT (1) UNSIGNED,
  MapTargetID    VARCHAR (18) NOT NULL,
  MapRule        VARCHAR(255) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  MapAdvice      VARCHAR(255) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL);

DROP TABLE IF EXISTS rf21_XMAPTARGET;
CREATE TABLE rf21_XMAPTARGET (
  TargetID       VARCHAR (18) NOT NULL,
  TargetSchemeID VARCHAR (64) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  TargetCodes    VARCHAR(255) CHARACTER SET latin1 COLLATE latin1_general_ci,
  TargetRule     VARCHAR(255) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  TargetAdvice   VARCHAR(255) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL);

DROP TABLE IF EXISTS rf21_REFERENCE;
CREATE TABLE rf21_REFERENCE
  (COMPONENTID   VARCHAR (18) NOT NULL,
  REFERENCETYPE  TINYINT (1) NOT NULL,
  REFERENCEDID   VARCHAR (18) NOT NULL,
  SOURCE         BINARY (4) NOT NULL);

DROP TABLE IF EXISTS rf21_COMPONENTHISTORY;
CREATE TABLE rf21_COMPONENTHISTORY
  (COMPONENTID     VARCHAR (18) NOT NULL,
   RELEASEVERSION  BINARY (8) NOT NULL,
   CHANGETYPE      TINYINT (1) NOT NULL,
   STAT            TINYINT (1) NOT NULL,
   REASON          VARCHAR(255) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
   SOURCE          BINARY(4) NOT NULL);

INSERT INTO IMPORTTIME_RF2 SET Event = '  First concept extract', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

INSERT INTO rf21_concept
SELECT DISTINCT
  id AS CONCEPTID,
  IF(active = 0,1,0) AS CONCEPTSTATUS,
  '' AS FULLYSPECIFIEDNAME,
  'Xxxxx' AS CTV3ID,
  'Xxxxx' AS SNOMEDID,
  magicNumberFor(definitionStatusId) AS ISPRIMITIVE,
  moduleSourceFor(moduleId) AS SOURCE
FROM rf2_concept;

INSERT INTO IMPORTTIME_RF2 SET Event = '  First description extract', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

SET @FullySpecifiedName = '900000000000003001';
SET @Definition = '900000000000550004';
SET @EntireTermCaseSensitive = '900000000000017005';

INSERT INTO rf21_term
SELECT
  id AS DESCRIPTIONID,
  IF(active = 0,1,0) AS DESCRIPTIONSTATUS,
  conceptId AS CONCEPTID,
  term AS TERM,
  If(caseSignificanceId = @EntireTermCaseSensitive,1,0) AS INITIALCAPITALSTATUS,
  If(typeID = @FullySpecifiedName,3,2) AS DEFAULTDESCTYPE, #assigns all FSNs but labels all other terms as 'synonyms'
  If(typeID = @FullySpecifiedName,3,2) AS DESCRIPTIONTYPE, #assigns all FSNs but labels all other terms as 'synonyms'
  languageCode AS LANGUAGECODE,
  moduleSourceFor(moduleId) AS SOURCE
FROM rf2_term;

#caseSignificanceId values:
#900000000000017005 Entire term case sensitive (core metadata concept)
#900000000000020002 Only initial character case insensitive (core metadata concept)

#typeID values:
#900000000000003001 Fully specified name (core metadata concept)
#900000000000013009 Synonym (core metadata concept)
#900000000000550004 Definition (core metadata concept)

INSERT INTO IMPORTTIME_RF2 SET Event = '  First definitions extract', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

INSERT INTO rf21_def
SELECT
  conceptId AS CONCEPTID,
  '' AS SNOMEDID,
  '' AS FULLYSPECIFIEDNAME,
  term AS TERM
FROM rf2_def WHERE active = 1;

INSERT INTO IMPORTTIME_RF2 SET Event = '  First relationship extract', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

SET @Inferred = '900000000000011006';
SET @Stated = '900000000000010007';
SET @Additional = '900000000000227009';

INSERT INTO rf21_rel
SELECT
  id AS RELATIONSHIPID,
  sourceId AS CONCEPTID1,
  typeId AS RELATIONSHIPTYPE,
  destinationId AS CONCEPTD2,
  IF(characteristicTypeId = @Inferred,0,IF(characteristicTypeId = @Additional,3,0)) AS CHARACTERISTICTYPE,
  9 AS REFINABILITY, # default 3 to signify refinability not known
  relationshipGroup AS RELATIONSHIPGROUP,
  moduleSourceFor(moduleId) AS SOURCE
FROM rf2_rel WHERE characteristicTypeId <> @Stated; /* Ignore stated relationships */

/*
900000000000449001 Characteristic type (core metadata concept)
	900000000000227009 Additional relationship (core metadata concept)
	900000000000006009 Defining relationship (core metadata concept)
		900000000000011006 Inferred relationship (core metadata concept)
		900000000000010007 Stated relationship (core metadata concept)
	900000000000225001 Qualifying relationship (core metadata concept)
*/

INSERT INTO IMPORTTIME_RF2 SET Event = '  START PRIMARY INDEXATION', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
INSERT INTO IMPORTTIME_RF2 SET Event = '    Indexing Concept.ConceptID', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
CREATE UNIQUE INDEX CONCEPT_CUI_X ON rf21_concept(CONCEPTID);
INSERT INTO IMPORTTIME_RF2 SET Event = '    Indexing Term.ConceptID', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
CREATE INDEX TERM_CUI_X ON rf21_term(CONCEPTID);
INSERT INTO IMPORTTIME_RF2 SET Event = '    Indexing Term.DescriptionID', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
CREATE UNIQUE INDEX TERM_TUI_X ON rf21_term(DESCRIPTIONID);
#INSERT INTO IMPORTTIME_RF2 SET Event = '    Indexing Rel.RelationshipID', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
#CREATE INDEX REL_ID_X ON rf21_rel(RELATIONSHIPID);
INSERT INTO IMPORTTIME_RF2 SET Event = '    Indexing Rel.ConceptID1', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
CREATE INDEX REL_CUI1_X ON rf21_rel(CONCEPTID1);
INSERT INTO IMPORTTIME_RF2 SET Event = '    Indexing Rel.RelationshipType', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
CREATE INDEX REL_RELATION_X ON rf21_rel(RELATIONSHIPTYPE);
INSERT INTO IMPORTTIME_RF2 SET Event = '    Indexing Rel.ConceptID2', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
CREATE INDEX REL_CUI2_X ON rf21_rel(CONCEPTID2);
INSERT INTO IMPORTTIME_RF2 SET Event = '  END PRIMARY INDEXATION', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

INSERT INTO IMPORTTIME_RF2 SET Event = '  START RECONSTRUCT SCT1_CONCEPT', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

/* Initial default concept status for ALL concepts in a snapshot is 'retired no reason'
   Concepts that are found in both the FULL tables and also in a particular Snapshot MUST be 'current' in that Snapshot */
#UPDATE rf21_concept c INNER JOIN rf2_concept s ON c.CONCEPTID = s.ID
#SET c.ISPRIMITIVE = magicNumberFor(s.definitionStatusId), c.SOURCE = moduleSourceFor(s.moduleId), c.CONCEPTSTATUS = 0;

/* Concepts in the FULL tables but NOT in the snapshot must be EITHER some flavour of inactive OR pending move 
   Determine the reason for inactivation, or pending move status, from the appropriate refset
   Any concept that is NEITHER current NOR pending move NOR has a reason for retirement explicitly represented in the RefSet, must implicitly be correctly the default 'retired no reason' */
UPDATE rf21_concept c INNER JOIN rf2_crefset s ON c.CONCEPTID = s.referencedComponentId
SET c.CONCEPTSTATUS = magicNumberFor(linkedComponentId), c.SOURCE = moduleSourceFor(s.moduleId)
WHERE s.refSetId ='900000000000489007' AND s.active = 1; /* Concept inactivation indicator attribute value reference set (foundation metadata concept) */

INSERT INTO IMPORTTIME_RF2 SET Event = '    Reinstated CONCEPTSTATUS and SOURCE', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

UPDATE rf21_concept c INNER JOIN rf2_srefset s ON c.CONCEPTID = s.referencedComponentId
SET c.CTV3ID = s.linkedString WHERE s.refSetId ='900000000000497000'; /* CTV3 simple map reference set (foundation metadata concept) */
INSERT INTO IMPORTTIME_RF2 SET Event = '    CTV3ID Partially reinstated', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
INSERT INTO IMPORTTIME_RF2 SET Event = '    (UK Extension CTV3IDs only published in compatability pack)', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

UPDATE rf21_concept C INNER JOIN rf2_srefset s ON c.CONCEPTID = s.referencedComponentId
SET c.SNOMEDID = s.linkedString WHERE s.refSetId ='900000000000498005'; /* SNOMED RT identifier simple map (foundation metadata concept) */
INSERT INTO IMPORTTIME_RF2 SET Event = '    SNOMEDID reinstated', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
INSERT INTO IMPORTTIME_RF2 SET Event = '    (UK Extension SNOMEDIDs only in compatability pack, but always spurious)', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

INSERT INTO IMPORTTIME_RF2 SET Event = '  END RECONSTRUCT SCT1_CONCEPT', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

INSERT INTO IMPORTTIME_RF2 SET Event = '  START RECONSTRUCT SCT1_DESCRIPTIONS', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

UPDATE rf21_term t INNER JOIN rf2_crefset s ON t.DESCRIPTIONID = s.referencedComponentId
SET t.DESCRIPTIONSTATUS = magicNumberFor(linkedComponentId) WHERE s.refSetId ='900000000000490003' AND s.active = 1; /* Description inactivation indicator attribute value reference set (foundation metadata concept) */
INSERT INTO IMPORTTIME_RF2 SET Event = '    Reinstated DESCRIPTION STATUS', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

#Apply language refsets that flag descriptions as 'preferred' or 'acceptable'
INSERT INTO IMPORTTIME_RF2 SET Event = '    START APPLY LANGUAGE REFSETS', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

UPDATE rf21_term SET LANGUAGECODE = 'en';
UPDATE rf21_concept c INNER JOIN rf21_term t ON c.CONCEPTID = t.CONCEPTID SET c.FULLYSPECIFIEDNAME = t.TERM WHERE t.DESCRIPTIONTYPE = 3 AND t.DESCRIPTIONSTATUS IN (0,6,8,11);
INSERT INTO IMPORTTIME_RF2 SET Event = '    Reinstated default FSN to rf21_concept', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

INSERT INTO IMPORTTIME_RF2 SET Event = '      START Extract LanguageCode', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

SET @USRefSet = '900000000000509007'; /* United States of America English language reference set  */
SET @GBRefSet = '900000000000508004'; /* Great Britain English language reference set (foundation metadata concept) */
SET @USRefsetName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @USRefSet);
SET @GBRefsetName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @Refset);
UPDATE rf21_term t
	LEFT JOIN rf2_crefset us ON (t.DESCRIPTIONID = us.referencedComponentId AND us.refSetId = @USRefSet AND us.active = 1)
	LEFT JOIN rf2_crefset gb ON (t.DESCRIPTIONID = gb.referencedComponentId AND gb.refSetId = @GBRefSet AND gb.active = 1)
SET t.LANGUAGECODE = IF(gb.refsetId IS NULL,IF(us.refsetId IS NULL,'en','en-US'),IF(us.refsetId IS NULL,'en-GB','en')); 
INSERT INTO IMPORTTIME_RF2 SET Event = CONCAT('     ',ROW_COUNT(),'  en-US/GB languageCodes from  en-US/GB refsets'), DTSTAMP = '', TMSTAMP=CURRENT_TIME;

SET @RefSet = '999001251000000103'; /* United Kingdom Extension Great Britain English language reference set (foundation metadata concept) */
SET @RefsetName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @Refset);
SET @RefsetName = IF(@RefsetName IS NULL,'* refset not recognised *',@RefsetName);
UPDATE rf21_term t INNER JOIN rf2_crefset s ON t.DESCRIPTIONID = s.referencedComponentId
SET t.LANGUAGECODE = IF(t.LANGUAGECODE = 'en-US','en','en-GB') WHERE s.refSetId = @RefSet AND s.active = 1;
INSERT INTO IMPORTTIME_RF2 SET Event = CONCAT('     ',ROW_COUNT(),' en-GB from ',@RefSetName), DTSTAMP = '', TMSTAMP=CURRENT_TIME;

SET @RefSet = '999000681000001101'; /* United Kingdom Drug Extension Great Britain English language reference set (foundation metadata concept) */
SET @RefsetName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @Refset);
SET @RefsetName = IF(@RefsetName IS NULL,'* refset not recognised *',@RefsetName);
UPDATE rf21_term t INNER JOIN rf2_crefset s ON t.DESCRIPTIONID = s.referencedComponentId
SET t.LANGUAGECODE = IF(t.LANGUAGECODE = 'en-US','en','en-GB') WHERE s.refSetId = @RefSet  AND s.active = 1;
INSERT INTO IMPORTTIME_RF2 SET Event = CONCAT('     ',ROW_COUNT(),' en-GB from ',@RefSetName), DTSTAMP = '', TMSTAMP=CURRENT_TIME;

INSERT INTO IMPORTTIME_RF2 SET Event = '      DONE Extract LanguageCode', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

INSERT INTO IMPORTTIME_RF2 SET Event = '      START Extract Descriptiontype', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
SET @Acceptable = '900000000000549004';
SET @Preferred = '900000000000548007';
SET @USRefSet = '900000000000509007'; /* United States of America English language reference set  */
SET @GBRefSet = '900000000000508004'; /* Great Britain English language reference set (foundation metadata concept) */

UPDATE rf21_term t
	LEFT JOIN rf2_crefset us ON (t.DESCRIPTIONID = us.referencedComponentId AND us.refSetId = @USRefSet)
	LEFT JOIN rf2_crefset gb ON (t.DESCRIPTIONID = gb.referencedComponentId AND gb.refSetId = @GBRefSet)
SET t.DESCRIPTIONTYPE = IF(gb.refsetId IS NULL,
							IF(us.refsetID IS NULL,
								t.DEFAULTDESCTYPE, #not in either refset
								IF(us.linkedComponentId = @Preferred, IF(t.DEFAULTDESCTYPE = 3,3,1),IF(us.linkedComponentId = @Acceptable,2,0)) #only in US refset
							   ),
							IF(us.refsetID IS NULL,
								IF(gb.linkedComponentId = @Preferred, IF(t.DEFAULTDESCTYPE = 3,3,1),IF(gb.linkedComponentId = @Acceptable,2,0)), #only in GB refset
								IF(us.linkedComponentId = gb.linkedComponentId,IF(gb.linkedComponentId = @Preferred, IF(t.DEFAULTDESCTYPE = 3,3,1),IF(gb.linkedComponentId = @Acceptable,2,0)),0) #in both refsets
						      )
							); 
INSERT INTO IMPORTTIME_RF2 SET Event = CONCAT('     ',ROW_COUNT(),' descriptionType from en-US/GB refsets'), DTSTAMP = '', TMSTAMP=CURRENT_TIME;

-- The 2013b UK Clinical extensions contain only 88 descriptions that are en-US. The UK Drug Extension contains none
-- All 88 are retired concepts, and several don't actually contain a US English spelling
-- The only reason for worrying about languagecode at all is in order that the en-US variants might be identified and then filtered out within the UK Realm
-- The above algorithm produces a result for en-US assignement that is very close to what is found in RF1
-- Assignment of en-GB over en by comparison is significantly different from RF1, but this probably doesn't matter for the UK Realm

-- UPDATE rf21_term SET LANGUAGECODE = 'en-GB' WHERE INSTR(DescriptionId,'1000000') = (LENGTH(DescriptionId) - 9) AND LEFT(RIGHT(DescriptionId,3),2) = '11' AND DescriptionType <> 3;
-- INSERT INTO IMPORTTIME_RF2 SET Event = CONCAT('     ',ROW_COUNT(),' UK Clinical Extension descriptions are ALL en-GB'), DTSTAMP = '', TMSTAMP=CURRENT_TIME;
-- UPDATE rf21_term SET LANGUAGECODE = 'en-GB' WHERE INSTR(DescriptionId,'1000001') = (LENGTH(DescriptionId) - 9) AND LEFT(RIGHT(DescriptionId,3),2) = '11' AND DescriptionType <> 3;
-- INSERT INTO IMPORTTIME_RF2 SET Event = CONCAT('     ',ROW_COUNT(),' UK Clinical Drug descriptions are ALL en-GB'), DTSTAMP = '', TMSTAMP=CURRENT_TIME;

SET @RefSet = '999001251000000103'; /* United Kingdom Extension Great Britain English language reference set (foundation metadata concept) */
SET @RefsetName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @Refset);
SET @RefsetName = IF(@RefsetName IS NULL,'* refset not recognised *',@RefsetName);
UPDATE rf21_term t INNER JOIN rf2_crefset s ON t.DESCRIPTIONID = s.referencedComponentId
SET t.DESCRIPTIONTYPE = IF(linkedComponentId = @Preferred,IF(t.DEFAULTDESCTYPE = 3,3,1),IF(linkedComponentId = @Acceptable,2,0)) WHERE s.refSetId = @RefSet;
INSERT INTO IMPORTTIME_RF2 SET Event = CONCAT('     ',ROW_COUNT(),' DescriptionTyupes from ',@RefSetName), DTSTAMP = '', TMSTAMP=CURRENT_TIME;

SET @RefSet = '999000681000001101'; /* United Kingdom Drug Extension Great Britain English language reference set (foundation metadata concept) */
SET @RefsetName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @Refset);
SET @RefsetName = IF(@RefsetName IS NULL,'* refset not recognised *',@RefsetName);
UPDATE rf21_term t INNER JOIN rf2_crefset s ON t.DESCRIPTIONID = s.referencedComponentId
SET t.DESCRIPTIONTYPE = IF(linkedComponentId = @Preferred,IF(t.DEFAULTDESCTYPE = 3,3,1),IF(linkedComponentId = @Acceptable,2,0)) WHERE s.refSetId = @RefSet;
INSERT INTO IMPORTTIME_RF2 SET Event = CONCAT('     ',ROW_COUNT(),' DescriptionTypes from ',@RefSetName), DTSTAMP = '', TMSTAMP=CURRENT_TIME;

UPDATE rf21_term t INNER JOIN rf2_crefset s ON t.DESCRIPTIONID = s.referencedComponentId
SET t.DESCRIPTIONTYPE = 1 WHERE linkedComponentId = @Preferred AND t.DEFAULTDESCTYPE <> 3 AND s.refSetId IN ('999001251000000103','999000681000001101') AND t.DESCRIPTIONTYPE <> 1;
INSERT INTO IMPORTTIME_RF2 SET Event = CONCAT('     ',ROW_COUNT(),' preferred terms forced from BOTH refsets'), DTSTAMP = '', TMSTAMP=CURRENT_TIME;

-- CALL analyze_rf2description;

INSERT INTO IMPORTTIME_RF2 SET Event = '    START APPLY REALM LANGUAGE REFSETS', DTSTAMP = CURRENT_DATE, TMSTAMP=CURRENT_TIME;

SET @RefSetClin = '999001261000000100'; /* National Health Service realm language reference set (clinical part)  */
SET @RefsetName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @RefSetClin);
SET @RefsetName = IF(@RefsetName IS NULL,'* refset not recognised *',@RefsetName);
UPDATE rf21_term t INNER JOIN rf2_crefset s ON t.DESCRIPTIONID = s.referencedComponentId
SET t.DESCRIPTIONTYPE = IF(linkedComponentId = @Preferred,IF(t.DEFAULTDESCTYPE = 3,3,1),IF(linkedComponentId = @Acceptable,IF(t.DEFAULTDESCTYPE = 3,3,2),0)) WHERE s.refSetId = @RefSetClin;
INSERT INTO IMPORTTIME_RF2 SET Event = CONCAT('     ',ROW_COUNT(),' description type assignments from ',@RefSetName), DTSTAMP = '', TMSTAMP=CURRENT_TIME;

SET @RefsetPharm = '999000691000001104'; /* National Health Service realm language reference set (pharmacy part)  */
SET @RefsetName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @RefSetClin);
SET @RefsetName = IF(@RefsetName IS NULL,'* refset not recognised *',@RefsetName);
UPDATE rf21_term t INNER JOIN rf2_crefset s ON t.DESCRIPTIONID = s.referencedComponentId
SET t.DESCRIPTIONTYPE = IF(linkedComponentId = @Preferred,IF(t.DEFAULTDESCTYPE = 3,3,1),IF(linkedComponentId = @Acceptable,IF(t.DEFAULTDESCTYPE = 3,3,2),0)) WHERE s.refSetId = @RefsetPharm;
INSERT INTO IMPORTTIME_RF2 SET Event = CONCAT('     ',ROW_COUNT(),' description type assignments from ',@RefSetName), DTSTAMP = '', TMSTAMP=CURRENT_TIME;

UPDATE rf21_term t INNER JOIN rf2_crefset s ON t.DESCRIPTIONID = s.referencedComponentId
SET t.DESCRIPTIONTYPE = 1 WHERE linkedComponentId = @Preferred AND t.DEFAULTDESCTYPE <> 3 AND s.refSetId IN (@RefSetClin,@RefsetPharm) AND t.DESCRIPTIONTYPE <> 1;
INSERT INTO IMPORTTIME_RF2 SET Event = CONCAT('     ',ROW_COUNT(),' preferred terms forced from BOTH refsets'), DTSTAMP = '', TMSTAMP=CURRENT_TIME;

INSERT INTO IMPORTTIME_RF2 SET Event = '    START APPLY dm+d REALM LANGUAGE REFSET', DTSTAMP = CURRENT_DATE, TMSTAMP=CURRENT_TIME;

SET @RefSet = '999000671000001103'; /* National Health Service dictionary of medicines and devices realm language reference set   */
SET @RefsetName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @RefSetClin);
SET @RefsetName = IF(@RefsetName IS NULL,'* refset not recognised *',@RefsetName);
UPDATE rf21_term t INNER JOIN rf2_crefset s ON t.DESCRIPTIONID = s.referencedComponentId
SET t.DESCRIPTIONTYPE = IF(linkedComponentId = @Preferred,IF(t.DEFAULTDESCTYPE = 3,3,1),IF(linkedComponentId = @Acceptable,IF(t.DEFAULTDESCTYPE = 3,3,2),0)) WHERE s.refSetId = @RefSet;
INSERT INTO IMPORTTIME_RF2 SET Event = CONCAT('     ',ROW_COUNT(),' description type assignments from ',@RefSetName), DTSTAMP = '', TMSTAMP=CURRENT_TIME;

UPDATE rf21_term t INNER JOIN rf2_crefset s ON t.DESCRIPTIONID = s.referencedComponentId
SET t.DESCRIPTIONTYPE = 1 WHERE linkedComponentId = @Preferred AND t.DEFAULTDESCTYPE <> 3 AND s.refSetId = @RefSet AND t.DESCRIPTIONTYPE <> 1;
INSERT INTO IMPORTTIME_RF2 SET Event = CONCAT('     ',ROW_COUNT(),' preferred terms forced from refset'), DTSTAMP = '', TMSTAMP=CURRENT_TIME;

INSERT INTO IMPORTTIME_RF2 SET Event = '    END APPLY LANGUAGE REFSETS', DTSTAMP = CURRENT_DATE, TMSTAMP=CURRENT_TIME;

/*
DROP TABLE IF EXISTS TEMP;
DROP TABLE IF EXISTS TEMP2;
CREATE TABLE TEMP (ID BIGINT(20) NOT NULL, SUBSET BIGINT(20), PRIMARY KEY (ID)) ENGINE = MEMORY;
CREATE TABLE TEMP2 (ID BIGINT(20) NOT NULL, STAT TINYINT, PRIMARY KEY (ID)) ENGINE = MEMORY;

INSERT IGNORE INTO TEMP SELECT DISTINCT MEMBERID AS ID, SUBSETID AS SUBSET FROM SUBSETS WHERE SUBSETID IN ('53531000000137','411601000001131','1174030');
INSERT IGNORE INTO TEMP2 SELECT DISTINCT DESCRIPTIONID AS ID, DESCRIPTIONSTATUS AS STAT FROM TERM WHERE LANGUAGECODE = 'en-GB';

SELECT SUBSET, COUNT(ID), x.LANGUAGECODE, COUNT(LanguageCode) FROM (
SELECT TEMP.SUBSET, TEMP.ID, TERM.LanguageCode 
	FROM TEMP LEFT JOIN TEMP2 ON TEMP.ID = TEMP2.ID 
	INNER JOIN TERM on TERM.DESCRIPTIONID = TEMP.ID
	WHERE TEMP2.ID IS NULL) x GROUP BY x.SUBSET, x.LANGUAGECODE;
*/

INSERT INTO IMPORTTIME_RF2 SET Event = '  END RECONSTRUCT SCT1_DESCRIPTIONS', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

UPDATE rf21_concept c INNER JOIN rf21_term t ON c.CONCEPTID = t.CONCEPTID SET c.FULLYSPECIFIEDNAME = t.TERM WHERE t.DESCRIPTIONTYPE = 3 AND t.DESCRIPTIONSTATUS IN (0,6,8,11);
INSERT INTO IMPORTTIME_RF2 SET Event = '    Reinstated default FSN to rf21_concept', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

UPDATE rf21_def d INNER JOIN rf21_concept s ON d.CONCEPTID = s.CONCEPTID SET d.FULLYSPECIFIEDNAME = s.FULLYSPECIFIEDNAME, d.SNOMEDID = s.SNOMEDID;
INSERT INTO IMPORTTIME_RF2 SET Event = '    Reinstated default FSN and SNOMEDID to rf21_def', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

INSERT INTO IMPORTTIME_RF2 SET Event = '  START RECONSTRUCT SCT1_RELATIONSHIPS', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

SET @Res = (SELECT COUNT(referencedComponentId) FROM rf2_crefset WHERE refsetId = '900000000000488004');
UPDATE rf21_rel r INNER JOIN rf2_crefset s ON r.RELATIONSHIPID = s.referencedComponentId
SET r.REFINABILITY = magicNumberFor(linkedComponentId) WHERE s.refSetId ='900000000000488004'; /* Relationship refinability attribute value reference set (foundation metadata concept) */

INSERT INTO IMPORTTIME_RF2 SET Event = CONCAT('    REFINABILITY',IF(@Res = 0 ,' Refset has no content!',' reinstated')), DTSTAMP = '', TMSTAMP=CURRENT_TIME;
INSERT INTO IMPORTTIME_RF2 SET Event = '    START HISTORICAL RELATIONSHIP ROW RESTORATION', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

#SET @HistoricalAttribute = ''; /*  */
#SET @Refset = '900000000000530003';	/* ALTERNATIVE association reference set (foundation metadata concept) ' */
#SET @HistoricalAttributeName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @HistoricalAttribute);
#SET @RefsetName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @Refset);
#INSERT INTO rf21_rel SELECT  '010101010', s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' FROM rf2_cRefSet s WHERE s.RefSetId = @Refset;
#INSERT INTO IMPORTTIME_RF2 SET Events = CONCAT('     ',@HistoricalAttributeName,' from ',@RefSetName), DTSTAMP = '', TMSTAMP=CURRENT_TIME;

SET @HistoricalAttribute = '10363501000001105'; /* HAD AMP */
SET @Refset = '999001311000000107';	/* Had actual medicinal product association reference set (foundation metadata concept) */
SET @HistoricalAttributeName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @HistoricalAttribute);
SET @HistoricalAttributeName = IF(@HistoricalAttributeName IS NULL,'* attribute not recognised *',@HistoricalAttributeName);
SET @RefsetName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @Refset);
SET @RefsetName = IF(@RefsetName IS NULL,'* refset not recognised *',@RefsetName);
INSERT INTO rf21_rel SELECT  '010101010', s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' FROM rf2_cRefSet s WHERE s.RefSetId = @Refset;
INSERT INTO IMPORTTIME_RF2 SET Event = CONCAT('     ',@HistoricalAttributeName,' from ',@RefSetName), DTSTAMP = '', TMSTAMP=CURRENT_TIME;

SET @HistoricalAttribute = '10363401000001106'; /* HAD VMP */
SET @Refset = '999001321000000101';	/* Had virtual medicinal product association reference set (foundation metadata concept) */
SET @HistoricalAttributeName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @HistoricalAttribute);
SET @HistoricalAttributeName = IF(@HistoricalAttributeName IS NULL,'* attribute not recognised *',@HistoricalAttributeName);
SET @RefsetName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @Refset);
SET @RefsetName = IF(@RefsetName IS NULL,'* refset not recognised *',@RefsetName);
INSERT INTO rf21_rel SELECT  '010101010', s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' FROM rf2_cRefSet s WHERE s.RefSetId = @Refset;
INSERT INTO IMPORTTIME_RF2 SET Event = CONCAT('     ',@HistoricalAttributeName,' from ',@RefSetName), DTSTAMP = '', TMSTAMP=CURRENT_TIME;

#SET @HistoricalAttribute = ''; /*  */
#SET @Refset = '999001351000000106';	/* WAS PACK OF association reference set (foundation metadata concept) */
#SET @HistoricalAttributeName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @HistoricalAttribute);
#SET @RefsetName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @Refset);
#INSERT INTO rf21_rel SELECT  '010101010', s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' FROM rf2_cRefSet s WHERE s.RefSetId = @Refset;
#INSERT INTO IMPORTTIME_RF2 SET Event = CONCAT('     ',@HistoricalAttributeName,' from ',@RefSetName), DTSTAMP = '', TMSTAMP=CURRENT_TIME;

SET @HistoricalAttribute = '384598002'; /* MOVED FROM */
SET @Refset = '900000000000525002';	/* MOVED FROM association reference set (foundation metadata concept) */
SET @HistoricalAttributeName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @HistoricalAttribute);
SET @HistoricalAttributeName = IF(@HistoricalAttributeName IS NULL,'* attribute not recognised *',@HistoricalAttributeName);
SET @RefsetName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @Refset);
SET @RefsetName = IF(@RefsetName IS NULL,'* refset not recognised *',@RefsetName);
INSERT INTO rf21_rel SELECT '010101010', s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' FROM rf2_cRefSet s WHERE s.RefSetId = @Refset;
INSERT INTO IMPORTTIME_RF2 SET Event = CONCAT('     ',@HistoricalAttributeName,' from ',@RefSetName), DTSTAMP = '', TMSTAMP=CURRENT_TIME;

SET @HistoricalAttribute = '370125004';    /* MOVED TO */
SET @Refset = '900000000000524003';	/* MOVED TO association reference set (foundation metadata concept) */
SET @HistoricalAttributeName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @HistoricalAttribute);
SET @HistoricalAttributeName = IF(@HistoricalAttributeName IS NULL,'* attribute not recognised *',@HistoricalAttributeName);
SET @RefsetName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @Refset);
SET @RefsetName = IF(@RefsetName IS NULL,'* refset not recognised *',@RefsetName);
INSERT INTO rf21_rel SELECT '010101010', s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' FROM rf2_cRefSet s WHERE s.RefSetId = @Refset;
INSERT INTO IMPORTTIME_RF2 SET Event = CONCAT('     ',@HistoricalAttributeName,' from ',@RefSetName), DTSTAMP = '', TMSTAMP=CURRENT_TIME;

SET @HistoricalAttribute = '149016008'; /*  MAY BE A */
SET @Refset = '900000000000523009';	/* POSSIBLY EQUIVALENT TO association reference set (foundation metadata concept) */
SET @HistoricalAttributeName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @HistoricalAttribute);
SET @RefsetName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @Refset);
SET @RefsetName = IF(@RefsetName IS NULL,'* refset not recognised *',@RefsetName);
INSERT INTO rf21_rel SELECT '010101010', s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' FROM rf2_cRefSet s WHERE s.RefSetId = @Refset;
INSERT INTO IMPORTTIME_RF2 SET Event = CONCAT('     ',@HistoricalAttributeName,' from ',@RefSetName), DTSTAMP = '', TMSTAMP=CURRENT_TIME;

SET @HistoricalAttribute = '370124000'; /* REPLACED_BY */
SET @Refset = '900000000000526001';	/* 'REPLACED BY association reference set (foundation metadata concept)' */
SET @HistoricalAttributeName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @HistoricalAttribute);
SET @HistoricalAttributeName = IF(@HistoricalAttributeName IS NULL,'* attribute not recognised *',@HistoricalAttributeName);
SET @RefsetName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @Refset);
SET @RefsetName = IF(@RefsetName IS NULL,'* refset not recognised *',@RefsetName);
INSERT INTO rf21_rel SELECT '010101010', s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' FROM rf2_cRefSet s WHERE s.RefSetId = @Refset;
INSERT INTO IMPORTTIME_RF2 SET Event = CONCAT('     ',@HistoricalAttributeName,' from ',@RefSetName), DTSTAMP = '', TMSTAMP=CURRENT_TIME;

SET @HistoricalAttribute = '168666000'; /* SAME_AS */
SET @Refset = '900000000000527005';	/* 'SAME AS association reference set (foundation metadata concept)' */
SET @HistoricalAttributeName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @HistoricalAttribute);
SET @HistoricalAttributeName = IF(@HistoricalAttributeName IS NULL,'* attribute not recognised *',@HistoricalAttributeName);
SET @RefsetName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @Refset);
SET @RefsetName = IF(@RefsetName IS NULL,'* refset not recognised *',@RefsetName);
INSERT INTO rf21_rel SELECT '010101010', s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' FROM rf2_cRefSet s WHERE s.RefSetId = @Refset;
INSERT INTO IMPORTTIME_RF2 SET Event = CONCAT('     ',@HistoricalAttributeName,' from ',@RefSetName), DTSTAMP = '', TMSTAMP=CURRENT_TIME;

SET @HistoricalAttribute = '159083000'; /* WAS A */
SET @Refset = '900000000000528000';	/* WAS A association reference set (foundation metadata concept) */
SET @HistoricalAttributeName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @HistoricalAttribute);
SET @HistoricalAttributeName = IF(@HistoricalAttributeName IS NULL,'* attribute not recognised *',@HistoricalAttributeName);
SET @RefsetName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @Refset);
SET @RefsetName = IF(@RefsetName IS NULL,'* refset not recognised *',@RefsetName);
INSERT INTO rf21_rel SELECT '010101010', s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' FROM rf2_cRefSet s WHERE s.RefSetId = @Refset;
INSERT INTO IMPORTTIME_RF2 SET Event = CONCAT('     ',@HistoricalAttributeName,' from ',@RefSetName), DTSTAMP = '', TMSTAMP=CURRENT_TIME;

#SET @HistoricalAttribute = ''; /*  */
#SET @Refset = '900000000000531004';	/* REFERS TO association reference set (foundation metadata concept) */
#SET @HistoricalAttributeName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @HistoricalAttribute);
#SET @RefsetName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @Refset);
#INSERT INTO rf21_rel SELECT  '010101010', s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' FROM rf2_cRefSet s WHERE s.RefSetId = @Refset;
#INSERT INTO IMPORTTIME_RF2 SET Event = CONCAT('     ',@HistoricalAttributeName,' from ',@RefSetName), DTSTAMP = '', TMSTAMP=CURRENT_TIME;

#SET @HistoricalAttribute = ''; /*  */
#SET @Refset = '900000000000529008';	/* SIMILAR TO association reference set (foundation metadata concept) */
#SET @HistoricalAttributeName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @HistoricalAttribute);
#SET @RefsetName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @Refset);
#INSERT INTO rf21_rel SELECT  '010101010', s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' FROM rf2_cRefSet s WHERE s.RefSetId = @Refset;
#INSERT INTO IMPORTTIME_RF2 SET Event = CONCAT('     ',@HistoricalAttributeName,' from ',@RefSetName), DTSTAMP = '', TMSTAMP=CURRENT_TIME;

INSERT INTO IMPORTTIME_RF2 SET Event = '      START INACTIVE CONCEPT isa to PARENT ROW RESTORATION', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

SET @InactiveParent = '363661006'; /* Reason not stated */
SET @InactiveParentName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @InactiveParent);
INSERT INTO rf21_rel SELECT  '101010101', c.CONCEPTID, '116680003', @InactiveParent, 0,0,0,c.SOURCE FROM rf21_concept c WHERE c.CONCEPTSTATUS = 1;
INSERT INTO IMPORTTIME_RF2 SET Event = CONCAT('      Done ',@InactiveParent,' ',@InactiveParentName), DTSTAMP = '', TMSTAMP=CURRENT_TIME;

SET @InactiveParent = '363662004'; /* Duplicate */
SET @InactiveParentName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @InactiveParent);
INSERT INTO rf21_rel SELECT  '101010101', c.CONCEPTID, '116680003', @InactiveParent, 0,0,0,c.SOURCE FROM rf21_concept c WHERE c.CONCEPTSTATUS = 2;
INSERT INTO IMPORTTIME_RF2 SET Event = CONCAT('      Done ',@InactiveParent,' ',@InactiveParentName), DTSTAMP = '', TMSTAMP=CURRENT_TIME;

SET @InactiveParent = '363663009'; /* Outdated */
SET @InactiveParentName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @InactiveParent);
INSERT INTO rf21_rel SELECT  '101010101', c.CONCEPTID, '116680003', @InactiveParent, 0,0,0,c.SOURCE FROM rf21_concept c WHERE c.CONCEPTSTATUS = 3;
INSERT INTO IMPORTTIME_RF2 SET Event = CONCAT('      Done ',@InactiveParent,' ',@InactiveParentName), DTSTAMP = '', TMSTAMP=CURRENT_TIME;

SET @InactiveParent = '363660007'; /*Ambiguous concept */
SET @InactiveParentName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @InactiveParent);
INSERT INTO rf21_rel SELECT  '101010101', c.CONCEPTID, '116680003', @InactiveParent, 0,0,0,c.SOURCE FROM rf21_concept c WHERE c.CONCEPTSTATUS = 4;
INSERT INTO IMPORTTIME_RF2 SET Event = CONCAT('      Done ',@InactiveParent,' ',@InactiveParentName), DTSTAMP = '', TMSTAMP=CURRENT_TIME;

SET @InactiveParent = '443559000'; /* Limited */
SET @InactiveParentName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @InactiveParent);
INSERT INTO rf21_rel SELECT  '101010101', c.CONCEPTID, '116680003', @InactiveParent, 0,0,0,c.SOURCE FROM rf21_concept c WHERE c.CONCEPTSTATUS = 6;
INSERT INTO IMPORTTIME_RF2 SET Event = CONCAT('      Done ',@InactiveParent,' ',@InactiveParentName), DTSTAMP = '', TMSTAMP=CURRENT_TIME;

SET @InactiveParent = '363664003'; /* Erroneous */
SET @InactiveParentName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @InactiveParent);
INSERT INTO rf21_rel SELECT  '101010101', c.CONCEPTID, '116680003', @InactiveParent, 0,0,0,c.SOURCE FROM rf21_concept c WHERE c.CONCEPTSTATUS = 5;
INSERT INTO IMPORTTIME_RF2 SET Event = CONCAT('      Done ',@InactiveParent,' ',@InactiveParentName), DTSTAMP = '', TMSTAMP=CURRENT_TIME;

SET @InactiveParent = '370126003'; /* Moved elsewhere */
SET @InactiveParentName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @InactiveParent);
INSERT INTO rf21_rel SELECT  '101010101', c.CONCEPTID, '116680003', @InactiveParent, 0,0,0,c.SOURCE FROM rf21_concept c WHERE c.CONCEPTSTATUS = 10;
INSERT INTO IMPORTTIME_RF2 SET Event = CONCAT('      Done ',@InactiveParent,' ',@InactiveParentName), DTSTAMP = '', TMSTAMP=CURRENT_TIME;

INSERT INTO IMPORTTIME_RF2 SET Event = '      END INACTIVE CONCEPT isa to PARENT ROW RESTORATION', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
INSERT INTO IMPORTTIME_RF2 SET Event = '    END HISTORICAL RELATIONSHIP ROW RESTORATION', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
INSERT INTO IMPORTTIME_RF2 SET Event = '  END RECONSTRUCT SCT1_RELATIONSHIPS', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

INSERT INTO IMPORTTIME_RF2 SET Event = '  START RECONSTRUCT SCT1_SUBSETS', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

INSERT INTO rf21_subsetlist SELECT DISTINCT 
	m.OriginalSubsetID AS SubsetID, 
	m.OriginalSubsetID AS OriginalSubsetID, 
	1 AS SUBSETVERSION, 
	m.SubsetName AS SUBSETNAME, 
	2 AS SUBSETTYPE, 
	'en_GB' AS LANGUAGECODE, 
	'0080' AS SubsetRealmID, 
	0 AS CONTEXTID
FROM rf2_refset s 
	INNER JOIN rf2_subset2refset m ON s.refsetId = m.refsetId
	INNER JOIN rf21_rel r ON s.refsetId = r.CONCEPTID1 AND r.RELATIONSHIPTYPE = '116680003' AND r.CONCEPTID2 = '446609009'; #Simple type reference set 

INSERT INTO rf21_subsets SELECT m.OriginalSubsetId AS SubsetId, referencedComponentId AS MemberID, 1 AS MemberStatus, 0 AS LinkedID 
FROM rf2_refset s 
	INNER JOIN rf2_subset2refset m ON s.refsetId = m.refsetId
	INNER JOIN rf21_rel r ON s.refsetId = r.CONCEPTID1 AND r.RELATIONSHIPTYPE = '116680003' AND r.CONCEPTID2 = '446609009'; #Simple type reference set 

INSERT INTO rf21_subsetlist SELECT DISTINCT 
	m.OriginalSubsetID AS SubsetID, 
	m.OriginalSubsetID AS OriginalSubsetID, 
	1 AS SUBSETVERSION, 
	m.SubsetName AS SUBSETNAME, 
	IF(LEFT(RIGHT(s.refsetId,3),1) = 1,3,1) AS SUBSETTYPE, 
	'en_GB' AS LANGUAGECODE, 
	'0080' AS SubsetRealmID, 
	0 AS CONTEXTID
FROM rf2_crefset s 
	INNER JOIN rf2_subset2refset m ON s.refsetId = m.refsetId
	INNER JOIN rf21_rel r ON s.refsetId = r.CONCEPTID1 AND r.RELATIONSHIPTYPE = '116680003' AND r.CONCEPTID2 = '900000000000507009'; #English [International Organization for Standardization 639-1 code en] language reference set  

INSERT INTO rf21_subsets SELECT m.OriginalSubsetId AS SubsetId, referencedComponentId AS MemberID, IF(linkedComponentId = '900000000000549004',2,1) AS MemberStatus, 0 AS LinkedID 
FROM rf2_crefset s 
	INNER JOIN rf2_subset2refset m ON s.refsetId = m.refsetId
	INNER JOIN rf21_rel r ON s.refsetId = r.CONCEPTID1 AND r.RELATIONSHIPTYPE = '116680003' AND r.CONCEPTID2 = '900000000000507009'; #English [International Organization for Standardization 639-1 code en] language reference set  

INSERT INTO IMPORTTIME_RF2 SET Event = '  END RECONSTRUCT SCT1_SUBSETS', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

INSERT INTO IMPORTTIME_RF2 SET Event = 'END Extract RF1 snapshot', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

END $$

DROP PROCEDURE IF EXISTS `RF2_RF1SnapshotQA` $$
CREATE PROCEDURE RF2_RF1SnapshotQA()
BEGIN

INSERT INTO IMPORTTIME_RF2 SET Event = 'START QA RF21 SNAPSHOT', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

INSERT INTO IMPORTTIME_RF2 SET Event = '*** CONCEPTS ***', DTSTAMP = '', TMSTAMP='';

SET @Res = (SELECT COUNT(r1.CONCEPTID) FROM RF1_CONCEPT r1 LEFT JOIN RF21_CONCEPT r2 ON r1.CONCEPTID = r2.CONCEPTID WHERE r2.CONCEPTID IS NULL);
INSERT INTO IMPORTTIME_RF2 SET EVENT = '  Concepts in RF1 but missing from RF21', DTSTAMP = @Res, TMSTAMP = '';

SET @Res = (SELECT COUNT(r2.CONCEPTID) FROM RF21_CONCEPT r2 LEFT JOIN RF1_CONCEPT r1 ON r1.CONCEPTID = r2.CONCEPTID WHERE r1.CONCEPTID IS NULL AND INSTR(r2.FULLYSPECIFIEDNAME,'metadata concept') = 0 AND r2.SOURCE <> 'META');
INSERT INTO IMPORTTIME_RF2 SET EVENT = '  Extra concepts in RF21 (excluding metadata)',DTSTAMP = @Res, TMSTAMP = '';

SET @Res = (SELECT COUNT(r2.CONCEPTID) FROM RF21_CONCEPT r2 LEFT JOIN RF1_CONCEPT r1 ON r1.CONCEPTID = r2.CONCEPTID WHERE r1.CONCEPTID IS NULL AND INSTR(r2.FULLYSPECIFIEDNAME,'metadata concept') = 0 AND r1.SOURCE = 'CORE');
INSERT INTO IMPORTTIME_RF2 SET EVENT = '  ......of which from IHTSDO CORE', DTSTAMP = @Res, TMSTAMP = '';

SET @Res = (SELECT COUNT(r2.CONCEPTID) FROM RF21_CONCEPT r2 LEFT JOIN RF1_CONCEPT r1 ON r1.CONCEPTID = r2.CONCEPTID WHERE r1.CONCEPTID IS NULL AND INSTR(r2.FULLYSPECIFIEDNAME,'metadata concept') = 0 AND r1.SOURCE = 'UKEX');
INSERT INTO IMPORTTIME_RF2 SET EVENT = '  ......of which from UK Clinical Extension', DTSTAMP = @Res, TMSTAMP = '';

SET @Res = (SELECT COUNT(r2.CONCEPTID) FROM RF21_CONCEPT r2 LEFT JOIN RF1_CONCEPT r1 ON r1.CONCEPTID = r2.CONCEPTID WHERE r1.CONCEPTID IS NULL AND INSTR(r2.FULLYSPECIFIEDNAME,'metadata concept') = 0 AND r1.SOURCE = 'UKDG');
INSERT INTO IMPORTTIME_RF2 SET EVENT = '  ......of which from UK Drug Extension', DTSTAMP = @Res, TMSTAMP = '';

SET @Res = (SELECT COUNT(r2.CONCEPTID) FROM RF21_CONCEPT r2 INNER JOIN RF1_CONCEPT r1 ON r1.CONCEPTID = r2.CONCEPTID);
INSERT INTO IMPORTTIME_RF2 SET EVENT = '  Concepts in both RF1 and RF21',DTSTAMP = @Res, TMSTAMP = '';

SET @Res = (SELECT COUNT(r1.CONCEPTID) FROM RF1_CONCEPT r1 INNER JOIN RF21_CONCEPT r2 ON r1.CONCEPTID = r2.CONCEPTID WHERE r1.CONCEPTSTATUS <> r2.CONCEPTSTATUS);
INSERT INTO IMPORTTIME_RF2 SET EVENT = '  ...but with different ConceptStatus', DTSTAMP = @Res, TMSTAMP = '';

SET @Res = (SELECT COUNT(r1.CONCEPTID) FROM RF1_CONCEPT r1 INNER JOIN RF21_CONCEPT r2 ON r1.CONCEPTID = r2.CONCEPTID WHERE r1.FULLYSPECIFIEDNAME <> r2.FULLYSPECIFIEDNAME);
INSERT INTO IMPORTTIME_RF2 SET EVENT = '  ...but with different FSN', DTSTAMP = @Res, TMSTAMP = '';

SET @Res = (SELECT COUNT(r1.CONCEPTID) FROM RF1_CONCEPT r1 INNER JOIN RF21_CONCEPT r2 ON r1.CONCEPTID = r2.CONCEPTID WHERE r1.FULLYSPECIFIEDNAME <> r2.FULLYSPECIFIEDNAME AND r1.SOURCE = 'CORE');
INSERT INTO IMPORTTIME_RF2 SET EVENT = '  ......of which from IHTSDO CORE', DTSTAMP = @Res, TMSTAMP = '';
SET @Res = (SELECT COUNT(r1.CONCEPTID) FROM RF1_CONCEPT r1 INNER JOIN RF21_CONCEPT r2 ON r1.CONCEPTID = r2.CONCEPTID WHERE r1.FULLYSPECIFIEDNAME <> r2.FULLYSPECIFIEDNAME AND r1.SOURCE = 'UKEX');
INSERT INTO IMPORTTIME_RF2 SET EVENT = '  ......of which from UK Clinical Extension', DTSTAMP = @Res, TMSTAMP = '';
SET @Res = (SELECT COUNT(r1.CONCEPTID) FROM RF1_CONCEPT r1 INNER JOIN RF21_CONCEPT r2 ON r1.CONCEPTID = r2.CONCEPTID WHERE r1.FULLYSPECIFIEDNAME <> r2.FULLYSPECIFIEDNAME AND r1.SOURCE = 'UKDG');
INSERT INTO IMPORTTIME_RF2 SET EVENT = '  ......of which from UK Drug Extension', DTSTAMP = @Res, TMSTAMP = '';

SET @Res = (SELECT COUNT(r1.CONCEPTID) FROM RF1_CONCEPT r1 INNER JOIN RF21_CONCEPT r2 ON r1.CONCEPTID = r2.CONCEPTID WHERE r1.ISPRIMITIVE <> r2.ISPRIMITIVE);
INSERT INTO IMPORTTIME_RF2 SET EVENT = '  ...but with different ISPRIMITIVE', DTSTAMP = @Res, TMSTAMP = '';
SET @Res = (SELECT COUNT(r1.CONCEPTID) FROM RF1_CONCEPT r1 INNER JOIN RF21_CONCEPT r2 ON r1.CONCEPTID = r2.CONCEPTID WHERE r1.ISPRIMITIVE <> r2.ISPRIMITIVE AND r1.SOURCE = 'CORE');
INSERT INTO IMPORTTIME_RF2 SET EVENT = '  ......of which from IHTSDO CORE', DTSTAMP = @Res, TMSTAMP = '';
SET @Res = (SELECT COUNT(r1.CONCEPTID) FROM RF1_CONCEPT r1 INNER JOIN RF21_CONCEPT r2 ON r1.CONCEPTID = r2.CONCEPTID WHERE r1.ISPRIMITIVE <> r2.ISPRIMITIVE AND r1.SOURCE = 'UKEX');
INSERT INTO IMPORTTIME_RF2 SET EVENT = '  ......of which from UK Clinical Extension', DTSTAMP = @Res, TMSTAMP = '';
SET @Res = (SELECT COUNT(r1.CONCEPTID) FROM RF1_CONCEPT r1 INNER JOIN RF21_CONCEPT r2 ON r1.CONCEPTID = r2.CONCEPTID WHERE r1.ISPRIMITIVE <> r2.ISPRIMITIVE AND r1.SOURCE = 'UKEX' AND r1.ISPRIMITIVE = 0 AND r2.ISPRIMITIVE = 1 AND r1.CONCEPTSTATUS NOT IN  (0,11));
INSERT INTO IMPORTTIME_RF2 SET EVENT = '  .........of which expected: RF1 inactive defined >> RF2 inactive primitive', DTSTAMP = @Res, TMSTAMP = @Res;

SET @Res = (SELECT COUNT(r1.CONCEPTID) FROM RF1_CONCEPT r1 INNER JOIN RF21_CONCEPT r2 ON r1.CONCEPTID = r2.CONCEPTID WHERE r1.ISPRIMITIVE <> r2.ISPRIMITIVE AND r1.SOURCE = 'UKDG');
INSERT INTO IMPORTTIME_RF2 SET EVENT = '  ......of which from UK Drug Extension', DTSTAMP = @Res, TMSTAMP = '';
SET @Res = (SELECT COUNT(r1.CONCEPTID) FROM RF1_CONCEPT r1 INNER JOIN RF21_CONCEPT r2 ON r1.CONCEPTID = r2.CONCEPTID WHERE r1.ISPRIMITIVE <> r2.ISPRIMITIVE AND r1.SOURCE = 'UKDG' AND r1.ISPRIMITIVE = 0 AND r2.ISPRIMITIVE = 1 AND r1.CONCEPTSTATUS NOT IN  (0,11));
INSERT INTO IMPORTTIME_RF2 SET EVENT = '  .........of which expected: RF1 inactive defined >> RF2 inactive primitive', DTSTAMP = @Res, TMSTAMP = @Res;

SET @Res = (SELECT COUNT(r1.CONCEPTID) FROM RF1_CONCEPT r1 INNER JOIN RF21_CONCEPT r2 ON r1.CONCEPTID = r2.CONCEPTID WHERE r1.CTV3ID <> r2.CTV3ID);
INSERT INTO IMPORTTIME_RF2 SET EVENT = '  ...but with different CTV3ID', DTSTAMP = @Res, TMSTAMP = '';

SET @Res = (SELECT COUNT(r1.CONCEPTID) FROM RF1_CONCEPT r1 INNER JOIN RF21_CONCEPT r2 ON r1.CONCEPTID = r2.CONCEPTID WHERE r1.SNOMEDID <> r2.SNOMEDID);
INSERT INTO IMPORTTIME_RF2 SET EVENT = '  ...but with different SNOMEDID', DTSTAMP = @Res, TMSTAMP = '';

SET @Res = (SELECT COUNT(r1.CONCEPTID) FROM RF1_CONCEPT r1 INNER JOIN RF21_CONCEPT r2 ON r1.CONCEPTID = r2.CONCEPTID WHERE r1.SOURCE <> r2.SOURCE);
INSERT INTO IMPORTTIME_RF2 SET EVENT = '  ...but with different SOURCE', DTSTAMP = @Res, TMSTAMP = '';

INSERT INTO IMPORTTIME_RF2 SET Event = '*** DESCRIPTIONS ***', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

-- CALL analyze_rf2description;

INSERT INTO IMPORTTIME_RF2 SET Event = '*** RELATIONSHIPS ***', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

SET @TRes = (SELECT COUNT(r1.RELATIONSHIPID) FROM REL r1 LEFT JOIN RF21_REL r2 ON (r1.CONCEPTID1 = r2.CONCEPTID1 AND r1.CONCEPTID2 = r2.CONCEPTID2 AND r1.RELATIONSHIPTYPE = r2.RELATIONSHIPTYPE) WHERE r2.RELATIONSHIPID IS NULL);
INSERT INTO IMPORTTIME_RF2 SET EVENT = '  Relationships in RF1 but missing from RF21', DTSTAMP = @TRes, TMSTAMP = '';

SET @Res = (SELECT COUNT(r1.RELATIONSHIPID) FROM REL r1 LEFT JOIN RF21_REL r2 ON (r1.CONCEPTID1 = r2.CONCEPTID1 AND r1.CONCEPTID2 = r2.CONCEPTID2 AND r1.RELATIONSHIPTYPE = r2.RELATIONSHIPTYPE) WHERE r2.RELATIONSHIPID IS NULL AND r1.CharacteristicType = 0);
INSERT INTO IMPORTTIME_RF2 SET EVENT = '  ...of which defining relationship in RF1', DTSTAMP = @Res, TMSTAMP = '';

SET @Res = (SELECT COUNT(r1.RELATIONSHIPID) FROM REL r1 LEFT JOIN RF21_REL r2 ON (r1.CONCEPTID1 = r2.CONCEPTID1 AND r1.CONCEPTID2 = r2.CONCEPTID2 AND r1.RELATIONSHIPTYPE = r2.RELATIONSHIPTYPE) WHERE r2.RELATIONSHIPID IS NULL AND r1.CharacteristicType = 0 AND r1.RELATIONSHIPTYPE = '116680003');
INSERT INTO IMPORTTIME_RF2 SET EVENT = '  ......of which Is-A relationships missing from RF21', DTSTAMP = @Res, TMSTAMP = '';

SET @Res = (SELECT COUNT(r1.RELATIONSHIPID) FROM REL r1 LEFT JOIN RF21_REL r2 ON (r1.CONCEPTID1 = r2.CONCEPTID1 AND r1.CONCEPTID2 = r2.CONCEPTID2 AND r1.RELATIONSHIPTYPE = r2.RELATIONSHIPTYPE) WHERE r2.RELATIONSHIPID IS NULL AND r1.CharacteristicType = 0 AND r1.RELATIONSHIPTYPE = '116680003' AND r1.CONCEPTID1 IN ('106237007','370136006'));
INSERT INTO IMPORTTIME_RF2 SET EVENT = '  .........of which expected: RF1 has different parents for Linkage and Navigational Concept', DTSTAMP = @Res, TMSTAMP = 2;

SET @Tres = @Tres - @Res;

SET @Res = (SELECT COUNT(r1.RELATIONSHIPID) FROM REL r1 LEFT JOIN RF21_REL r2 ON (r1.CONCEPTID1 = r2.CONCEPTID1 AND r1.CONCEPTID2 = r2.CONCEPTID2 AND r1.RELATIONSHIPTYPE = r2.RELATIONSHIPTYPE) WHERE r2.RELATIONSHIPID IS NULL AND r1.CharacteristicType = 1);
INSERT INTO IMPORTTIME_RF2 SET EVENT = '  ...of which optional qualifier in RF1', DTSTAMP = @Res, TMSTAMP = @Res;

SET @Tres = @Tres - @Res;

SET @Res = (SELECT COUNT(r1.RELATIONSHIPID) FROM REL r1 LEFT JOIN RF21_REL r2 ON (r1.CONCEPTID1 = r2.CONCEPTID1 AND r1.CONCEPTID2 = r2.CONCEPTID2 AND r1.RELATIONSHIPTYPE = r2.RELATIONSHIPTYPE) WHERE r2.RELATIONSHIPID IS NULL AND r1.CharacteristicType = 2);
INSERT INTO IMPORTTIME_RF2 SET EVENT = '  ...of which Historical Relationship in RF1', DTSTAMP = @Res, TMSTAMP = '';

SET @Res = (SELECT COUNT(r1.RELATIONSHIPID) FROM REL r1 LEFT JOIN RF21_REL r2 ON (r1.CONCEPTID1 = r2.CONCEPTID1 AND r1.CONCEPTID2 = r2.CONCEPTID2 AND r1.RELATIONSHIPTYPE = r2.RELATIONSHIPTYPE) WHERE r2.RELATIONSHIPID IS NULL AND r1.CharacteristicType = 2 AND r1.SOURCE = 'CORE');
INSERT INTO IMPORTTIME_RF2 SET EVENT = '  ......of which from RF1 IHTSDO Core', DTSTAMP = @Res, TMSTAMP = '';

SET @Res = (SELECT COUNT(r1.RELATIONSHIPID) FROM REL r1 LEFT JOIN RF21_REL r2 ON (r1.CONCEPTID1 = r2.CONCEPTID1 AND r1.CONCEPTID2 = r2.CONCEPTID2 AND r1.RELATIONSHIPTYPE = r2.RELATIONSHIPTYPE) WHERE r2.RELATIONSHIPID IS NULL AND r1.CharacteristicType = 2 AND r1.SOURCE = 'UKEX');
INSERT INTO IMPORTTIME_RF2 SET EVENT = '  ......of which from RF1 UK Clinical Extension', DTSTAMP = @Res, TMSTAMP = '';

SET @Res = (SELECT COUNT(r1.RELATIONSHIPID) FROM REL r1 LEFT JOIN RF21_REL r2 ON (r1.CONCEPTID1 = r2.CONCEPTID1 AND r1.CONCEPTID2 = r2.CONCEPTID2 AND r1.RELATIONSHIPTYPE = r2.RELATIONSHIPTYPE) WHERE r2.RELATIONSHIPID IS NULL AND r1.CharacteristicType = 2 AND r1.SOURCE = 'UKDG');
INSERT INTO IMPORTTIME_RF2 SET EVENT = '  ......of which from RF1 UK Drug Extension', DTSTAMP = @Res, TMSTAMP = '';

SET @Res = (SELECT COUNT(r1.RELATIONSHIPID) FROM REL r1 LEFT JOIN RF21_REL r2 ON (r1.CONCEPTID1 = r2.CONCEPTID1 AND r1.CONCEPTID2 = r2.CONCEPTID2 AND r1.RELATIONSHIPTYPE = r2.RELATIONSHIPTYPE) WHERE r2.RELATIONSHIPID IS NULL AND r1.CharacteristicType = 2 AND r1.SOURCE = 'UKDG' AND r1.RELATIONSHIPTYPE = '10363501000001105');
INSERT INTO IMPORTTIME_RF2 SET EVENT = '  .........of which from HAD_AMP relationships', DTSTAMP = @Res, TMSTAMP = '';

SET @Tres = @Tres - @Res;

SET @Res = (SELECT COUNT(r1.RELATIONSHIPID) FROM REL r1 LEFT JOIN RF21_REL r2 ON (r1.CONCEPTID1 = r2.CONCEPTID1 AND r1.CONCEPTID2 = r2.CONCEPTID2 AND r1.RELATIONSHIPTYPE = r2.RELATIONSHIPTYPE) WHERE r2.RELATIONSHIPID IS NULL AND r1.CharacteristicType = 2 AND r1.SOURCE = 'UKDG' AND r1.RELATIONSHIPTYPE = '10363401000001106');
INSERT INTO IMPORTTIME_RF2 SET EVENT = '  .........of which from HAD_VMP relationships', DTSTAMP = @Res, TMSTAMP = '';

SET @Tres = @Tres - @Res;

SET @Res = (SELECT COUNT(r1.RELATIONSHIPID) FROM REL r1 LEFT JOIN RF21_REL r2 ON (r1.CONCEPTID1 = r2.CONCEPTID1 AND r1.CONCEPTID2 = r2.CONCEPTID2 AND r1.RELATIONSHIPTYPE = r2.RELATIONSHIPTYPE) WHERE r2.RELATIONSHIPID IS NULL AND r1.CharacteristicType = 3);
INSERT INTO IMPORTTIME_RF2 SET EVENT = '  ...of which RELATIONSHIPTYPE = additional in RF1', DTSTAMP = @Res, TMSTAMP = '';

INSERT INTO IMPORTTIME_RF2 SET EVENT = '  FINAL: Unexplained relationships missing from RF21', DTSTAMP = @TRes, TMSTAMP = '';

SET @TRes = (SELECT COUNT(r1.RELATIONSHIPID) FROM RF21_REL r2 
				LEFT JOIN REL r1 ON (r1.CONCEPTID1 = r2.CONCEPTID1 AND r1.CONCEPTID2 = r2.CONCEPTID2 AND r1.RELATIONSHIPTYPE = r2.RELATIONSHIPTYPE)
				INNER JOIN RF21_CONCEPT c1 ON r2.CONCEPTID1 = c1.CONCEPTID
				INNER JOIN RF21_CONCEPT c2 ON r2.CONCEPTID2 = c2.CONCEPTID
			WHERE r1.RELATIONSHIPID IS NULL AND INSTR(c1.FULLYSPECIFIEDNAME,'metadata') = 0 AND INSTR(c2.FULLYSPECIFIEDNAME,'metadata') = 0);
INSERT INTO IMPORTTIME_RF2 SET EVENT = '  Extra relationships only in RF21 (excluding on metadata)', DTSTAMP = @Res, TMSTAMP = '';

SET @Res = (SELECT COUNT(r1.RELATIONSHIPID) FROM REL r1 INNER JOIN RF21_REL r2 ON (r1.CONCEPTID1 = r2.CONCEPTID1 AND r1.CONCEPTID2 = r2.CONCEPTID2 AND r1.RELATIONSHIPTYPE = r2.RELATIONSHIPTYPE AND r1.CharacteristicType = r2.CharacteristicType));
INSERT INTO IMPORTTIME_RF2 SET EVENT = '  Relationships in both RF1 and RF21', DTSTAMP = @Res, TMSTAMP = '';

SET @Res = (SELECT COUNT(r1.RELATIONSHIPID) FROM RF21_REL r2 INNER JOIN REL r1 ON (r1.CONCEPTID1 = r2.CONCEPTID1 AND r1.CONCEPTID2 = r2.CONCEPTID2 AND r1.RELATIONSHIPTYPE = r2.RELATIONSHIPTYPE)
           WHERE r1.CharacteristicType <> r2.CharacteristicType);
INSERT INTO IMPORTTIME_RF2 SET EVENT = '  ...but with different CharacteristicType', DTSTAMP = @Res, TMSTAMP = '';
INSERT INTO IMPORTTIME_RF2 SET EVENT = '     (0=defining, 1=optional, 2=historical, 3=other)', DTSTAMP = '', TMSTAMP = '';

INSERT INTO IMPORTTIME_RF2 
SELECT CONCAT('    rf1:',r1.CharacteristicType,' vs rf2:',r2.CharacteristicType)  AS EVENT, COUNT(r1.RELATIONSHIPID) AS DTSTAMP, '' AS TMSTAMP
	FROM RF21_REL r2 LEFT JOIN REL r1 ON (r1.CONCEPTID1 = r2.CONCEPTID1 AND r1.CONCEPTID2 = r2.CONCEPTID2 AND r1.RELATIONSHIPTYPE = r2.RELATIONSHIPTYPE)
	WHERE r1.CharacteristicType <> r2.CharacteristicType GROUP BY r1.CharacteristicType, r2.CharacteristicType ORDER BY r1.CharacteristicType, r2.CharacteristicType; 

INSERT INTO IMPORTTIME_RF2 SET EVENT = '  ...but with different CharacteristicType (by module)', DTSTAMP = @Res, TMSTAMP = '';
INSERT INTO IMPORTTIME_RF2 SET EVENT = '     (0=defining, 1=optional, 2=historical, 3=other)', DTSTAMP = '', TMSTAMP = '';

INSERT INTO IMPORTTIME_RF2 
SELECT CONCAT('    ',r1.SOURCE,' -- rf1:',r1.CharacteristicType,' vs rf2:',r2.CharacteristicType)  AS EVENT, COUNT(r1.RELATIONSHIPID) AS DTSTAMP, '' AS TMSTAMP
	FROM RF21_REL r2 LEFT JOIN REL r1 ON (r1.CONCEPTID1 = r2.CONCEPTID1 AND r1.CONCEPTID2 = r2.CONCEPTID2 AND r1.RELATIONSHIPTYPE = r2.RELATIONSHIPTYPE)
    WHERE r1.CharacteristicType <> r2.CharacteristicType GROUP BY r1.SOURCE, r1.CharacteristicType, r2.CharacteristicType ORDER BY r1.SOURCE, r1.CharacteristicType, r2.CharacteristicType; 

SET @Res = (SELECT COUNT(r1.RELATIONSHIPID) FROM RF21_REL r2 INNER JOIN REL r1 
			ON (r1.CONCEPTID1 = r2.CONCEPTID1 AND r1.CONCEPTID2 = r2.CONCEPTID2 AND r1.RELATIONSHIPTYPE = r2.RELATIONSHIPTYPE AND r1.CharacteristicType = r2.CharacteristicType)
            WHERE r1.RELATIONSHIPID <> r2.RELATIONSHIPID);
INSERT INTO IMPORTTIME_RF2 SET EVENT = '  ...but with different RelationshipID', DTSTAMP = @Res, TMSTAMP = '';

INSERT INTO IMPORTTIME_RF2 
SELECT CONCAT('         ',r1.SOURCE,' [',r1.CharacteristicType,']')  AS EVENT, COUNT(r1.RELATIONSHIPID) AS DTSTAMP, '' AS TMSTAMP
	FROM RF21_REL r2 INNER JOIN REL r1 
	ON (r1.CONCEPTID1 = r2.CONCEPTID1 AND r1.CONCEPTID2 = r2.CONCEPTID2 AND r1.RELATIONSHIPTYPE = r2.RELATIONSHIPTYPE AND r1.CharacteristicType = r2.CharacteristicType)
    WHERE r1.RELATIONSHIPID <> r2.RELATIONSHIPID GROUP BY r1.SOURCE, r1.CharacteristicType ORDER BY r1.CharacteristicType,r1.SOURCE; 

SET @Res = (SELECT COUNT(r1.RELATIONSHIPID) FROM REL r1 INNER JOIN RF21_REL r2 ON (r1.CONCEPTID1 = r2.CONCEPTID1 AND r1.CONCEPTID2 = r2.CONCEPTID2 AND r1.RELATIONSHIPTYPE = r2.RELATIONSHIPTYPE)
			WHERE r1.Refinability <> r2.Refinability);
INSERT INTO IMPORTTIME_RF2 SET EVENT = '  ...but with different Refinability', DTSTAMP = @Res, TMSTAMP = '';

SET @Res = (SELECT COUNT(r1.RELATIONSHIPID) FROM REL r1 INNER JOIN RF21_REL r2 ON (r1.CONCEPTID1 = r2.CONCEPTID1 AND r1.CONCEPTID2 = r2.CONCEPTID2 AND r1.RELATIONSHIPTYPE = r2.RELATIONSHIPTYPE)
			WHERE r1.RELATIONSHIPGROUP <> r2.RELATIONSHIPGROUP);
INSERT INTO IMPORTTIME_RF2 SET EVENT = '  ...but with different RelationshipGroup', DTSTAMP = @Res, TMSTAMP = '';

SET @Res = (SELECT COUNT(r1.RELATIONSHIPID) FROM REL r1 INNER JOIN RF21_REL r2 ON (r1.CONCEPTID1 = r2.CONCEPTID1 AND r1.CONCEPTID2 = r2.CONCEPTID2 AND r1.RELATIONSHIPTYPE = r2.RELATIONSHIPTYPE)
			WHERE r1.SOURCE <> r2.SOURCE);
INSERT INTO IMPORTTIME_RF2 SET EVENT = '  ...but with different Source', DTSTAMP = @Res, TMSTAMP = '';

INSERT INTO IMPORTTIME_RF2 SET Event = '*** SUBSETLIST ***', DTSTAMP = '', TMSTAMP='';

SET @Res = (SELECT COUNT(l.SUBSETORIGINALID) AS NUM FROM subsetlist l LEFT JOIN rf21_subsetlist r ON l.SubsetOriginalId = r.SubsetOriginalID WHERE r.SubsetOriginalID IS NULL);
INSERT INTO IMPORTTIME_RF2 SET Event = ' Subsets only in RF1', DTSTAMP = @Res, TMSTAMP='';
INSERT INTO IMPORTTIME_RF2 SELECT CONCAT('    ',l.SUBSETORIGINALID,' ',l.SubsetName) AS EVENT, '' AS DTSTAMP, '' AS TMSTAMP FROM subsetlist l LEFT JOIN rf21_subsetlist r ON l.SubsetOriginalId = r.SubsetOriginalID WHERE r.SubsetOriginalID IS NULL;

SET @Res = (SELECT COUNT(l.SUBSETORIGINALID) AS NUM FROM rf21_subsetlist l LEFT JOIN subsetlist r ON l.SubsetOriginalId = r.SubsetOriginalID WHERE r.SubsetOriginalID IS NULL);
INSERT INTO IMPORTTIME_RF2 SET Event = ' Subsets only in RF2', DTSTAMP = @Res, TMSTAMP='';
INSERT INTO IMPORTTIME_RF2 SELECT CONCAT('    ',l.SUBSETORIGINALID,' ',l.SubsetName) AS EVENT, '' AS DTSTAMP, '' AS TMSTAMP FROM rf21_subsetlist l LEFT JOIN rf21_subsetlist r ON l.SubsetOriginalId = r.SubsetOriginalID WHERE r.SubsetOriginalID IS NULL;

SET @Res = (SELECT COUNT(l.SUBSETORIGINALID) AS NUM FROM subsetlist l INNER JOIN rf21_subsetlist r ON l.SubsetOriginalId = r.SubsetOriginalID);
INSERT INTO IMPORTTIME_RF2 SET Event = ' Subsets common to RF1 and RF2', DTSTAMP = @Res, TMSTAMP='';

INSERT INTO IMPORTTIME_RF2 SET Event = ' ...of which also sharing same:', DTSTAMP = @Res, TMSTAMP='';

	SET @Res = (SELECT COUNT(l.SUBSETORIGINALID) AS NUM FROM subsetlist l INNER JOIN rf21_subsetlist r ON l.SubsetOriginalId = r.SubsetOriginalID WHERE l.SUBSETID = r.SUBSETID);
	INSERT INTO IMPORTTIME_RF2 SET Event = '    SubsetId', DTSTAMP = @Res, TMSTAMP='';
	
	SET @Res = (SELECT COUNT(l.SUBSETORIGINALID) AS NUM FROM subsetlist l INNER JOIN rf21_subsetlist r ON l.SubsetOriginalId = r.SubsetOriginalId WHERE l.SubsetVersion = r.SubsetVersion);
	INSERT INTO IMPORTTIME_RF2 SET Event = '    SubsetVersion', DTSTAMP = @Res, TMSTAMP='';
	
	SET @Res = (SELECT COUNT(l.SUBSETORIGINALID) AS NUM FROM subsetlist l INNER JOIN rf21_subsetlist r ON l.SubsetOriginalId = r.SubsetOriginalId WHERE l.SubsetName = r.SubsetName);
	INSERT INTO IMPORTTIME_RF2 SET Event = '    SubsetName', DTSTAMP = @Res, TMSTAMP='';
	
	SET @Res = (SELECT COUNT(l.SUBSETORIGINALID) AS NUM FROM subsetlist l INNER JOIN rf21_subsetlist r ON l.SubsetOriginalId = r.SubsetOriginalId WHERE l.SubsetType = r.SubsetType);
	INSERT INTO IMPORTTIME_RF2 SET Event = '    SubsetType', DTSTAMP = @Res, TMSTAMP='';
	
	SET @Res = (SELECT COUNT(l.SUBSETORIGINALID) AS NUM FROM subsetlist l INNER JOIN rf21_subsetlist r ON l.SubsetOriginalId = r.SubsetOriginalId WHERE l.LanguageCode = r.LanguageCode);
	INSERT INTO IMPORTTIME_RF2 SET Event = '    LanguageCode', DTSTAMP = @Res, TMSTAMP='';
	
	SET @Res = (SELECT COUNT(l.SUBSETORIGINALID) AS NUM FROM subsetlist l INNER JOIN rf21_subsetlist r ON l.SubsetOriginalId = r.SubsetOriginalId WHERE l.SubsetRealmID = r.SubsetRealmID);
	INSERT INTO IMPORTTIME_RF2 SET Event = '    SubsetRealmID', DTSTAMP = @Res, TMSTAMP='';
	
	SET @Res = (SELECT COUNT(l.SUBSETORIGINALID) AS NUM FROM subsetlist l INNER JOIN rf21_subsetlist r ON l.SubsetOriginalId = r.SubsetOriginalId WHERE l.ContextID = r.ContextID);
	INSERT INTO IMPORTTIME_RF2 SET Event = '    ContextID', DTSTAMP = @Res, TMSTAMP='';

INSERT INTO IMPORTTIME_RF2 SET Event = '*** MEMBERSHIP OF COMMON SUBSETS ***', DTSTAMP = '', TMSTAMP='';

INSERT INTO IMPORTTIME_RF2 SET Event = 'RF1 SubsetType = 1 (Language)', DTSTAMP = '', TMSTAMP='';
INSERT INTO IMPORTTIME_RF2 SELECT CONCAT('  ',r1.S, ' ',r1.SubsetName) AS EVENT, IF(r2.S IS NULL,'MISSING',IF(r1.NUM = r2.NUM,'SAME',CONCAT('DIFFERENT (n=',r1.Num-r2.NUM,')'))) AS DTSTAMP, '' AS TMSTAMP
FROM (SELECT l.SubsetOriginalID AS S, l.SubsetName AS SubsetName, COUNT(s.MEMBERID) AS NUM FROM subsets s INNER JOIN subsetlist l ON s.SUBSETID = l.SUBSETID WHERE l.SUBSETTYPE = 1 GROUP BY s.SubsetID) r1
LEFT JOIN (SELECT SubsetID AS S, COUNT(MEMBERID) AS NUM FROM rf21_subsets GROUP BY SubsetID) r2 ON r1.S = r2.S;

INSERT INTO IMPORTTIME_RF2 SET Event = 'RF1 SubsetType = 2 (Realm Concept)', DTSTAMP = '', TMSTAMP='';

INSERT INTO IMPORTTIME_RF2 SELECT CONCAT('  ',r1.S, ' ',r1.SubsetName) AS EVENT, IF(r2.S IS NULL,'MISSING',IF(r1.NUM = r2.NUM,'SAME',CONCAT('DIFFERENT (n=',r1.Num-r2.NUM,')'))) AS DTSTAMP, '' AS TMSTAMP
FROM (SELECT l.SubsetOriginalID AS S, l.SubsetName AS SubsetName, COUNT(s.MEMBERID) AS NUM FROM subsets s INNER JOIN subsetlist l ON s.SUBSETID = l.SUBSETID WHERE l.SUBSETTYPE = 2 GROUP BY s.SubsetID) r1
LEFT JOIN (SELECT SubsetID AS S, COUNT(MEMBERID) AS NUM FROM rf21_subsets GROUP BY SubsetID) r2 ON r1.S = r2.S;

INSERT INTO IMPORTTIME_RF2 SET Event = 'RF1 SubsetType = 3 (Realm Description)', DTSTAMP = '', TMSTAMP='';

INSERT INTO IMPORTTIME_RF2 SELECT CONCAT('  ',r1.S, ' ',r1.SubsetName) AS EVENT, IF(r2.S IS NULL,'MISSING',IF(r1.NUM = r2.NUM,'SAME',CONCAT('DIFFERENT (n=',r1.Num-r2.NUM,')'))) AS DTSTAMP, '' AS TMSTAMP
FROM (SELECT l.SubsetOriginalID AS S, l.SubsetName AS SubsetName, COUNT(s.MEMBERID) AS NUM FROM subsets s INNER JOIN subsetlist l ON s.SUBSETID = l.SUBSETID WHERE l.SUBSETTYPE = 3 GROUP BY s.SubsetID) r1
LEFT JOIN (SELECT SubsetID AS S, COUNT(MEMBERID) AS NUM FROM rf21_subsets GROUP BY SubsetID) r2 ON r1.S = r2.S;

INSERT INTO IMPORTTIME_RF2 SET Event = 'RF1 SubsetType = 4 (Realm Relationship)', DTSTAMP = '', TMSTAMP='';

INSERT INTO IMPORTTIME_RF2 SELECT CONCAT('  ',r1.S, ' ',r1.SubsetName) AS EVENT, IF(r2.S IS NULL,'MISSING',IF(r1.NUM = r2.NUM,'SAME',CONCAT('DIFFERENT (n=',r1.Num-r2.NUM,')'))) AS DTSTAMP, '' AS TMSTAMP
FROM (SELECT l.SubsetOriginalID AS S, l.SubsetName AS SubsetName, COUNT(s.MEMBERID) AS NUM FROM subsets s INNER JOIN subsetlist l ON s.SUBSETID = l.SUBSETID WHERE l.SUBSETTYPE = 4 GROUP BY s.SubsetID) r1
LEFT JOIN (SELECT SubsetID AS S, COUNT(MEMBERID) AS NUM FROM rf21_subsets GROUP BY SubsetID) r2 ON r1.S = r2.S;

INSERT INTO IMPORTTIME_RF2 SET Event = 'RF1 SubsetType = 5 (Context Concept)', DTSTAMP = '', TMSTAMP='';

INSERT INTO IMPORTTIME_RF2 SELECT CONCAT('  ',r1.S, ' ',r1.SubsetName) AS EVENT, IF(r2.S IS NULL,'MISSING',IF(r1.NUM = r2.NUM,'SAME',CONCAT('DIFFERENT (n=',r1.Num-r2.NUM,')'))) AS DTSTAMP, '' AS TMSTAMP
FROM (SELECT l.SubsetOriginalID AS S, l.SubsetName AS SubsetName, COUNT(s.MEMBERID) AS NUM FROM subsets s INNER JOIN subsetlist l ON s.SUBSETID = l.SUBSETID WHERE l.SUBSETTYPE = 5 GROUP BY s.SubsetID) r1
LEFT JOIN (SELECT SubsetID AS S, COUNT(MEMBERID) AS NUM FROM rf21_subsets GROUP BY SubsetID) r2 ON r1.S = r2.S;

INSERT INTO IMPORTTIME_RF2 SET Event = 'RF1 SubsetType = 6 (Context Description)', DTSTAMP = '', TMSTAMP='';

INSERT INTO IMPORTTIME_RF2 SELECT CONCAT('  ',r1.S, ' ',r1.SubsetName) AS EVENT, IF(r2.S IS NULL,'MISSING',IF(r1.NUM = r2.NUM,'SAME',CONCAT('DIFFERENT (n=',r1.Num-r2.NUM,')'))) AS DTSTAMP, '' AS TMSTAMP
FROM (SELECT l.SubsetOriginalID AS S, l.SubsetName AS SubsetName, COUNT(s.MEMBERID) AS NUM FROM subsets s INNER JOIN subsetlist l ON s.SUBSETID = l.SUBSETID WHERE l.SUBSETTYPE = 6 GROUP BY s.SubsetID) r1
LEFT JOIN (SELECT SubsetID AS S, COUNT(MEMBERID) AS NUM FROM rf21_subsets GROUP BY SubsetID) r2 ON r1.S = r2.S;

INSERT INTO IMPORTTIME_RF2 SET Event = 'RF1 SubsetType = 7 (Navigation)', DTSTAMP = '', TMSTAMP='';

INSERT INTO IMPORTTIME_RF2 SELECT CONCAT('  ',r1.S, ' ',r1.SubsetName) AS EVENT, IF(r2.S IS NULL,'MISSING',IF(r1.NUM = r2.NUM,'SAME',CONCAT('DIFFERENT (n=',r1.Num-r2.NUM,')'))) AS DTSTAMP, '' AS TMSTAMP
FROM (SELECT l.SubsetOriginalID AS S, l.SubsetName AS SubsetName, COUNT(s.MEMBERID) AS NUM FROM subsets s INNER JOIN subsetlist l ON s.SUBSETID = l.SUBSETID WHERE l.SUBSETTYPE = 7 GROUP BY s.SubsetID) r1
LEFT JOIN (SELECT SubsetID AS S, COUNT(MEMBERID) AS NUM FROM rf21_subsets GROUP BY SubsetID) r2 ON r1.S = r2.S;

INSERT INTO IMPORTTIME_RF2 SET Event = 'RF1 SubsetType = 8 (Duplicate Terms)', DTSTAMP = '', TMSTAMP='';

INSERT INTO IMPORTTIME_RF2 SELECT CONCAT('  ',r1.S, ' ',r1.SubsetName) AS EVENT, IF(r2.S IS NULL,'MISSING',IF(r1.NUM = r2.NUM,'SAME',CONCAT('DIFFERENT (n=',r1.Num-r2.NUM,')'))) AS DTSTAMP, '' AS TMSTAMP
FROM (SELECT l.SubsetOriginalID AS S, l.SubsetName AS SubsetName, COUNT(s.MEMBERID) AS NUM FROM subsets s INNER JOIN subsetlist l ON s.SUBSETID = l.SUBSETID WHERE l.SUBSETTYPE = 8 GROUP BY s.SubsetID) r1
LEFT JOIN (SELECT SubsetID AS S, COUNT(MEMBERID) AS NUM FROM rf21_subsets GROUP BY SubsetID) r2 ON r1.S = r2.S;

INSERT INTO IMPORTTIME_RF2 SET Event = 'END QA RF1 SNAPSHOT', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

END $$

DELIMITER ;