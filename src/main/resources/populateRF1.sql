
CREATE ALIAS magicNumberFor FOR "org.ihtsdo.snomed.rf2torf1conversion.RF1Constants.getMagicNumber";

CREATE ALIAS moduleSourceFor FOR "org.ihtsdo.snomed.rf2torf1conversion.RF1Constants.getModuleSource";

CREATE ALIAS statusFor FOR "org.ihtsdo.snomed.rf2torf1conversion.RF1Constants.translateActive";

CREATE ALIAS descTypeFor FOR "org.ihtsdo.snomed.rf2torf1conversion.RF1Constants.translateDescType";

CREATE ALIAS capitalStatusFor FOR "org.ihtsdo.snomed.rf2torf1conversion.RF1Constants.translateCaseSensitive";

CREATE ALIAS characteristicFor FOR "org.ihtsdo.snomed.rf2torf1conversion.RF1Constants.translateCharacteristic";

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
	DESCRIPTIONID	     VARCHAR (18) NOT NULL,
	DESCRIPTIONSTATUS    TINYINT (2) UNSIGNED NOT NULL,
	CONCEPTID	         VARCHAR (18) NOT NULL,
	TERM                 VARCHAR (255)  NOT NULL,
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
  LanguageCode     VARBINARY(5),
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
  descTypeFor(typeID) AS DEFAULTDESCTYPE, -- assigns all FSNs but labels all other terms as 'synonyms'
  descTypeFor(typeID) AS DESCRIPTIONTYPE, -- assigns all FSNs but labels all other terms as 'synonyms'
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


UPDATE rf21_concept C INNER JOIN rf2_srefset s ON c.CONCEPTID = s.referencedComponentId
SET c.SNOMEDID = s.linkedString WHERE s.refSetId ='900000000000498005'; /* SNOMED RT identifier simple map (foundation metadata concept) */

UPDATE rf21_term t INNER JOIN rf2_crefset s ON t.DESCRIPTIONID = s.referencedComponentId
SET t.DESCRIPTIONSTATUS = magicNumberFor(linkedComponentId) WHERE s.refSetId ='900000000000490003' AND s.active = 1; /* Description inactivation indicator attribute value reference set (foundation metadata concept) */

UPDATE rf21_term SET LANGUAGECODE = 'en';
UPDATE rf21_concept c INNER JOIN rf21_term t ON c.CONCEPTID = t.CONCEPTID SET c.FULLYSPECIFIEDNAME = t.TERM WHERE t.DESCRIPTIONTYPE = 3 AND t.DESCRIPTIONSTATUS IN (0,6,8,11);

SET @USRefSet = '900000000000509007'; /* United States of America English language reference set  */
SET @GBRefSet = '900000000000508004'; /* Great Britain English language reference set (foundation metadata concept) */
SET @USRefsetName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @USRefSet);
SET @GBRefsetName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @Refset);
UPDATE rf21_term t
	LEFT JOIN rf2_crefset us ON (t.DESCRIPTIONID = us.referencedComponentId AND us.refSetId = @USRefSet AND us.active = 1)
	LEFT JOIN rf2_crefset gb ON (t.DESCRIPTIONID = gb.referencedComponentId AND gb.refSetId = @GBRefSet AND gb.active = 1)
SET t.LANGUAGECODE = CASE WHEN gb.refsetId IS NULL,CASE WHEN us.refsetId IS NULL,'en','en-US'),CASE WHEN us.refsetId IS NULL,'en-GB','en')); 

SET @RefSet = '999001251000000103'; /* United Kingdom Extension Great Britain English language reference set (foundation metadata concept) */
SET @RefsetName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @Refset);
SET @RefsetName = CASE WHEN @RefsetName IS NULL,'* refset not recognised *',@RefsetName);
UPDATE rf21_term t INNER JOIN rf2_crefset s ON t.DESCRIPTIONID = s.referencedComponentId
SET t.LANGUAGECODE = CASE WHEN t.LANGUAGECODE = 'en-US','en','en-GB') WHERE s.refSetId = @RefSet AND s.active = 1;

SET @RefSet = '999000681000001101'; /* United Kingdom Drug Extension Great Britain English language reference set (foundation metadata concept) */
SET @RefsetName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @Refset);
SET @RefsetName = CASE WHEN @RefsetName IS NULL,'* refset not recognised *',@RefsetName);
UPDATE rf21_term t INNER JOIN rf2_crefset s ON t.DESCRIPTIONID = s.referencedComponentId
SET t.LANGUAGECODE = CASE WHEN t.LANGUAGECODE = 'en-US','en','en-GB') WHERE s.refSetId = @RefSet  AND s.active = 1;

