
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

-- Set the common type to 1 (Preferred) when it is preferred in both dialects
-- or when it's preferred in the dialect of its language code
UPDATE rf21_term t
SET t.DESC_TYPE = 1
WHERE (t.US_DESC_TYPE = 1 AND t.GB_DESC_TYPE = 1 )
OR (t.LANGUAGECODE = 'en-US' AND  t.US_DESC_TYPE = 1)
OR (t.LANGUAGECODE = 'en-GB' AND  t.GB_DESC_TYPE = 1);

-- TODO REMOVE THIS TWEAK once TCs are happy with the basic process
-- When a description is inactive and the langrefset line that made it preferred
-- was inactivated at the same time, then mark it as preferred
-- TODO  This one isn't finishing
create table tmp_inactive_preferred AS
	SELECT t2.id AS descriptionId from rf2_term t2, rf2_crefset l
	WHERE l.referencedComponentId = t2.id
	AND t2.active = 0
	AND t2.effectiveTime = l.effectiveTime
	AND l.refsetid = @USRefSet
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

--Where term is has inactivation reason, set the description status
UPDATE rf21_term t
SET t.DESCRIPTIONSTATUS = COALESCE (
	select magicNumberFor(s.linkedComponentId)
	from rf2_crefset s
	where s.referencedComponentId = t.descriptionid
	and s.refSetId = @DInactivationRefSet
	AND s.active = 1,t.descriptionstatus);

-- Where the concept has limited status (6), the description should too
UPDATE rf21_term t
SET t.DESCRIPTIONSTATUS = 6
WHERE EXISTS (
	SELECT 1 FROM rf21_concept c
	WHERE t.conceptid = c.conceptid
	AND c.conceptstatus = 6 )
AND t.DESCRIPTIONSTATUS = 8;

-- Where the description has a REFERS_TO attribute, the status should be 7 - Inappropriate
SET @RefersToRefset = '900000000000531004';
UPDATE rf21_term t
SET t.DESCRIPTIONSTATUS = 7
WHERE EXISTS (
	SELECT 1 FROM rf2_crefset s
	where t.descriptionid = s.referencedComponentId
	and s.refsetId = @RefersToRefset
	and s.active = 1)
AND t.DESCRIPTIONSTATUS = 1;

-- Where the description is acceptable in one dialect and preferred in the other, set the 
-- common description type to 0 - unspecified;
UPDATE rf21_term t
SET t.DESC_TYPE = 0
WHERE EXISTS (
	select 1 from rf2_crefset gb, rf2_crefset us
	where gb.refsetID = @GBRefSet
	and us.refsetID = @USRefSet
	-- and gb.active = us.active   TODO Add this line back in for correct results (but unlike exisiting conversion)
	and t.DESCRIPTIONID = gb.referencedComponentId
	and t.DESCRIPTIONID = us.referencedComponentId
	and gb.linkedComponentId != us.linkedComponentId )
AND NOT t.US_DESC_TYPE = 3;

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
	SELECT l.SubsetID AS SubsetId, 
	referencedComponentId AS MemberID, 
	CASE WHEN s.refsetid =  @USRefSet THEN t.US_DESC_TYPE ELSE t.GB_DESC_TYPE END AS MemberStatus, 
	null AS LinkedID ,
	m.OriginalSubsetId AS SubsetOriginalId
	FROM rf21_term t, rf21_subsetlist l, rf2_crefset s  
	INNER JOIN rf2_subset2refset m 
		ON s.refsetId = m.refsetId
	WHERE s.refsetid in (@USRefSet, @GBRefSet)
	AND s.referencedComponentId = t.descriptionid
	AND m.OriginalSubsetId = l.SubsetOriginalId
	and t.descriptionstatus = 0
	AND s.active = 1;