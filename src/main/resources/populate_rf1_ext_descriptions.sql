-- Expecting the following variables to be set by the calling program
-- SET @langCode = 'es';
-- SET @langRefSet = '448879004';
-- SET @langRefSet = '450828004';

SET @USRefSet = '900000000000509007'; 
SET @Preferred = '900000000000548007';
SET @DInactivationRefSet = '900000000000490003';
SET @intLangCode = 'en';

-- Also pull in terms from the International Edition which are referenced in the language refset
INSERT INTO rf21_term
SELECT
  t.id AS DESCRIPTIONID,
  statusFor(t.active) AS DESCRIPTIONSTATUS,
  t.conceptId AS CONCEPTID,
  t.term AS TERM,
  capitalStatusFor(t.caseSignificanceId) AS INITIALCAPITALSTATUS,
  0 AS US_DESC_TYPE, 
  0 AS GB_DESC_TYPE,
  descTypeFor(t.typeId) AS DESC_TYPE, -- assigns all FSNs (3) but labels all other terms as 'synonyms'
  t.languageCode AS LANGUAGECODE,
  t.moduleSourceFor(t.moduleId) AS SOURCE
FROM rf2_term t, rf21_concept c, rf2_crefset lang
WHERE t.conceptid = c.conceptid
AND lang.refsetID = @langRefSet
AND t.id = lang.referencedComponentId
AND t.languageCode = @intLangCode;

-- Also pull in terms where we have a concept but there's no FSN for it in the extension
INSERT INTO rf21_term
SELECT
  t.id AS DESCRIPTIONID,
  statusFor(t.active) AS DESCRIPTIONSTATUS,
  t.conceptId AS CONCEPTID,
  t.term AS TERM,
  capitalStatusFor(t.caseSignificanceId) AS INITIALCAPITALSTATUS,
  0 AS US_DESC_TYPE, 
  0 AS GB_DESC_TYPE,
  descTypeFor(t.typeId) AS DESC_TYPE, -- assigns all FSNs (3) but labels all other terms as 'synonyms'
  t.languageCode AS LANGUAGECODE,
  t.moduleSourceFor(t.moduleId) AS SOURCE
FROM rf2_term t, rf21_concept c LEFT JOIN rf21_term t2 ON c.conceptId = t2.conceptId
WHERE t.conceptId = c.conceptid
AND t.languageCode = @intLangCode
AND t.active = 1
AND t.typeId = @FSN
AND t2.descriptionId IS NULL;

-- Description types were set to synonym by default, then FSN were picked up, so now just detect preferred for each language
UPDATE rf21_term t
SET t.DESC_TYPE = 1
WHERE EXISTS (
	select 1 from rf2_crefset lang
	where lang.refsetID = @langRefSet
	and t.DESCRIPTIONID = lang.referencedComponentId
	and lang.linkedComponentId = @Preferred )
AND NOT t.DESC_TYPE = 3;

-- Also pull in terms where we have a concept but there's no Preferred Term for it in the extension
INSERT INTO rf21_term
SELECT
  t.id AS DESCRIPTIONID,
  statusFor(t.active) AS DESCRIPTIONSTATUS,
  t.conceptId AS CONCEPTID,
  t.term AS TERM,
  capitalStatusFor(t.caseSignificanceId) AS INITIALCAPITALSTATUS,
  0 AS US_DESC_TYPE, 
  0 AS GB_DESC_TYPE,
  descTypeFor(t.typeId) AS DESC_TYPE, -- assigns all FSNs (3) but labels all other terms as 'synonyms'
  t.languageCode AS LANGUAGECODE,
  t.moduleSourceFor(t.moduleId) AS SOURCE
FROM rf2_term t,  rf2_crefset l, rf21_concept c 
	LEFT JOIN rf21_term t2 
	ON c.conceptId = t2.conceptId 
	AND t2.desc_type = 1
WHERE t.conceptId = c.conceptid
AND l.referencedComponentId = t.id
AND l.refsetid = @USRefSet
AND l.linkedComponentId = @Preferred
AND t.active = 1
AND l.active = 1
AND t.typeId = @SYN
AND t2.descriptionId IS NULL;

