SET @MODEL_MODULE = '900000000000012004';
SET @FSN = '900000000000003001';
SET @CONCEPT_INACT_RS = 900000000000489007;
SET @USRefSet = '900000000000509007';
SET @CS_CHANGE = 'CONCEPTSTATUS CHANGE';

SET @DESC_INACT_RS = 900000000000490003;
SET @DS_CHANGE = 'DESCRIPTIONSTATUS CHANGE';
SET @DT_CHANGE = 'DESCRIPTIONTYPE CHANGE';
SET @ICS_CHANGE = 'INITIALCAPITALSTATUS CHANGE';
SET @FSN_CHANGE = 'FULLYSPECIFIEDNAME CHANGE';
SET @HISTORY_START = 20140131;
SET @CONCEPT_NON_CURRENT = 8;
SET @ADDED = 0;
SET @NOT_SET = -1;

SET @COMPONENT_OF_INTEREST = 3085207015;

-- PARALLEL_START;
-- Insert all concept changes into history and we'll work out what changes where made
-- in a subsequent pass.
-- Filter out some model component module concepts - need to do this using text as attributes are OK
INSERT INTO rf21_COMPONENTHISTORY
SELECT c.id, c.effectiveTime,  @NOT_SET,  @NOT_SET, '', TRUE, 
(	-- Work out the most recent change preceeding this change
	SELECT max(c2.effectiveTime) from rf2_concept_sv c2
 	WHERE c.id = c2.id
	AND c2.effectiveTime < c.effectiveTime
	AND c.effectiveTime >= @HISTORY_START
)
FROM rf2_concept_sv c
WHERE NOT ( c.moduleId = @MODEL_MODULE
		AND EXISTS ( SELECT 1 from rf2_term_sv t
						WHERE t.typeid = @FSN
						AND t.conceptid = c.id
						AND t.term like '%metadata concept)' ))
AND c.effectiveTime >= @HISTORY_START;

-- Where the concept entry in the history has no previous entry in the history, 
-- then we'll mark the status as 0 - Created.   
-- Watch out for components that are created in an inactive state however.
UPDATE rf21_COMPONENTHISTORY ch 
SET CHANGETYPE = @ADDED,
STATUS = ( select statusFor(c.active) from rf2_concept_sv c
			where c.id = ch.componentid
			and c.effectiveTime = ch.releaseversion )
WHERE isConcept = true
AND NOT EXISTS (
	SELECT 1 from rf2_concept_sv cf
	WHERE cf.id = ch.componentid
	AND cf.effectiveTime < ch.releaseVersion
);

INSERT INTO rf21_COMPONENTHISTORY
SELECT t.id, t.effectiveTime,  @NOT_SET,  @NOT_SET, '', FALSE, 
(	-- Work out the most recent change preceeding this change
	SELECT max(t2.effectiveTime) from rf2_term_sv t2
	WHERE t.id = t2.id
	AND t2.effectiveTime < t.effectiveTime
	AND t.effectiveTime >= @HISTORY_START
)
FROM rf2_term_sv t
WHERE NOT( t.moduleId = @MODEL_MODULE
		AND EXISTS ( SELECT 1 from rf2_term_sv t2
						WHERE t2.typeid = @FSN
						AND t2.conceptid = t.conceptid
						AND t2.term like '%metadata concept)' ))
AND t.effectiveTime >= @HISTORY_START;

-- Where the term entry in the history has no previous entry in the history, 
-- then we'll mark the status as 0 - Created.
-- Watch out for components that are created in an inactive state however.
UPDATE rf21_COMPONENTHISTORY ch 
SET CHANGETYPE = @ADDED,
STATUS = ( select statusFor(t.active) from rf2_term_sv t
			where t.id = ch.componentid
			and t.effectiveTime = ch.releaseversion )
WHERE isConcept = false
AND NOT EXISTS (
	SELECT 1 from rf2_term_sv tf
	WHERE tf.id = ch.componentid
	AND tf.effectiveTime < ch.releaseVersion
);

