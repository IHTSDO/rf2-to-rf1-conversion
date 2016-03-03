-- Expecting the following variables to be set by the calling program
-- SET @langCode = 'es';
-- SET @langRefSet = '448879004';
-- SET @langRefSet = '450828004';

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
AND t.languageCode <> @LangCode;

SELECT * from rf21_term where descriptionid = 1000400015;

SELECT * from rf2_term where id = 1000400015;

-- Description types were set to synonym by default, then FSN were picked up, so now just detect preferred for each language
UPDATE rf21_term t
SET t.DESC_TYPE = 1
WHERE EXISTS (
	select 1 from rf2_crefset lang
	where lang.refsetID = @langRefSet
	and t.DESCRIPTIONID = lang.referencedComponentId
	and lang.linkedComponentId = @Preferred )
AND NOT t.DESC_TYPE = 3;

-- TODO REMOVE THIS TWEAK once TCs are happy with the basic process
-- When a description is inactive and the langrefset line that made it preferred
-- was inactivated at the same time, then mark it as preferred
-- TODO  This one isn't finishing
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
	@RDATE || '1' AS SubsetID, 
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

SELECT count(*) FROM rf2_crefset s 
WHERE s.refsetid = @langRefSet;

SELECT count(*) FROM rf2_subset2refset m 
WHERE m.refsetid = @langRefSet;

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