-- Run this one again to pick up terms added from international edition
-- Description types were set to synonym by default, then FSN were picked up, so now just detect preferred
-- but only use the International Preferred where there is no row in the Extension LangRefSet
UPDATE rf21_term t
SET t.DESC_TYPE = 1
WHERE EXISTS (
	SELECT 1 from rf2_crefset intLang LEFT JOIN rf2_crefset extLang
		ON intLang.referencedComponentId = extLang.referencedComponentId
		AND extLang.refsetID = @langRefSet
	WHERE t.DESCRIPTIONID = intLang.referencedComponentId
	AND intLang.refsetID = @USRefSet 
	AND intLang.linkedComponentId = @Preferred 
	AND extLang.referencedComponentId is null)
AND NOT t.DESC_TYPE = 3
AND t.languageCode = @intLangCode;

--Where term is has inactivation reason, set the description status
-- but only where the description is not actually active
UPDATE rf21_term t
SET t.DESCRIPTIONSTATUS = COALESCE (
	select magicNumberFor(max(s.linkedComponentId))
	from rf2_crefset s
	where s.referencedComponentId = t.descriptionid
	and s.refSetId = @DInactivationRefSet
	AND s.active = 1,t.descriptionstatus)
WHERE t.descriptionstatus <> 0;

-- Where the concept has limited status (6), and the description is otherwise active,
-- the description should also have status 6.
UPDATE rf21_term t
SET t.DESCRIPTIONSTATUS = 6
WHERE EXISTS (
	SELECT 1 FROM rf21_concept c
	WHERE t.conceptid = c.conceptid
	AND c.conceptstatus = 6 )
and t.descriptionstatus = 0;

-- Where the concept is non current (ie status 1, 2, 3, 4, 5, or 10) then
-- the description takes status 8
UPDATE rf21_term t
SET t.DESCRIPTIONSTATUS = 8
WHERE EXISTS (
   SELECT 1 from rf21_concept c
   WHERE t.conceptid = c.conceptid
   AND c.conceptStatus in (1, 2, 3, 4, 5, 10))
AND t.DESCRIPTIONSTATUS = 0;

-- TODO REMOVE THIS TWEAK once TCs are happy with the basic process
-- When a description is inactive and the langrefset line that made it preferred
-- was inactivated at the same time, then mark it as preferred
create table tmp_inactive_preferred AS
	SELECT t2.id AS descriptionId from rf2_term t2, rf2_crefset l
	WHERE l.referencedComponentId = t2.id
	AND t2.active = 0
	AND t2.effectiveTime = l.effectiveTime
	AND l.refsetid = @langRefSet
	AND l.linkedComponentId = @Preferred
	AND l.active = 0;
	
create index idx_tmp_ip_id on tmp_inactive_preferred(descriptionId);

UPDATE rf21_term t
SET t.DESC_TYPE = 1
WHERE descriptionStatus <> 0
AND NOT t.DESC_TYPE = 3
AND EXISTS (
	SELECT 1 FROM tmp_inactive_preferred tt
	where t.descriptionId = tt.descriptionId
);

INSERT INTO rf21_subsetlist SELECT DISTINCT 
	@RDATE || '3' AS SubsetID, 
	m.OriginalSubsetID AS OriginalSubsetID, 
	SUBSTR(@RDATE,0,6)  AS SUBSETVERSION, 
	m.SubsetName AS SUBSETNAME, 
	1 AS SUBSETTYPE, 
	@langCode AS LANGUAGECODE, 
	'0' AS RealmId, 
	0 AS CONTEXTID
FROM rf2_crefset s 
	INNER JOIN rf2_subset2refset m 
		ON s.refsetId = m.refsetId
WHERE s.refsetid = @langRefSet;

INSERT INTO rf21_subsets 
	SELECT m.refsetId AS SubsetId, 
	referencedComponentId AS MemberID, 
	t.DESC_TYPE AS MemberStatus, 
	null AS LinkedID ,
	m.OriginalSubsetId AS SubsetOriginalId
	FROM rf21_term t, rf2_crefset s  
	INNER JOIN rf2_subset2refset m 
		ON s.refsetId = m.refsetId
	WHERE s.refsetid = @langRefSet
	AND s.referencedComponentId = t.descriptionid
	and t.descriptionstatus = 0
	AND s.active = 1;