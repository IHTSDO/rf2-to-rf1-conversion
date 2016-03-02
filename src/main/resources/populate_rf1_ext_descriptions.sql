-- Expecting the following variables to be set by the calling program
SET @langCode = 'es';
SET @langRefSet = 448879004;

UPDATE rf21_term SET LANGUAGECODE = @langCode;

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