SET @Acceptable = '900000000000549004';
SET @Preferred = '900000000000548007';
SET @USRefSet = '900000000000509007'; /* United States of America English language reference set  */
SET @GBRefSet = '900000000000508004'; /* Great Britain English language reference set (foundation metadata concept) */

UPDATE rf21_term t
	LEFT JOIN rf2_crefset us ON (t.DESCRIPTIONID = us.referencedComponentId AND us.refSetId = @USRefSet)
	LEFT JOIN rf2_crefset gb ON (t.DESCRIPTIONID = gb.referencedComponentId AND gb.refSetId = @GBRefSet)
	SET t.DESCRIPTIONTYPE = CASE WHEN gb.refsetId IS NULL,
	CASE WHEN us.refsetID IS NULL,
		t.DEFAULTDESCTYPE, #not in either refset
		CASE WHEN us.linkedComponentId = @Preferred, CASE WHEN t.DEFAULTDESCTYPE = 3,3,1),CASE WHEN us.linkedComponentId = @Acceptable,2,0)) #only in US refset
	),
	CASE WHEN us.refsetID IS NULL,
		CASE WHEN gb.linkedComponentId = @Preferred, CASE WHEN t.DEFAULTDESCTYPE = 3,3,1),CASE WHEN gb.linkedComponentId = @Acceptable,2,0)), #only in GB refset
		CASE WHEN us.linkedComponentId = gb.linkedComponentId,CASE WHEN gb.linkedComponentId = @Preferred, CASE WHEN t.DEFAULTDESCTYPE = 3,3,1),CASE WHEN gb.linkedComponentId = @Acceptable,2,0)),0) #in both refsets
	)
	); 


SET @RefSet = '999001251000000103'; /* United Kingdom Extension Great Britain English language reference set (foundation metadata concept) */
SET @RefsetName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @Refset);
SET @RefsetName = CASE WHEN @RefsetName IS NULL,'* refset not recognised *',@RefsetName);
UPDATE rf21_term t INNER JOIN rf2_crefset s ON t.DESCRIPTIONID = s.referencedComponentId
SET t.DESCRIPTIONTYPE = CASE WHEN linkedComponentId = @Preferred,CASE WHEN t.DEFAULTDESCTYPE = 3,3,1),CASE WHEN linkedComponentId = @Acceptable,2,0)) WHERE s.refSetId = @RefSet;

SET @RefSet = '999000681000001101'; /* United Kingdom Drug Extension Great Britain English language reference set (foundation metadata concept) */
SET @RefsetName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @Refset);
SET @RefsetName = CASE WHEN @RefsetName IS NULL,'* refset not recognised *',@RefsetName);
UPDATE rf21_term t INNER JOIN rf2_crefset s ON t.DESCRIPTIONID = s.referencedComponentId
SET t.DESCRIPTIONTYPE = CASE WHEN linkedComponentId = @Preferred,CASE WHEN t.DEFAULTDESCTYPE = 3,3,1),CASE WHEN linkedComponentId = @Acceptable,2,0)) WHERE s.refSetId = @RefSet;

UPDATE rf21_term t INNER JOIN rf2_crefset s ON t.DESCRIPTIONID = s.referencedComponentId
SET t.DESCRIPTIONTYPE = 1 WHERE linkedComponentId = @Preferred AND t.DEFAULTDESCTYPE <> 3 AND s.refSetId IN ('999001251000000103','999000681000001101') AND t.DESCRIPTIONTYPE <> 1;

SET @RefSetClin = '999001261000000100'; /* National Health Service realm language reference set (clinical part)  */
SET @RefsetName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @RefSetClin);
SET @RefsetName = CASE WHEN @RefsetName IS NULL,'* refset not recognised *',@RefsetName);

UPDATE rf21_term t INNER JOIN rf2_crefset s ON t.DESCRIPTIONID = s.referencedComponentId
SET t.DESCRIPTIONTYPE = CASE WHEN linkedComponentId = @Preferred,CASE WHEN t.DEFAULTDESCTYPE = 3,3,1),CASE WHEN linkedComponentId = @Acceptable,CASE WHEN t.DEFAULTDESCTYPE = 3,3,2),0)) 
WHERE s.refSetId = @RefSetClin;

