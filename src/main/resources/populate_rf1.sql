

INSERT INTO rf21_concept
SELECT DISTINCT
  id AS CONCEPTID,
  statusFor(active) AS CONCEPTSTATUS,
  '' AS FULLYSPECIFIEDNAME,
  'Xxxxx' AS CTV3ID,
  'Xxxxx' AS SNOMEDID,
  magicNumberFor(definitionStatusId) AS ISPRIMITIVE,
  moduleSourceFor(moduleId) AS SOURCE
FROM rf2_concept c
WHERE NOT EXISTS (
	-- Don't include any metadata concepts
	SELECT 1 FROM rf2_term t
	WHERE c.id = t.conceptid
	AND t.typeid = 900000000000003001 --fsn
	AND t.term like '%metadata concept)'
);

SET @FullySpecifiedName = '900000000000003001';
SET @Definition = '900000000000550004';
SET @EntireTermCaseSensitive = '900000000000017005';

SELECT typeid, count(*)
from rf2_term
group by typeid; 

INSERT INTO rf21_term
SELECT
  id AS DESCRIPTIONID,
  statusFor(active) AS DESCRIPTIONSTATUS,
  t.conceptId AS CONCEPTID,
  term AS TERM,
  capitalStatusFor(caseSignificanceId) AS INITIALCAPITALSTATUS,
  descTypeFor(typeID) AS US_DESC_TYPE, -- assigns all FSNs (3) but labels all other terms as 'synonyms'
  descTypeFor(typeID) AS GB_DESC_TYPE, -- assigns all FSNs (3) but labels all other terms as 'synonyms'
  t.languageCode AS LANGUAGECODE,
  t.moduleSourceFor(moduleId) AS SOURCE
FROM rf2_term t, rf21_concept c
WHERE t.conceptid = c.conceptid;


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

SELECT count(*) as rowCount from rf2_srefset s;

SELECT * from rf2_srefset s where s.linkedString is null;

SELECT c.* from rf21_concept c LEFT JOIN rf2_srefset s
ON c.conceptid = s.referencedComponentId
AND s.refSetId = '900000000000497000'
WHERE s.referencedComponentId is null;

-- Currently missing legacy values for GMDN Reference Set Concept.  Merge in if required.
MERGE INTO rf2_srefset (id, effectiveTime, active, moduleId, refSetId, referencedComponentId, linkedString)
KEY (referencedComponentId, refsetId)
Values ('DUMMY', '00000000', 1, 900000000000207008, 900000000000497000, 467614008, 'XUozI' );

MERGE INTO rf2_srefset (id, effectiveTime, active, moduleId, refSetId, referencedComponentId, linkedString)
KEY (referencedComponentId, refsetId)
Values ('DUMMY', '00000000', 1, 900000000000207008, 900000000000498005, 467614008, 'R-FD64C' );
	
 -- CTV3
UPDATE rf21_concept c
SET c.CTV3ID = (
select s.linkedString from rf2_srefset s
where c.conceptid = s.referencedComponentId
and s.refSetId = '900000000000497000' );

-- SNOMED RT ID
UPDATE rf21_concept c
SET c.SNOMEDID = (select s.linkedString from rf2_srefset s
where c.conceptid = s.referencedComponentId
and s.refSetId ='900000000000498005'
);

SELECT DESCRIPTIONSTATUS, count(*) from rf21_term group by DESCRIPTIONSTATUS;

--Where term is has inactivation reason, set the description status
UPDATE rf21_term t
SET t.DESCRIPTIONSTATUS = COALESCE (
	(select magicNumberFor(s.linkedComponentId)
	from rf2_crefset s
	where s.referencedComponentId = t.descriptionid
	and s.refSetId ='900000000000490003' 
	AND s.active = 1),t.descriptionstatus); 

SELECT DESCRIPTIONSTATUS, count(*) from rf21_term group by DESCRIPTIONSTATUS;

UPDATE rf21_concept c
SET c.FULLYSPECIFIEDNAME = ( 
	select t.term from rf21_term t
	where t.conceptid = c.conceptid
	and t.US_DESC_TYPE = 3 
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

SELECT t.LANGUAGECODE, count(*)
from rf21_term t
group by t.LANGUAGECODE;

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
	and us.linkedComponentId = @Preferred )
AND NOT t.US_DESC_TYPE = 3;

UPDATE rf21_term t
SET t.GB_DESC_TYPE = 1
WHERE EXISTS (
	select 1 from rf2_crefset gb
	where gb.refsetID = @GBRefSet
	and t.DESCRIPTIONID = gb.referencedComponentId
	and gb.linkedComponentId = @Preferred )
AND NOT t.GB_DESC_TYPE = 3;

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
	CASE WHEN m.refsetId = 900000000000508004 THEN 'en-GB' ELSE 'en-US' END AS LANGUAGECODE, 
	'0080' AS SubsetRealmID, 
	0 AS CONTEXTID
FROM rf2_crefset s 
	INNER JOIN rf2_subset2refset m 
		ON s.refsetId = m.refsetId
	INNER JOIN rf21_rel r 
		ON s.refsetId = r.CONCEPTID1 
		AND r.RELATIONSHIPTYPE = '116680003' 
		-- English [International Organization for Standardization 639-1 code en] language reference set  
		-- This matches both types of English Lang refset ie US and GB
		AND r.CONCEPTID2 = '900000000000507009'; 

SELECT * from rf21_subsetlist;

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

-- RF2 to RF1 Conversion will not supply relationship ids
UPDATE rf21_rel
SET RELATIONSHIPID = null;