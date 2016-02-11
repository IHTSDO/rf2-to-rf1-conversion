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

CREATE UNIQUE INDEX CONCEPT_CUI_X ON rf21_concept(CONCEPTID);

SET @FullySpecifiedName = '900000000000003001';
SET @Definition = '900000000000550004';
SET @EntireTermCaseSensitive = '900000000000017005';
SET @Stated = '900000000000010007';
SET @USRefSet = '900000000000509007'; /* United States of America English language reference set  */
SET @GBRefSet = '900000000000508004'; /* Great Britain English language reference set (foundation metadata concept) */
SET @Acceptable = '900000000000549004';
SET @Preferred = '900000000000548007';
SET @ISA = '116680003';

-- PARALLEL_START;

INSERT INTO rf21_term
SELECT
  id AS DESCRIPTIONID,
  statusFor(active) AS DESCRIPTIONSTATUS,
  t.conceptId AS CONCEPTID,
  term AS TERM,
  capitalStatusFor(caseSignificanceId) AS INITIALCAPITALSTATUS,
  descTypeFor(typeId) AS US_DESC_TYPE, -- assigns all FSNs (3) but labels all other terms as 'synonyms'
  descTypeFor(typeId) AS GB_DESC_TYPE, -- assigns all FSNs (3) but labels all other terms as 'synonyms'
  descTypeFor(typeId) AS DESC_TYPE,
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

INSERT INTO rf21_rel
SELECT
  null AS RELATIONSHIPID,
  r.sourceId AS CONCEPTID1,
  r.typeId AS RELATIONSHIPTYPE,
  r.destinationId AS CONCEPTD2,
  r.characteristicFor(characteristicTypeId) AS CHARACTERISTICTYPE,
  9 AS REFINABILITY, -- default 9 to signify refinability not known
  r.relationshipGroup AS RELATIONSHIPGROUP,
  r.moduleSourceFor(moduleId) AS SOURCE
FROM rf2_rel r, rf21_concept c1, rf21_concept c2  /*Only relationships for concepts that exist in RF1*/
WHERE characteristicTypeId <> @Stated /* Ignore stated relationships */
AND r.sourceId = c1.conceptid
AND r.destinationId = c2.conceptid;

INSERT INTO rf21_stated_rel
SELECT
  null AS RELATIONSHIPID,
  r.sourceId AS CONCEPTID1,
  r.typeId AS RELATIONSHIPTYPE,
  r.destinationId AS CONCEPTD2,
  0 AS CHARACTERISTICTYPE,  --All stated relationships are defining
  0 AS REFINABILITY,
  r.relationshipGroup AS RELATIONSHIPGROUP,
  r.moduleSourceFor(moduleId) AS SOURCE
FROM rf2_rel r, rf21_concept c1, rf21_concept c2  /*Only relationships for concepts that exist in RF1*/
WHERE characteristicTypeId = @Stated /* Only stated relationships */
AND r.sourceId = c1.conceptid
AND r.destinationId = c2.conceptid;

-- PARALLEL_END;
-- PARALLEL_START;

-- The Snomed CT Model Component 900000000000441003 doesn't exist in RF1 so we're 
-- going to remove it and point its children to other parents.
SET @SCT_MODEL = '900000000000441003';
SET @SCT_ROOT  = '138875005';
SET @SCT_SPECIAL = '370115009';
SET @SCT_LINKAGE = '106237007';
SET @SCT_NAMESPACE = '370136006';
SET @SCT_IS_A = @ISA;

DELETE from rf21_concept where conceptid = @SCT_MODEL;
DELETE from rf21_term where conceptid = @SCT_MODEL;
DELETE from rf21_rel where conceptid1 = @SCT_MODEL;
DELETE from rf21_stated_rel where conceptid1 = @SCT_MODEL;

UPDATE rf21_rel SET conceptid2 = @SCT_ROOT
WHERE conceptid1 =  @SCT_LINKAGE
AND relationshiptype = @SCT_IS_A;