CREATE INDEX idx_comphist_id ON rf21_COMPONENTHISTORY(componentId);
CREATE INDEX idx_comphist_et ON rf21_COMPONENTHISTORY(releaseVersion);
CREATE INDEX idx_comphist_status ON rf21_COMPONENTHISTORY(status);
CREATE INDEX idx_comphist_prev ON rf21_COMPONENTHISTORY(previousVersion);
CREATE INDEX idx_comphist_c ON rf21_COMPONENTHISTORY(isConcept);

-- Where the term has been created and the concept is inactive on that date
-- set the status to 8 - "Concept Inactive"
-- Comment this out.  It didn't happen after 20130731.  We now only rely on 
-- inactivation indicators
/*UPDATE rf21_COMPONENTHISTORY ch
SET STATUS =  @CONCEPT_NON_CURRENT
WHERE isConcept = false
AND changeType = @ADDED
AND EXISTS (
	SELECT 1 FROM rf2_concept_sv cf, rf2_term_sv tf
	WHERE cf.id = tf.conceptid
	AND tf.id = ch.componentid
	AND cf.active = 0
	AND cf.effectiveTime = ( SELECT max(effectiveTime) FROM rf2_concept_sv cf2
								WHERE cf2.id = cf.id
								AND cf.effectiveTime <= ch.releaseVersion)
)*/;



SELECT * from rf21_COMPONENTHISTORY where componentid = @COMPONENT_OF_INTEREST;

-- CONCEPT INACTIVATION
-- Where there is no other change, but the inactivation indicator
-- is modified, add a new row.
-- Where the row is inactivating, the change type becomes unknown ie 1 or perhaps the component is 
-- now active in which case 0.
-- But not when there exists a previous entry has the same status - is not a change in that case.
INSERT INTO rf21_COMPONENTHISTORY
SELECT s.referencedComponentId, s.effectiveTime, 1, 
CASE WHEN s.active = 1 THEN magicNumberFor(s.linkedComponentId) ELSE
	-- Find the most recent active flag for the description
	select statusFor(c.active) from rf2_concept_sv c
	where c.id = s.referencedComponentId
	and c.effectiveTime = ( select max(c2.effectiveTime) 
							from rf2_concept_sv c2
							where c2.id = c.id
							and c2.effectiveTime <= s.effectiveTime)
 END AS status,  
@CS_CHANGE AS reason, 
true AS isConcept,
null
FROM rf2_crefset_sv s
WHERE s.refsetId = @CONCEPT_INACT_RS
AND s.effectiveTime >= @HISTORY_START
AND NOT EXISTS (
	SELECT 1 from rf21_COMPONENTHISTORY ch
	where s.referencedComponentId = ch.componentId
	-- Find the next previous or current entry
	and ch.releaseVersion = ( SELECT MAX(ch2.releaseVersion) 
								FROM rf21_COMPONENTHISTORY ch2 
								WHERE ch.componentId = ch2.componentId
								AND ch2.releaseVersion <= s.effectiveTime )
	and ch.status = magicNumberFor(s.linkedComponentId)
);

-- DESCRIPTION INACTIVATION
-- Where there is no other change, but the inactivation indicator
-- is modified, add a new row.
-- Where the row is inactivating, the change type becomes unknown ie 1 or perhaps the component is 
-- now active in which case 0.
-- But not when there exists a previous entry has the same status - is not a change in that case.
INSERT INTO rf21_COMPONENTHISTORY
SELECT s.referencedComponentId, s.effectiveTime, 1, 
CASE WHEN s.active = 1 THEN magicNumberFor(s.linkedComponentId) else 
 (  -- Find the most recent active flag for the description
 	select statusFor(d.active) from rf2_term_sv d
 	where d.id = s.referencedComponentId
 	and d.effectiveTime = ( select max(d2.effectiveTime) from rf2_term_sv d2
 							where d2.id = d.id
 							and d2.effectiveTime <= s.effectiveTime)
 ) END AS status, 
@DS_CHANGE AS reason, 
 false isConcept,
