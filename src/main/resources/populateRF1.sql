
CREATE ALIAS magicNumberFor FOR "org.ihtsdo.snomed.rf2torf1conversion.RF1Constants.getMagicNumber";

CREATE ALIAS moduleSourceFor FOR "org.ihtsdo.snomed.rf2torf1conversion.RF1Constants.getModuleSource";

CREATE ALIAS statusFor FOR "org.ihtsdo.snomed.rf2torf1conversion.RF1Constants.translateActive";

CREATE ALIAS descTypeFor FOR "org.ihtsdo.snomed.rf2torf1conversion.RF1Constants.translateDescType";

CREATE ALIAS capitalStatusFor FOR "org.ihtsdo.snomed.rf2torf1conversion.RF1Constants.translateCaseSensitive";

CREATE ALIAS characteristicFor FOR "org.ihtsdo.snomed.rf2torf1conversion.RF1Constants.translateCharacteristic";

CREATE ALIAS refinabilityFor FOR "org.ihtsdo.snomed.rf2torf1conversion.RF1Constants.translateRefinability";

DROP TABLE IF EXISTS rf21_CONCEPT;
CREATE TABLE rf21_CONCEPT (
	CONCEPTID	         VARCHAR (18) NOT NULL,
	CONCEPTSTATUS        TINYINT (2) UNSIGNED NOT NULL,
	FULLYSPECIFIEDNAME   VARCHAR (255)  NOT NULL,
	CTV3ID               BINARY (5) NOT NULL,
    SNOMEDID             VARBINARY (8) NOT NULL,
    ISPRIMITIVE          TINYINT (1) UNSIGNED NOT NULL,
    SOURCE               BINARY (4) NOT NULL);

/* Table: TERM : Table of unique Terms and their IDs*/
DROP TABLE IF EXISTS rf21_TERM;
CREATE TABLE rf21_TERM (
	DESCRIPTIONID		 VARCHAR (18) NOT NULL,
	DESCRIPTIONSTATUS		TINYINT (2) UNSIGNED NOT NULL,
	CONCEPTID				VARCHAR (18) NOT NULL,
	TERM					VARCHAR (255)  NOT NULL,
	INITIALCAPITALSTATUS	TINYINT (1) UNSIGNED NOT NULL,
	US_DESC_TYPE			TINYINT (1) UNSIGNED NOT NULL,
	GB_DESC_TYPE			TINYINT (1) UNSIGNED NOT NULL,
	LANGUAGECODE			VARCHAR (5) NOT NULL,
	SOURCE					BINARY(4) NOT NULL);

/* Table: DEF : Table of text definitions */
DROP TABLE IF EXISTS rf21_DEF;
CREATE TABLE rf21_DEF (
 CONCEPTID             VARCHAR (18) NOT NULL,
 SNOMEDID              VARBINARY (8) NOT NULL,
 FULLYSPECIFIEDNAME    VARCHAR (255)  NOT NULL,
 DEFINITION            VARCHAR (450)  NOT NULL);

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
  SubsetName       VARCHAR(255)  NOT NULL,
  SubsetType       TINYINT (1) UNSIGNED NOT NULL,
  LanguageCode     VARCHAR(5),
  SubsetRealmID    VARBINARY (10) NOT NULL,
  ContextID        TINYINT (1) UNSIGNED NOT NULL);

DROP TABLE IF EXISTS rf21_SUBSETS;
CREATE TABLE rf21_SUBSETS (
  SubsetId     VARCHAR (18) NOT NULL,
  MemberID     VARCHAR (18) NOT NULL,
  MemberStatus TINYINT (1) UNSIGNED NOT NULL,
  LinkedID     VARCHAR(18) );

DROP TABLE IF EXISTS rf21_XMAPLIST;
CREATE TABLE rf21_XMAPLIST (
  MapSetId             VARCHAR (18) NOT NULL,
  MapSetName           VARCHAR (255)  NOT NULL,
  MapSetType           BINARY (1) NOT NULL,
  MapSetSchemeID       VARBINARY (64) NOT NULL,
  MapSetSchemeName     VARCHAR (255)  NOT NULL,
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
  MapRule        VARCHAR(255)  NOT NULL,
  MapAdvice      VARCHAR(255)  NOT NULL);