UPDATE rf21_rel SET conceptid2 = @SCT_SPECIAL
WHERE conceptid1 =  @SCT_NAMESPACE
AND relationshiptype = @SCT_IS_A;

UPDATE rf21_stated_rel SET conceptid2 = @SCT_ROOT
WHERE conceptid1 =  @SCT_LINKAGE
AND relationshiptype = @SCT_IS_A;

UPDATE rf21_stated_rel SET conceptid2 = @SCT_SPECIAL
WHERE conceptid1 =  @SCT_NAMESPACE
AND relationshiptype = @SCT_IS_A;

CREATE INDEX TERM_CUI_X ON rf21_term(CONCEPTID);
CREATE UNIQUE INDEX TERM_TUI_X ON rf21_term(DESCRIPTIONID);
CREATE INDEX IDX_REL_CUI1_X ON rf21_rel(CONCEPTID1);
CREATE INDEX IDX_REL_RELATION_X ON rf21_rel(RELATIONSHIPTYPE);
CREATE INDEX IDX_REL_CUI2_X ON rf21_rel(CONCEPTID2);
CREATE INDEX IDX_SREL_CUI1_X ON rf21_stated_rel(CONCEPTID1);
CREATE INDEX IDX_SREL_RELATION_X ON rf21_stated_rel(RELATIONSHIPTYPE);
CREATE INDEX IDX_SREL_CUI2_X ON rf21_stated_rel(CONCEPTID2);

-- Currently missing legacy values for GMDN Reference Set Concept.  Merge in if required.
MERGE INTO rf2_srefset (id, effectiveTime, active, moduleId, refSetId, referencedComponentId, linkedString)
KEY (referencedComponentId, refsetId)
Values ('DUMMY', '00000000', 1, 900000000000207008, 900000000000497000, 467614008, 'XUozI' );

MERGE INTO rf2_srefset (id, effectiveTime, active, moduleId, refSetId, referencedComponentId, linkedString)
KEY (referencedComponentId, refsetId)
Values ('DUMMY', '00000000', 1, 900000000000207008, 900000000000498005, 467614008, 'R-FD64C' );

-- PARALLEL_END;
-- PARALLEL_START;

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

--Where term is has inactivation reason, set the description status
UPDATE rf21_term t
SET t.DESCRIPTIONSTATUS = COALESCE (
	(select magicNumberFor(s.linkedComponentId)
	from rf2_crefset s
	where s.referencedComponentId = t.descriptionid
	and s.refSetId ='900000000000490003' 
	AND s.active = 1),t.descriptionstatus);
-- PARALLEL_END;
-- PARALLEL_START;	

-- Where the concept has limited status (6), the description should too
UPDATE rf21_term t
SET t.DESCRIPTIONSTATUS = 6
WHERE EXISTS (
	SELECT 1 FROM rf21_concept c
	WHERE t.conceptid = c.conceptid
	AND c.conceptstatus = 6 )
AND t.DESCRIPTIONSTATUS = 8;

UPDATE rf21_concept c
SET c.FULLYSPECIFIEDNAME = ( 
	select t.term from rf21_term t
	where t.conceptid = c.conceptid
	and t.US_DESC_TYPE = 3 
	and t.DESCRIPTIONSTATUS IN (0,6,8,11));

UPDATE rf21_term SET LANGUAGECODE = 'en';
-- PARALLEL_END;
-- PARALLEL_START;
-- Set language code as en-GB when no en-US row exists and visa versa
UPDATE rf21_term t
SET t.LANGUAGECODE = 'en-GB'
WHERE EXISTS (
	-- note that the language refset entry could be inactive if the description also is
	select 1 from rf2_crefset gb LEFT JOIN rf2_crefset us
		ON gb.referencedComponentId = us.referencedComponentId
		and us.refSetId = @USRefSet
	where gb.refSetId = @GBRefSet
	and gb.referencedComponentId = t.descriptionId
	AND (us.referencedComponentId is null OR (us.active = 0 AND gb.active = 1))
);