SET @RefsetPharm = '999000691000001104'; /* National Health Service realm language reference set (pharmacy part)  */
SET @RefsetName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @RefSetClin);
SET @RefsetName = CASE WHEN @RefsetName IS NULL,'* refset not recognised *',@RefsetName);

UPDATE rf21_term t INNER JOIN rf2_crefset s ON t.DESCRIPTIONID = s.referencedComponentId
SET t.DESCRIPTIONTYPE = CASE WHEN linkedComponentId = @Preferred,CASE WHEN t.DEFAULTDESCTYPE = 3,3,1),CASE WHEN linkedComponentId = @Acceptable,CASE WHEN t.DEFAULTDESCTYPE = 3,3,2),0)) 
WHERE s.refSetId = @RefsetPharm;

UPDATE rf21_term t INNER JOIN rf2_crefset s ON t.DESCRIPTIONID = s.referencedComponentId
SET t.DESCRIPTIONTYPE = 1 WHERE linkedComponentId = @Preferred AND t.DEFAULTDESCTYPE <> 3 AND s.refSetId IN (@RefSetClin,@RefsetPharm) AND t.DESCRIPTIONTYPE <> 1;

SET @RefSet = '999000671000001103'; /* National Health Service dictionary of medicines and devices realm language reference set   */
SET @RefsetName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @RefSetClin);
SET @RefsetName = CASE WHEN @RefsetName IS NULL,'* refset not recognised *',@RefsetName);

UPDATE rf21_term t INNER JOIN rf2_crefset s ON t.DESCRIPTIONID = s.referencedComponentId
SET t.DESCRIPTIONTYPE = CASE WHEN linkedComponentId = @Preferred,CASE WHEN t.DEFAULTDESCTYPE = 3,3,1),CASE WHEN linkedComponentId = @Acceptable,CASE WHEN t.DEFAULTDESCTYPE = 3,3,2),0)) 
WHERE s.refSetId = @RefSet;

UPDATE rf21_term t INNER JOIN rf2_crefset s ON t.DESCRIPTIONID = s.referencedComponentId
SET t.DESCRIPTIONTYPE = 1 WHERE linkedComponentId = @Preferred AND t.DEFAULTDESCTYPE <> 3 AND s.refSetId = @RefSet AND t.DESCRIPTIONTYPE <> 1;


UPDATE rf21_concept c INNER JOIN rf21_term t ON c.CONCEPTID = t.CONCEPTID SET c.FULLYSPECIFIEDNAME = t.TERM WHERE t.DESCRIPTIONTYPE = 3 AND t.DESCRIPTIONSTATUS IN (0,6,8,11);

UPDATE rf21_def d INNER JOIN rf21_concept s ON d.CONCEPTID = s.CONCEPTID SET d.FULLYSPECIFIEDNAME = s.FULLYSPECIFIEDNAME, d.SNOMEDID = s.SNOMEDID;

SET @Res = (SELECT COUNT(referencedComponentId) FROM rf2_crefset WHERE refsetId = '900000000000488004');
UPDATE rf21_rel r INNER JOIN rf2_crefset s ON r.RELATIONSHIPID = s.referencedComponentId
SET r.REFINABILITY = magicNumberFor(linkedComponentId) WHERE s.refSetId ='900000000000488004'; /* Relationship refinability attribute value reference set (foundation metadata concept) */

SET @HistoricalAttribute = '10363501000001105'; /* HAD AMP */
SET @Refset = '999001311000000107';	/* Had actual medicinal product association reference set (foundation metadata concept) */
SET @HistoricalAttributeName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @HistoricalAttribute);
SET @HistoricalAttributeName = CASE WHEN @HistoricalAttributeName IS NULL,'* attribute not recognised *',@HistoricalAttributeName);
SET @RefsetName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @Refset);
SET @RefsetName = CASE WHEN @RefsetName IS NULL,'* refset not recognised *',@RefsetName);
INSERT INTO rf21_rel SELECT  '010101010', s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' FROM rf2_cRefSet s WHERE s.RefSetId = @Refset;