DROP TABLE IF EXISTS rf21_XMAPTARGET;
CREATE TABLE rf21_XMAPTARGET (
  TargetID       VARCHAR (18) NOT NULL,
  TargetSchemeID VARCHAR (64)  NOT NULL,
  TargetCodes    VARCHAR(255) ,
  TargetRule     VARCHAR(255)  NOT NULL,
  TargetAdvice   VARCHAR(255)  NOT NULL);

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
   REASON          VARCHAR(255)  NOT NULL,
   SOURCE          BINARY(4) NOT NULL);

INSERT INTO rf21_concept
SELECT DISTINCT
  id AS CONCEPTID,
  statusFor(active) AS CONCEPTSTATUS,
  '' AS FULLYSPECIFIEDNAME,
  'Xxxxx' AS CTV3ID,
  'Xxxxx' AS SNOMEDID,
  magicNumberFor(definitionStatusId) AS ISPRIMITIVE,
  moduleSourceFor(moduleId) AS SOURCE
FROM rf2_concept;

SET @FullySpecifiedName = '900000000000003001';
SET @Definition = '900000000000550004';
SET @EntireTermCaseSensitive = '900000000000017005';

INSERT INTO rf21_term
SELECT
  id AS DESCRIPTIONID,
  statusFor(active) AS DESCRIPTIONSTATUS,
  conceptId AS CONCEPTID,
  term AS TERM,
  capitalStatusFor(caseSignificanceId) AS INITIALCAPITALSTATUS,
  descTypeFor(typeID) AS US_DESC_TYPE, -- assigns all FSNs but labels all other terms as 'synonyms'
  descTypeFor(typeID) AS GB_DESC_TYPE, -- assigns all FSNs but labels all other terms as 'synonyms'
  languageCode AS LANGUAGECODE,
  moduleSourceFor(moduleId) AS SOURCE
FROM rf2_term;

INSERT INTO rf21_def
SELECT
  conceptId AS CONCEPTID,
  '' AS SNOMEDID,
  '' AS FULLYSPECIFIEDNAME,
  term AS TERM
FROM rf2_def WHERE active = 1;

SET @Stated = '900000000000010007';
INSERT INTO rf21_rel
SELECT
  id AS RELATIONSHIPID,
  sourceId AS CONCEPTID1,
  typeId AS RELATIONSHIPTYPE,
  destinationId AS CONCEPTD2,
  characteristicFor(characteristicTypeId) AS CHARACTERISTICTYPE,
  9 AS REFINABILITY, -- default 3 to signify refinability not known
  relationshipGroup AS RELATIONSHIPGROUP,
  moduleSourceFor(moduleId) AS SOURCE
FROM rf2_rel WHERE characteristicTypeId <> @Stated; /* Ignore stated relationships */

CREATE UNIQUE INDEX CONCEPT_CUI_X ON rf21_concept(CONCEPTID);
CREATE INDEX TERM_CUI_X ON rf21_term(CONCEPTID);
CREATE UNIQUE INDEX TERM_TUI_X ON rf21_term(DESCRIPTIONID);
CREATE INDEX IDX_REL_CUI1_X ON rf21_rel(CONCEPTID1);
CREATE INDEX IDX_REL_RELATION_X ON rf21_rel(RELATIONSHIPTYPE);
CREATE INDEX IDX_REL_CUI2_X ON rf21_rel(CONCEPTID2);

-- Very unpleasant workaround in H2 for lack of join with update

/* Concepts in the FULL tables but NOT in the snapshot must be EITHER some flavour of inactive OR pending move 
   Determine the reason for inactivation, or pending move status, from the appropriate refset
   Any concept that is NEITHER current NOR pending move NOR has a reason for retirement explicitly represented in the RefSet, must implicitly be correctly the default 'retired no reason' */

UPDATE rf21_concept c 
SET c.conceptstatus = ( 
	select magicNumberFor(s1.linkedComponentId) 
	from rf2_crefset s1
	where s1.refSetId ='900000000000489007'
	and s1.active = 1
	and s1.referencedComponentId = c.CONCEPTID),