UPDATE rf21_term t
SET t.LANGUAGECODE = 'en-US'
WHERE EXISTS (
	-- note that the language refset entry could be inactive if the description also is
	select 1 from rf2_crefset us LEFT JOIN rf2_crefset gb
		ON us.referencedComponentId = gb.referencedComponentId
		and gb.refSetId = @GBRefSet
	where us.refSetId = @USRefSet
	and us.referencedComponentId = t.descriptionId
	AND ( gb.referencedComponentId is null OR (gb.active = 0 AND us.active = 1))
	-- Seems to be an oddity in Termmed's conversion that they'd set en-GB but not an en-US
	-- when the description is inactive
) AND NOT t.DESCRIPTIONSTATUS = 1;

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

-- Where the description is acceptable in one dialect and preferred in the other, set the 
-- common description type to 0 - unspecified
UPDATE rf21_term t
SET t.DESC_TYPE = 0
WHERE EXISTS (
	select 1 from rf2_crefset gb, rf2_crefset us
	where gb.refsetID = @GBRefSet
	and us.refsetID = @USRefSet
	and t.DESCRIPTIONID = gb.referencedComponentId
	and t.DESCRIPTIONID = us.referencedComponentId
	and gb.linkedComponentId != us.linkedComponentId )
AND NOT t.US_DESC_TYPE = 3;

-- Set the common type to 1 (Preferred) when it is preferred in both dialects
UPDATE rf21_term t
SET t.DESC_TYPE = 1
WHERE t.US_DESC_TYPE = 1
AND t.GB_DESC_TYPE = 1;

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

-- PARALLEL_END;

SET @HistoricalAttribute = '10363501000001105'; /* HAD AMP */
SET @Refset = '999001311000000107';	/* Had actual medicinal product association reference set (foundation metadata concept) */
INSERT INTO rf21_rel SELECT  null, s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' FROM rf2_cRefSet s WHERE s.RefSetId = @Refset;

SET @HistoricalAttribute = '10363401000001106'; /* HAD VMP */
SET @Refset = '999001321000000101';	/* Had virtual medicinal product association reference set (foundation metadata concept) */
INSERT INTO rf21_rel SELECT  null, s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' FROM rf2_cRefSet s WHERE s.RefSetId = @Refset;

-- sct1_References appears to only be populated with types 1,4 & 7
-- Replaced By, Alternative, Refers To

SET @HistoricalAttribute = '384598002'; /* MOVED FROM */
SET @Refset = '900000000000525002';	/* MOVED FROM association reference set (foundation metadata concept) */
SET @RefType = 6;
INSERT INTO rf21_rel SELECT null, s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' 
FROM rf2_cRefSet s 
WHERE s.RefSetId = @Refset
AND s.active = 1;

INSERT INTO rf21_reference SELECT s.referencedComponentId, @RefType, linkedComponentID 
FROM rf2_cRefSet s 
WHERE s.RefSetId = @Refset
AND s.active = 1;

SET @HistoricalAttribute = '370125004';    /* MOVED TO */
SET @Refset = '900000000000524003';	/* MOVED TO association reference set (foundation metadata concept) */
-- SET @RefType = 5; 
INSERT INTO rf21_rel SELECT null, s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' 
FROM rf2_cRefSet s 
WHERE s.RefSetId = @Refset
and s.active = 1;

SET @HistoricalAttribute = '149016008'; /*  MAY BE A */
SET @Refset = '900000000000523009';	/* POSSIBLY EQUIVALENT TO association reference set (foundation metadata concept) */
INSERT INTO rf21_rel SELECT null, s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' 
FROM rf2_cRefSet s 
WHERE s.RefSetId = @Refset
AND s.active = 1;