SET @HistoricalAttribute = '10363401000001106'; /* HAD VMP */
SET @Refset = '999001321000000101';	/* Had virtual medicinal product association reference set (foundation metadata concept) */
SET @HistoricalAttributeName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @HistoricalAttribute);
SET @HistoricalAttributeName = CASE WHEN @HistoricalAttributeName IS NULL,'* attribute not recognised *',@HistoricalAttributeName);
SET @RefsetName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @Refset);
SET @RefsetName = CASE WHEN @RefsetName IS NULL,'* refset not recognised *',@RefsetName);
INSERT INTO rf21_rel SELECT  '010101010', s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' FROM rf2_cRefSet s WHERE s.RefSetId = @Refset;

SET @HistoricalAttribute = '384598002'; /* MOVED FROM */
SET @Refset = '900000000000525002';	/* MOVED FROM association reference set (foundation metadata concept) */
SET @HistoricalAttributeName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @HistoricalAttribute);
SET @HistoricalAttributeName = CASE WHEN @HistoricalAttributeName IS NULL,'* attribute not recognised *',@HistoricalAttributeName);
SET @RefsetName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @Refset);
SET @RefsetName = CASE WHEN @RefsetName IS NULL,'* refset not recognised *',@RefsetName);
INSERT INTO rf21_rel SELECT '010101010', s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' FROM rf2_cRefSet s WHERE s.RefSetId = @Refset;

SET @HistoricalAttribute = '370125004';    /* MOVED TO */
SET @Refset = '900000000000524003';	/* MOVED TO association reference set (foundation metadata concept) */
SET @HistoricalAttributeName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @HistoricalAttribute);
SET @HistoricalAttributeName = CASE WHEN @HistoricalAttributeName IS NULL,'* attribute not recognised *',@HistoricalAttributeName);
SET @RefsetName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @Refset);
SET @RefsetName = CASE WHEN @RefsetName IS NULL,'* refset not recognised *',@RefsetName);
INSERT INTO rf21_rel SELECT '010101010', s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' FROM rf2_cRefSet s WHERE s.RefSetId = @Refset;

SET @HistoricalAttribute = '149016008'; /*  MAY BE A */
SET @Refset = '900000000000523009';	/* POSSIBLY EQUIVALENT TO association reference set (foundation metadata concept) */
SET @HistoricalAttributeName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @HistoricalAttribute);
SET @RefsetName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @Refset);
SET @RefsetName = CASE WHEN @RefsetName IS NULL,'* refset not recognised *',@RefsetName);
INSERT INTO rf21_rel SELECT '010101010', s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' FROM rf2_cRefSet s WHERE s.RefSetId = @Refset;

SET @HistoricalAttribute = '370124000'; /* REPLACED_BY */
SET @Refset = '900000000000526001';	/* 'REPLACED BY association reference set (foundation metadata concept)' */
SET @HistoricalAttributeName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @HistoricalAttribute);
SET @HistoricalAttributeName = CASE WHEN @HistoricalAttributeName IS NULL,'* attribute not recognised *',@HistoricalAttributeName);
SET @RefsetName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @Refset);
SET @RefsetName = CASE WHEN @RefsetName IS NULL,'* refset not recognised *',@RefsetName);
INSERT INTO rf21_rel SELECT '010101010', s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' FROM rf2_cRefSet s WHERE s.RefSetId = @Refset;

SET @HistoricalAttribute = '168666000'; /* SAME_AS */
SET @Refset = '900000000000527005';	/* 'SAME AS association reference set (foundation metadata concept)' */
SET @HistoricalAttributeName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @HistoricalAttribute);
SET @HistoricalAttributeName = CASE WHEN @HistoricalAttributeName IS NULL,'* attribute not recognised *',@HistoricalAttributeName);
SET @RefsetName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @Refset);
SET @RefsetName = CASE WHEN @RefsetName IS NULL,'* refset not recognised *',@RefsetName);
INSERT INTO rf21_rel SELECT '010101010', s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' FROM rf2_cRefSet s WHERE s.RefSetId = @Refset;

SET @HistoricalAttribute = '159083000'; /* WAS A */
SET @Refset = '900000000000528000';	/* WAS A association reference set (foundation metadata concept) */
SET @HistoricalAttributeName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @HistoricalAttribute);
SET @HistoricalAttributeName = CASE WHEN @HistoricalAttributeName IS NULL,'* attribute not recognised *',@HistoricalAttributeName);
SET @RefsetName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @Refset);
SET @RefsetName = CASE WHEN @RefsetName IS NULL,'* refset not recognised *',@RefsetName);
INSERT INTO rf21_rel SELECT '010101010', s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' FROM rf2_cRefSet s WHERE s.RefSetId = @Refset;