c.SOURCE = ( 
	select moduleSourceFor(s2.moduleId)
	from rf2_crefset s2
	where s2.refSetId ='900000000000489007'
	and s2.active = 1
	and s2.referencedComponentId = c.CONCEPTID)
where c.CONCEPTID in (
	select s3.referencedComponentId
	from rf2_crefset s3
	where s3.refSetId ='900000000000489007'
	and s3.active = 1
	and s3.referencedComponentId = c.CONCEPTID);

UPDATE rf21_concept c
SET c.CTV3ID = (select s.linkedString from rf2_srefset s
where c.conceptid = s.referencedComponentId
and s.refSetId ='900000000000497000'
) WHERE c.conceptid in (
select s2.referencedComponentId 
from rf2_srefset s2 
where s2.refSetId ='900000000000497000');  -- CTV3


-- UPDATE rf21_concept C INNER JOIN rf2_srefset s ON c.CONCEPTID = s.referencedComponentId
-- SET c.SNOMEDID = s.linkedString WHERE s.refSetId ='900000000000498005' /* SNOMED RT identifier simple map (foundation metadata concept) */
UPDATE rf21_concept c
SET c.SNOMEDID = (select s.linkedString from rf2_srefset s
where c.conceptid = s.referencedComponentId
and s.refSetId ='900000000000498005'
) WHERE c.conceptid in (
select s2.referencedComponentId 
from rf2_srefset s2 
where s2.refSetId ='900000000000498005');  -- SNOMED RT ID

-- UPDATE rf21_term t INNER JOIN rf2_crefset s ON t.DESCRIPTIONID = s.referencedComponentId
-- SET t.DESCRIPTIONSTATUS = magicNumberFor(linkedComponentId) WHERE s.refSetId ='900000000000490003' AND s.active = 1 /* Description inactivation indicator attribute value reference set (foundation metadata concept) */
UPDATE rf21_term t
set t.DESCRIPTIONSTATUS = (
	select magicNumberFor(s.linkedComponentId) 
	from rf2_crefset s
	where s.referencedComponentId = t.descriptionid
	and s.refSetId ='900000000000490003' 
	AND s.active = 1)
WHERE t.descriptionid in (
	select s2.referencedComponentId
	from  rf2_crefset s2
	where s2.refSetId ='900000000000490003' 
	AND s2.active = 1);

-- UPDATE rf21_concept c INNER JOIN rf21_term t 
-- ON c.CONCEPTID = t.CONCEPTID SET c.FULLYSPECIFIEDNAME = t.TERM 
-- WHERE t.DESCRIPTIONTYPE = 3 AND t.DESCRIPTIONSTATUS IN (0,6,8,11);
UPDATE rf21_concept c
SET c.FULLYSPECIFIEDNAME = ( 
	select t.term from rf21_term t
	where t.conceptid = c.conceptid
	and t.US_DESC_TYPE = 3 
	and t.DESCRIPTIONSTATUS IN (0,6,8,11))
WHERE c.conceptid IN (
	select t.conceptid from rf21_term t
	where t.US_DESC_TYPE = 3 
	and t.DESCRIPTIONSTATUS IN (0,6,8,11));

SET @USRefSet = '900000000000509007'; /* United States of America English language reference set  */
SET @GBRefSet = '900000000000508004'; /* Great Britain English language reference set (foundation metadata concept) */

UPDATE rf21_term SET LANGUAGECODE = 'en';
-- Set language code as en-GB when no en-US row exists and visa versa
UPDATE rf21_term t
SET t.LANGUAGECODE = 'en-GB'
WHERE EXISTS (
	select 1 from rf2_crefset gb LEFT JOIN rf2_crefset us
		ON gb.referencedComponentId = us.referencedComponentId
		and us.refSetId = @USRefSet
		AND us.active = 1
	where gb.refSetId = @GBRefSet
	and gb.referencedComponentId = t.descriptionId
	and gb.active = 1
	AND us.referencedComponentId is null
);

