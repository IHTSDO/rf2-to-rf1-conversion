SET @MetadataModule = '900000000000012004';
SET @FSN = '900000000000003001';
SET @SYN = '900000000000013009';
SET @ISA = '116680003';
SET @Definition = '900000000000550004';
SET @EntireTermCaseSensitive = '900000000000017005';
SET @Stated = '900000000000010007';
SET @USRefSet = '900000000000509007'; /* United States of America English language reference set  */
SET @GBRefSet = '900000000000508004'; /* Great Britain English language reference set (foundation metadata concept) */
SET @Acceptable = '900000000000549004';
SET @Preferred = '900000000000548007';
SET @CInactivationRefSet = '900000000000489007';
SET @DInactivationRefSet = '900000000000490003';
SET @IntLangCode = 'en';

--TODO Find another way to identify metadata concepts, or pull in search 
--phrase as part of extension configuration
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
	-- Don't include any metadata concepts that are still in the metadata hierarchy
	SELECT 1 FROM rf2_term t
	WHERE c.id = t.conceptid
	AND t.typeid = @FSN
	AND moduleId =  @MetadataModule
	AND ( t.term like '%metadata concept)' OR t.term like '%metadato fundacional)'
	OR t.term like '%metadato del núcleo)' )
);

CREATE UNIQUE INDEX CONCEPT_CUI_X ON rf21_concept(CONCEPTID);

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
WHERE t.conceptid = c.conceptid
AND t.languageCode = @LangCode;

INSERT INTO rf21_def
SELECT
  conceptId AS CONCEPTID,
  '' AS SNOMEDID,
  '' AS FULLYSPECIFIEDNAME,
  term AS TERM
FROM rf2_def WHERE active = 1;

INSERT INTO rf21_rel
SELECT
  CASE WHEN @useRelationshipIds = true THEN r.id ELSE null END AS RELATIONSHIPID,
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

CREATE INDEX idx_21t_cid ON rf21_term(CONCEPTID);
CREATE INDEX idx_21t_did ON rf21_term(descriptionId);
CREATE INDEX idx_21t_ds ON rf21_term(descriptionStatus);

CREATE INDEX IDX_REL_CUI1_X ON rf21_rel(CONCEPTID1);
CREATE INDEX IDX_REL_RELATION_X ON rf21_rel(RELATIONSHIPTYPE);
CREATE INDEX IDX_REL_CUI2_X ON rf21_rel(CONCEPTID2);
CREATE INDEX IDX_SREL_CUI1_X ON rf21_stated_rel(CONCEPTID1);
CREATE INDEX IDX_SREL_RELATION_X ON rf21_stated_rel(RELATIONSHIPTYPE);
CREATE INDEX IDX_SREL_CUI2_X ON rf21_stated_rel(CONCEPTID2);


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

-- Currently missing legacy values for GMDN Reference Set Concept.  Merge in if required.
MERGE INTO rf2_srefset (id, effectiveTime, active, moduleId, refSetId, referencedComponentId, linkedString)
KEY (referencedComponentId, refsetId)
Values ('DUMMY', '00000000', 1, 900000000000207008, 900000000000497000, 467614008, 'XUozI' );

MERGE INTO rf2_srefset (id, effectiveTime, active, moduleId, refSetId, referencedComponentId, linkedString)
KEY (referencedComponentId, refsetId)
Values ('DUMMY', '00000000', 1, 900000000000207008, 900000000000498005, 467614008, 'R-FD64C' );


/* Concepts in the FULL tables but NOT in the snapshot must be EITHER some flavour of inactive OR pending move 
   Determine the reason for inactivation, or pending move status, from the appropriate refset
   Any concept that is NEITHER current NOR pending move NOR has a reason for retirement explicitly represented in the RefSet, must implicitly be correctly the default 'retired no reason' */

UPDATE rf21_concept c 
SET c.conceptstatus = ( 
	select magicNumberFor(s1.linkedComponentId) 
	from rf2_crefset s1
	where s1.refSetId = @CInactivationRefSet
	and s1.active = 1
	and s1.referencedComponentId = c.CONCEPTID),
c.SOURCE = ( 
	select moduleSourceFor(s2.moduleId)
	from rf2_crefset s2
	where s2.refSetId = @CInactivationRefSet
	and s2.active = 1
	and s2.referencedComponentId = c.CONCEPTID)
where c.CONCEPTID in (
	select s3.referencedComponentId
	from rf2_crefset s3
	where s3.refSetId = @CInactivationRefSet
	and s3.active = 1
	and s3.referencedComponentId = c.CONCEPTID);
	
 -- CTV3
UPDATE rf21_concept c
SET c.CTV3ID = COALESCE(
select s.linkedString from rf2_srefset s
where c.conceptid = s.referencedComponentId
and s.refSetId = '900000000000497000' , 'UNKNOWN');

-- SNOMED RT ID
UPDATE rf21_concept c
SET c.SNOMEDID = COALESCE(select s.linkedString from rf2_srefset s
where c.conceptid = s.referencedComponentId
and s.refSetId ='900000000000498005', 'UNKNOWN');

UPDATE rf21_rel r
SET r.REFINABILITY = refinabilityFor(r.characteristicType);

--Pull the FSN directly from the RF2
UPDATE rf21_concept c
SET c.FULLYSPECIFIEDNAME = ( 
	select t.term from rf2_term t
	where t.conceptid = c.conceptid
	and t.typeId = @FSN 
	and t.active = 1
	and t.languageCode = @IntLangCode);
	
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
	


	