SET @HistoricalAttribute = '370124000'; /* REPLACED_BY */
SET @Refset = '900000000000526001'; /* 'REPLACED BY association reference set (foundation metadata concept)' */
SET @RefType = 1; 
-- But not when a "MOVED TO" row also exists for this component (null on the left join)
INSERT INTO rf21_rel SELECT null, rep.referencedComponentId, @HistoricalAttribute, rep.linkedComponentID, 2,0,0,'RF2' 
FROM rf2_cRefSet rep LEFT JOIN rf2_cRefSet mvd 
	ON rep.referencedComponentId = mvd.referencedComponentId 
	AND mvd.RefsetId =  '900000000000524003' -- MOVED TO
	AND mvd.active = 1
WHERE rep.RefSetId = @Refset
AND rep.active = 1
AND mvd.linkedComponentID is null;

-- Apparently we only have references for "Replaced By" when the 'slot' in the IS A hierarchy
-- has been taken by a 'MOVED TO' relationship, so basicaly the complement of the previous 
-- statement
INSERT INTO rf21_reference SELECT s.referencedComponentId, @RefType, s.linkedComponentID 
FROM rf2_cRefSet s, rf2_cRefSet mvd 
WHERE s.RefSetId = @Refset
AND s.referencedComponentId = mvd.referencedComponentId 
AND mvd.RefsetId =  '900000000000524003' -- MOVED TO
AND mvd.active = 1
AND s.active = 1;

SET @HistoricalAttribute = '168666000'; /* SAME_AS */
SET @Refset = '900000000000527005'; /* 'SAME AS association reference set (foundation metadata concept)' */
INSERT INTO rf21_rel SELECT null, s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' 
FROM rf2_cRefSet s 
WHERE s.RefSetId = @Refset
AND s.active = 1;


SET @HistoricalAttribute = '159083000'; /* WAS A */
SET @Refset = '900000000000528000'; /* WAS A association reference set (foundation metadata concept) */
INSERT INTO rf21_rel SELECT null, s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' 
FROM rf2_cRefSet s 
WHERE s.RefSetId = @Refset
AND s.active = 1;

SET @Refset = '900000000000531004'; /* REFERS TO CONCEPT association reference set (foundation metadata concept) */
SET @RefType = 7; /*Refers To*/
INSERT INTO rf21_reference 
SELECT s.referencedComponentId, @RefType, linkedComponentID 
FROM rf2_cRefSet s 
WHERE s.RefSetId = @Refset
AND s.active = 1;

SET @Refset = '900000000000530003'; /* | ALTERNATIVE association reference set (foundation metadata concept) */
SET @RefType = 4; /*Alternative*/
INSERT INTO rf21_reference 
SELECT s.referencedComponentId, @RefType, linkedComponentID 
FROM rf2_cRefSet s 
WHERE s.RefSetId = @Refset
AND s.active = 1;

-- Now we may have picked up some historical associations (which become is-a in RF1) for concepts that we don't use in RF1
-- so filter those back out again
DELETE from rf21_rel
WHERE conceptid1 IN (
	SELECT r.conceptid1 FROM rf21_rel r LEFT JOIN rf21_concept c
	ON r.conceptid1 = c.conceptid
	WHERE c.conceptid is null );

SET @InactiveParent = '363661006'; /* Reason not stated */
INSERT INTO rf21_rel SELECT  null, c.CONCEPTID, @ISA, @InactiveParent, 0,0,0,c.SOURCE FROM rf21_concept c WHERE c.CONCEPTSTATUS = 1;

SET @InactiveParent = '363662004'; /* Duplicate */
INSERT INTO rf21_rel SELECT  null, c.CONCEPTID, @ISA, @InactiveParent, 0,0,0,c.SOURCE FROM rf21_concept c WHERE c.CONCEPTSTATUS = 2;