UPDATE rf21_term t
SET t.LANGUAGECODE = 'en-US'
WHERE EXISTS (
	select 1 from rf2_crefset us LEFT JOIN rf2_crefset gb
		ON us.referencedComponentId = gb.referencedComponentId
		and gb.refSetId = @GBRefSet
		AND gb.active = 1
	where us.refSetId = @USRefSet
	and us.referencedComponentId = t.descriptionId
	and us.active = 1
	AND gb.referencedComponentId is null
);

SET @Acceptable = '900000000000549004';
SET @Preferred = '900000000000548007';
SET @USRefSet = '900000000000509007'; /* United States of America English language reference set  */
SET @GBRefSet = '900000000000508004'; /* Great Britain English language reference set (foundation metadata concept) */

-- Description types were set to synonym by default, then FSN were picked up, so now just detect preferred for each language
UPDATE rf21_term t
SET t.US_DESC_TYPE = 1
WHERE EXISTS (
	select 1 from rf2_crefset us
	where us.refsetID = @USRefSet
	and t.DESCRIPTIONID = us.referencedComponentId
	and us.linkedComponentId = @Preferred );

UPDATE rf21_term t
SET t.GB_DESC_TYPE = 1
WHERE EXISTS (
	select 1 from rf2_crefset gb
	where gb.refsetID = @GBRefSet
	and t.DESCRIPTIONID = gb.referencedComponentId
	and gb.linkedComponentId = @Preferred );

UPDATE rf21_def d
SET d.FULLYSPECIFIEDNAME = (
	select c.fullyspecifiedname 
	from rf21_concept c
	where c.conceptid = d.conceptid
),
d.SNOMEDID = (
	select c2.snomedid 
	from rf21_concept c2
	where c2.conceptid = d.conceptid
);
	
UPDATE rf21_rel r
SET r.REFINABILITY = refinabilityFor(r.characteristicType);

SET @HistoricalAttribute = '10363501000001105'; /* HAD AMP */
SET @Refset = '999001311000000107';	/* Had actual medicinal product association reference set (foundation metadata concept) */
INSERT INTO rf21_rel SELECT  '010101010', s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' FROM rf2_cRefSet s WHERE s.RefSetId = @Refset;

SET @HistoricalAttribute = '10363401000001106'; /* HAD VMP */
SET @Refset = '999001321000000101';	/* Had virtual medicinal product association reference set (foundation metadata concept) */
INSERT INTO rf21_rel SELECT  '010101010', s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' FROM rf2_cRefSet s WHERE s.RefSetId = @Refset;

SET @HistoricalAttribute = '384598002'; /* MOVED FROM */
SET @Refset = '900000000000525002';	/* MOVED FROM association reference set (foundation metadata concept) */
INSERT INTO rf21_rel SELECT '010101010', s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' FROM rf2_cRefSet s WHERE s.RefSetId = @Refset;

SET @HistoricalAttribute = '370125004';    /* MOVED TO */
SET @Refset = '900000000000524003';	/* MOVED TO association reference set (foundation metadata concept) */
INSERT INTO rf21_rel SELECT '010101010', s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' FROM rf2_cRefSet s WHERE s.RefSetId = @Refset;

SET @HistoricalAttribute = '149016008'; /*  MAY BE A */
SET @Refset = '900000000000523009';	/* POSSIBLY EQUIVALENT TO association reference set (foundation metadata concept) */
INSERT INTO rf21_rel SELECT '010101010', s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' FROM rf2_cRefSet s WHERE s.RefSetId = @Refset;

SET @HistoricalAttribute = '370124000'; /* REPLACED_BY */
SET @Refset = '900000000000526001';	/* 'REPLACED BY association reference set (foundation metadata concept)' */
INSERT INTO rf21_rel SELECT '010101010', s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' FROM rf2_cRefSet s WHERE s.RefSetId = @Refset;

SET @HistoricalAttribute = '168666000'; /* SAME_AS */
SET @Refset = '900000000000527005';	/* 'SAME AS association reference set (foundation metadata concept)' */
INSERT INTO rf21_rel SELECT '010101010', s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' FROM rf2_cRefSet s WHERE s.RefSetId = @Refset;