SET @InactiveParent = '363661006'; /* Reason not stated */
SET @InactiveParentName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @InactiveParent);
INSERT INTO rf21_rel SELECT  '101010101', c.CONCEPTID, '116680003', @InactiveParent, 0,0,0,c.SOURCE FROM rf21_concept c WHERE c.CONCEPTSTATUS = 1;

SET @InactiveParent = '363662004'; /* Duplicate */
SET @InactiveParentName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @InactiveParent);
INSERT INTO rf21_rel SELECT  '101010101', c.CONCEPTID, '116680003', @InactiveParent, 0,0,0,c.SOURCE FROM rf21_concept c WHERE c.CONCEPTSTATUS = 2;

SET @InactiveParent = '363663009'; /* Outdated */
SET @InactiveParentName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @InactiveParent);
INSERT INTO rf21_rel SELECT  '101010101', c.CONCEPTID, '116680003', @InactiveParent, 0,0,0,c.SOURCE FROM rf21_concept c WHERE c.CONCEPTSTATUS = 3;

SET @InactiveParent = '363660007'; /*Ambiguous concept */
SET @InactiveParentName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @InactiveParent);
INSERT INTO rf21_rel SELECT  '101010101', c.CONCEPTID, '116680003', @InactiveParent, 0,0,0,c.SOURCE FROM rf21_concept c WHERE c.CONCEPTSTATUS = 4;

SET @InactiveParent = '443559000'; /* Limited */
SET @InactiveParentName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @InactiveParent);
INSERT INTO rf21_rel SELECT  '101010101', c.CONCEPTID, '116680003', @InactiveParent, 0,0,0,c.SOURCE FROM rf21_concept c WHERE c.CONCEPTSTATUS = 6;

SET @InactiveParent = '363664003'; /* Erroneous */
SET @InactiveParentName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @InactiveParent);
INSERT INTO rf21_rel SELECT  '101010101', c.CONCEPTID, '116680003', @InactiveParent, 0,0,0,c.SOURCE FROM rf21_concept c WHERE c.CONCEPTSTATUS = 5;

SET @InactiveParent = '370126003'; /* Moved elsewhere */
SET @InactiveParentName = (SELECT LEFT(FULLYSPECIFIEDNAME, INSTR(FULLYSPECIFIEDNAME,' (')) FROM RF21_CONCEPT WHERE CONCEPTID = @InactiveParent);
INSERT INTO rf21_rel SELECT  '101010101', c.CONCEPTID, '116680003', @InactiveParent, 0,0,0,c.SOURCE FROM rf21_concept c WHERE c.CONCEPTSTATUS = 10;

/*
Simple Type Refset (VTM & VMP) are currently empty
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
*/


INSERT INTO rf21_subsetlist SELECT DISTINCT 
	m.OriginalSubsetID AS SubsetID, 
	m.OriginalSubsetID AS OriginalSubsetID, 
	1 AS SUBSETVERSION, 
	m.SubsetName AS SUBSETNAME, 
	CASE WHEN LEFT(RIGHT(s.refsetId,3),1) = 1,3,1) AS SUBSETTYPE, 
	'en_GB' AS LANGUAGECODE, 
	'0080' AS SubsetRealmID, 
	0 AS CONTEXTID
FROM rf2_crefset s 
	INNER JOIN rf2_subset2refset m ON s.refsetId = m.refsetId
	INNER JOIN rf21_rel r ON s.refsetId = r.CONCEPTID1 AND r.RELATIONSHIPTYPE = '116680003' AND r.CONCEPTID2 = '900000000000507009'; #English [International Organization for Standardization 639-1 code en] language reference set  
	-- This matches both types of English Lang refset ie US and GB

INSERT INTO rf21_subsets SELECT m.OriginalSubsetId AS SubsetId, referencedComponentId AS MemberID, CASE WHEN linkedComponentId = '900000000000549004',2,1) AS MemberStatus, 0 AS LinkedID 
FROM rf2_crefset s 
	INNER JOIN rf2_subset2refset m ON s.refsetId = m.refsetId
	INNER JOIN rf21_rel r ON s.refsetId = r.CONCEPTID1 AND r.RELATIONSHIPTYPE = '116680003' AND r.CONCEPTID2 = '900000000000507009'; #English [International Organization for Standardization 639-1 code en] language reference set  