null
FROM rf2_crefset_sv s
WHERE s.refsetId = @DESC_INACT_RS
AND s.effectiveTime >= @HISTORY_START
AND NOT EXISTS (
	SELECT 1 from rf21_COMPONENTHISTORY ch
	where s.referencedComponentId = ch.componentId
	-- Find the next previous or current entry
	and ch.releaseVersion = ( SELECT MAX(ch2.releaseVersion) 
								FROM rf21_COMPONENTHISTORY ch2 
								WHERE ch.componentId = ch2.componentId
								AND ch2.releaseVersion <= s.effectiveTime )
	and ch.status = magicNumberFor(s.linkedComponentId)
);

SELECT * from rf21_COMPONENTHISTORY where componentid = @COMPONENT_OF_INTEREST;

-- Now if we have rows that do not have a status set that are duplicates with rows that do
-- then now would be good time to delete those before we can't tell between them.
DELETE from rf21_COMPONENTHISTORY ch WHERE EXISTS
( SELECT 1 from rf21_COMPONENTHISTORY ch2
  WHERE ch.componentid = ch2.componentid
  AND ch.releaseVersion = ch2.releaseVersion
  AND ch.status = @NOT_SET and NOT ch2.status = @NOT_SET);

-- Where there's been a change in the language acceptability, capture
-- that too.
INSERT INTO rf21_COMPONENTHISTORY
SELECT s.referencedComponentId, s.effectiveTime, 2, 
CASE WHEN s.active = 1 THEN 0 else 1 END AS status, 
@DT_CHANGE AS reason, 
false AS isConcept,
null
FROM rf2_crefset_sv s
WHERE s.refsetId = @USRefSet
AND s.effectiveTime >= @HISTORY_START
-- We'll also pick up Text Definitions from the Lang Refset, so check it exists 
-- in the descriptions table
AND EXISTS (
	SELECT 1 FROM rf2_term_sv t
	WHERE t.id = s.referencedComponentId
)
-- And make sure there isn't already a change noted for this component / effective time
AND NOT EXISTS (
  SELECT 1 from rf21_COMPONENTHISTORY ch
  where s.referencedComponentId = ch.componentid
  and s.effectiveTime = ch.releaseversion );


-- When a description that is an FSN is added, but not at the same time as the concept
-- then add a row to indicate an FSN change for the concept
-- Watch our for changes to case sensitivity.  Filter out cases where earlier active row 
-- with different case sensitivity exists.
-- The status code in this case relates to the inactivation reason for the previous description
INSERT INTO rf21_COMPONENTHISTORY
SELECT t.conceptid, t.effectiveTime, '2', 
-- Find the inactivation reason for the concept, if it exists
COALESCE ( SELECT max(magicNumberFor(s.linkedComponentId))
	from rf2_crefset_sv s
	where t.conceptId = s.referencedComponentId
	and s.refSetId = @CONCEPT_INACT_RS
	AND s.effectiveTime <= t.effectiveTime
	AND s.active = 1,0),
@FSN_CHANGE, TRUE, null 
FROM rf2_term_sv t
WHERE t.typeid = @FSN
AND t.active = 1
AND t.effectiveTime >= @HISTORY_START
AND NOT EXISTS (
	SELECT 1 FROM rf21_COMPONENTHISTORY ch2
	where t.conceptid = ch2.componentid
	and t.effectiveTime = ch2.releaseversion
	and ch2.changetype = '0'
)
AND NOT EXISTS (
	SELECT 1 FROM rf2_term_sv t2
	where t.id = t2.id
	and t2.effectiveTime < t.effectiveTime
	and t2.active = 1
	and NOT t2.casesignificanceid = t.caseSignificanceId
);

SELECT * from rf21_COMPONENTHISTORY where componentid = @COMPONENT_OF_INTEREST;