SET @HistoricalAttribute = '159083000'; /* WAS A */
SET @Refset = '900000000000528000';	/* WAS A association reference set (foundation metadata concept) */
INSERT INTO rf21_rel SELECT '010101010', s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' FROM rf2_cRefSet s WHERE s.RefSetId = @Refset;


SET @InactiveParent = '363661006'; /* Reason not stated */
INSERT INTO rf21_rel SELECT  '101010101', c.CONCEPTID, '116680003', @InactiveParent, 0,0,0,c.SOURCE FROM rf21_concept c WHERE c.CONCEPTSTATUS = 1;

SET @InactiveParent = '363662004'; /* Duplicate */
INSERT INTO rf21_rel SELECT  '101010101', c.CONCEPTID, '116680003', @InactiveParent, 0,0,0,c.SOURCE FROM rf21_concept c WHERE c.CONCEPTSTATUS = 2;

SET @InactiveParent = '363663009'; /* Outdated */
INSERT INTO rf21_rel SELECT  '101010101', c.CONCEPTID, '116680003', @InactiveParent, 0,0,0,c.SOURCE FROM rf21_concept c WHERE c.CONCEPTSTATUS = 3;

SET @InactiveParent = '363660007'; /*Ambiguous concept */
INSERT INTO rf21_rel SELECT  '101010101', c.CONCEPTID, '116680003', @InactiveParent, 0,0,0,c.SOURCE FROM rf21_concept c WHERE c.CONCEPTSTATUS = 4;

SET @InactiveParent = '443559000'; /* Limited */
INSERT INTO rf21_rel SELECT  '101010101', c.CONCEPTID, '116680003', @InactiveParent, 0,0,0,c.SOURCE FROM rf21_concept c WHERE c.CONCEPTSTATUS = 6;

SET @InactiveParent = '363664003'; /* Erroneous */
INSERT INTO rf21_rel SELECT  '101010101', c.CONCEPTID, '116680003', @InactiveParent, 0,0,0,c.SOURCE FROM rf21_concept c WHERE c.CONCEPTSTATUS = 5;

SET @InactiveParent = '370126003'; /* Moved elsewhere */
INSERT INTO rf21_rel SELECT  '101010101', c.CONCEPTID, '116680003', @InactiveParent, 0,0,0,c.SOURCE FROM rf21_concept c WHERE c.CONCEPTSTATUS = 10;

INSERT INTO rf21_subsetlist SELECT DISTINCT 
	m.OriginalSubsetID AS SubsetID, 
	m.OriginalSubsetID AS OriginalSubsetID, 
	1 AS SUBSETVERSION, 
	m.SubsetName AS SUBSETNAME, 
	CASE WHEN LEFT(RIGHT(s.refsetId,3),1) = 1 THEN 3 ELSE 1 END AS SUBSETTYPE, 
	'en-GB' AS LANGUAGECODE, 
	'0080' AS SubsetRealmID, 
	0 AS CONTEXTID
FROM rf2_crefset s 
	INNER JOIN rf2_subset2refset m 
		ON s.refsetId = m.refsetId
	INNER JOIN rf21_rel r 
		ON s.refsetId = r.CONCEPTID1 
		AND r.RELATIONSHIPTYPE = '116680003' 
		AND r.CONCEPTID2 = '900000000000507009'; 
	-- English [International Organization for Standardization 639-1 code en] language reference set  
	-- This matches both types of English Lang refset ie US and GB

INSERT INTO rf21_subsets 
	SELECT m.OriginalSubsetId AS SubsetId, referencedComponentId AS MemberID, 
	CASE WHEN linkedComponentId = '900000000000549004' THEN 2 ELSE 1 END AS MemberStatus, 
	0 AS LinkedID 
	FROM rf2_crefset s 
	INNER JOIN rf2_subset2refset m 
		ON s.refsetId = m.refsetId
	INNER JOIN rf21_rel r 
		ON s.refsetId = r.CONCEPTID1 
		AND r.RELATIONSHIPTYPE = '116680003' 
		AND r.CONCEPTID2 = '900000000000507009'; -- English [International Organization for Standardization 639-1 code en] language reference set  