SET @InactiveParent = '363663009'; /* Outdated */
INSERT INTO rf21_rel SELECT  null, c.CONCEPTID, @ISA, @InactiveParent, 0,0,0,c.SOURCE FROM rf21_concept c WHERE c.CONCEPTSTATUS = 3;

SET @InactiveParent = '363660007'; /*Ambiguous concept */
INSERT INTO rf21_rel SELECT  null, c.CONCEPTID, @ISA, @InactiveParent, 0,0,0,c.SOURCE FROM rf21_concept c WHERE c.CONCEPTSTATUS = 4;

SET @InactiveParent = '443559000'; /* Limited */
INSERT INTO rf21_rel SELECT  null, c.CONCEPTID, @ISA, @InactiveParent, 0,0,0,c.SOURCE FROM rf21_concept c WHERE c.CONCEPTSTATUS = 6;

SET @InactiveParent = '363664003'; /* Erroneous */
INSERT INTO rf21_rel SELECT  null, c.CONCEPTID, @ISA, @InactiveParent, 0,0,0,c.SOURCE FROM rf21_concept c WHERE c.CONCEPTSTATUS = 5;

SET @InactiveParent = '370126003'; /* Moved elsewhere */
INSERT INTO rf21_rel SELECT  null, c.CONCEPTID, @ISA, @InactiveParent, 0,0,0,c.SOURCE FROM rf21_concept c WHERE c.CONCEPTSTATUS = 10;

-- Copy all these Inactive Parents into the Stated Relationship table
-- Except that the existing conversion processes sees these as 'defining', so set
-- characteristic type to 0
INSERT INTO rf21_stated_rel
SELECT RELATIONSHIPID, CONCEPTID1, RELATIONSHIPTYPE, CONCEPTID2, 0/*CHARACTERISTICTYPE*/, 0 /*REFINABILITY*/, RELATIONSHIPGROUP, SOURCE 
FROM rf21_rel
WHERE relationshiptype = @ISA
AND conceptid2 in (363661006/* Reason not stated */, 363662004/* Duplicate */, 363663009/* Outdated */, 363660007/*Ambiguous concept */, 443559000/* Limited */, 363664003/* Erroneous */, 370126003/* Moved elsewhere */);

		
INSERT INTO rf21_subsetlist SELECT DISTINCT 
	@RDATE || CASE WHEN m.refsetId = 900000000000508004 THEN '2' ELSE '1' END AS SubsetID, 
	m.OriginalSubsetID AS OriginalSubsetID, 
	SUBSTR(@RDATE,0,6)  AS SUBSETVERSION, 
	m.SubsetName AS SUBSETNAME, 
	CASE WHEN LEFT(RIGHT(s.refsetId,3),1) = 1 THEN 3 ELSE 1 END AS SUBSETTYPE, 
	CASE WHEN m.refsetId = 900000000000508004 THEN 'en-GB' ELSE 'en-US' END AS LANGUAGECODE, 
	'0' AS RealmId, 
	0 AS CONTEXTID
FROM rf2_crefset s 
	INNER JOIN rf2_subset2refset m 
		ON s.refsetId = m.refsetId
WHERE s.refsetid in (@USRefSet, @GBRefSet);

INSERT INTO rf21_subsets 
	SELECT m.refsetId AS SubsetId, 
	referencedComponentId AS MemberID, 
	CASE WHEN s.refsetid =  @USRefSet THEN t.US_DESC_TYPE ELSE t.GB_DESC_TYPE END AS MemberStatus, 
	null AS LinkedID ,
	m.OriginalSubsetId AS SubsetOriginalId
	FROM rf21_term t, rf2_crefset s  
	INNER JOIN rf2_subset2refset m 
		ON s.refsetId = m.refsetId
	WHERE s.refsetid in (@USRefSet, @GBRefSet)
	AND s.referencedComponentId = t.descriptionid
	and t.descriptionstatus = 0
	AND s.active = 1;
	