-- Where there was a component change and the previous version had a different
-- case sensitivity, set an INITIALCAPITALSTATUS CHANGE.  For descriptions only.
-- but not where the was also a change in active status, which takes priority
UPDATE rf21_COMPONENTHISTORY ch
SET changeType = 2,
-- Status will be taken from the most recent active inactivation indicator
STATUS = COALESCE (
	select max(CASE WHEN s.active = 1 THEN magicNumberFor(s.linkedComponentId) else 0 END) 
	from rf2_crefset_sv s
	where s.referencedComponentId = ch.componentId
	and s.refSetId = @DESC_INACT_RS
	-- The current inactivation indicator might be inactive
	AND s.effectiveTime = ( SELECT MAX(s2.effectivetime) from rf2_crefset_sv s2
							WHERE s.refsetId = s2.refsetId
							AND s.referencedComponentId = s2.referencedComponentId
							AND s2.effectivetime <= ch.releaseVersion)
	,0) ,
reason = @ICS_CHANGE
WHERE ch.isConcept = FALSE
AND ch.changeType =  @NOT_SET
AND EXISTS (
	SELECT 1 FROM rf2_term_sv t1, rf2_term_sv t2
	WHERE ch.componentid = t1.id
	AND t1.id = t2.id
	AND t1.effectiveTime = ch.releaseVersion
	AND t2.effectiveTime = ch.previousVersion
	AND t1.active = t2.active
	AND NOT t1.casesignificanceid = t2.casesignificanceid
);

SELECT * from rf21_COMPONENTHISTORY where componentid = @COMPONENT_OF_INTEREST;


-- Where there's been a status change but we haven't found an inactivation reason, 
-- just set the status to 1 - reason unknown
-- Update concepts where the active status has changed
UPDATE rf21_COMPONENTHISTORY ch
SET CHANGETYPE=1,
STATUS = statusFor ( select active from rf2_concept_sv c
						where ch.componentid = c.id
						and ch.releaseversion = c.effectiveTime ),
Reason =  @CS_CHANGE
WHERE EXISTS (
	SELECT 1 FROM rf2_concept_sv c2, rf2_concept_sv c3
	WHERE ch.componentid = c2.id
	AND c2.id = c3.id
	AND c2.effectiveTime = ch.releaseVersion
	AND c3.effectiveTime = ch.previousVersion
	AND c2.active != c3.active
)
AND ch.status = @NOT_SET
AND ch.isConcept = TRUE
AND releaseversion >=  @HISTORY_START;

-- Update descriptions where the active status has changed
UPDATE rf21_COMPONENTHISTORY ch
SET CHANGETYPE=1,
STATUS = statusFor ( select active from rf2_term_sv t
						where ch.componentid = t.id
						and ch.releaseversion = t.effectiveTime ),
Reason =  @DS_CHANGE
WHERE EXISTS (
	SELECT 1 FROM rf2_term_sv t2, rf2_term_sv t3
	WHERE ch.componentid = t2.id
	AND t2.id = t3.id
	AND t2.effectiveTime = ch.releaseVersion
	AND t3.effectiveTime = ch.previousVersion
	AND t2.active != t3.active
) -- Where an FSN has been made inactive, add that as a change to the concept
AND ch.isConcept = FALSE
AND ch.status = @NOT_SET
AND releaseversion >=  @HISTORY_START;

SELECT * from rf21_COMPONENTHISTORY where componentid = @COMPONENT_OF_INTEREST;

-- Now delete anything we haven't found a reason for.  Eg changes to definitionStatusId
DELETE from rf21_COMPONENTHISTORY
WHERE status =  @NOT_SET;

-- And where we have two changes, delete the less significant eg type 2
DELETE from rf21_COMPONENTHISTORY ch
WHERE EXISTS (
  SELECT 1 from rf21_COMPONENTHISTORY ch2
  WHERE ch.componentid = ch2.componentId
  AND ch.releaseversion = ch2.releaseVersion
  AND ( 
     ch.changeType > ch2.changeType
     OR (ch.changeType = ch2.changeType AND ch.status = 1 AND NOT ch2.status = 1)
     OR (ch.changeType = ch2.changeType AND ch.status = 0 AND NOT ch2.status = 0)
     )
);
