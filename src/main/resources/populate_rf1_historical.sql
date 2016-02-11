SET @FSN = '900000000000003001';
-- PARALLEL_START;
-- Insert all concept changes into history and we'll work out what changes where made
-- in a subsequent pass.
INSERT INTO rf21_COMPONENTHISTORY
SELECT c.id, c.effectiveTime, -1, -1, '', TRUE, 
(	SELECT max(c2.effectiveTime) from rf2_concept_sv c2
 	WHERE c.id = c2.id
	AND c2.effectiveTime < c.effectiveTime
)
FROM rf2_concept_sv c;

INSERT INTO rf21_COMPONENTHISTORY
SELECT t.id, t.effectiveTime, -1, -1, '', FALSE, 
(	SELECT max(t2.effectiveTime) from rf2_term_sv t2
 	WHERE t.id = t2.id
	AND t2.effectiveTime < t.effectiveTime
)
FROM rf2_term_sv t;

-- PARALLEL_END;

CREATE INDEX idx_comphist_id ON rf21_COMPONENTHISTORY(COMPONENTID);
CREATE INDEX idx_comphist_et ON rf21_COMPONENTHISTORY(releaseVersion);
CREATE INDEX idx_comphist_status ON rf21_COMPONENTHISTORY(status);
CREATE INDEX idx_comphist_prev ON rf21_COMPONENTHISTORY(previousVersion);
CREATE INDEX idx_comphist_c ON rf21_COMPONENTHISTORY(isConcept);

-- PARALLEL_START;
-- Update the first entry for a component to be the "Added" row
UPDATE rf21_COMPONENTHISTORY ch
SET CHANGETYPE=0,STATUS = 0 
WHERE releaseversion = ( 
	SELECT min (releaseversion) from rf21_COMPONENTHISTORY ch2
	WHERE ch.componentid = ch2.componentid
);

-- Update concepts where the active status has changed
UPDATE rf21_COMPONENTHISTORY ch
SET CHANGETYPE=1,
STATUS = statusFor ( select active from rf2_concept_sv c
						where ch.componentid = c.id
						and ch.releaseversion = c.effectiveTime ),
Reason = 'STATUS CHANGE'
WHERE EXISTS (
	SELECT 1 FROM rf2_concept_sv c2, rf2_concept_sv c3
	WHERE ch.componentid = c2.id
	AND c2.id = c3.id
	AND c2.effectiveTime = ch.releaseVersion
	AND c3.effectiveTime = ch.previousVersion
	AND c2.active != c3.active
)
AND ch.isConcept = TRUE;

-- Update descriptions where the active status has changed
UPDATE rf21_COMPONENTHISTORY ch
SET CHANGETYPE=1,
STATUS = statusFor ( select active from rf2_term_sv t
						where ch.componentid = t.id
						and ch.releaseversion = t.effectiveTime ),
Reason = 'DESCRIPTIONSTATUS CHANGE'
WHERE EXISTS (
	SELECT 1 FROM rf2_term_sv t2, rf2_term_sv t3
	WHERE ch.componentid = t2.id
	AND t2.id = t3.id
	AND t2.effectiveTime = ch.releaseVersion
	AND t3.effectiveTime = ch.previousVersion
	AND t2.active != t3.active
) -- Where an FSN has been made inactive, add that as a change to the concept
AND ch.isConcept = FALSE;

SET @CONCEPT_INACT_RS = 900000000000489007;
SET @DESC_INACT_RS = 900000000000490003;
-- Where there is a status change check if the Attribute Value Refset has an entry
-- for that date which indicates why it was made inactive
UPDATE rf21_COMPONENTHISTORY ch
SET STATUS = COALESCE (
	(select magicNumberFor(s.linkedComponentId)
	from rf2_crefset s
	where s.referencedComponentId = ch.componentId
	and s.refSetId  IN (@CONCEPT_INACT_RS,@DESC_INACT_RS)
	AND s.effectiveTime = ch.releaseVersion
	AND s.active = 1),ch.status)
WHERE CHANGETYPE='1';

-- When a description that is an FSN is added, but not at the same time as the concept
-- then add a row to indicate an FSN change for the concept
-- Watch our for changes to case sensitivity.  Filter out cases where earlier active row 
-- with different case sensitivity exists.
-- The status code in this case relates to the inactivation reason for the previous description
INSERT INTO rf21_COMPONENTHISTORY
SELECT t.conceptid, t.effectiveTime, '2', 
-- Find the inactivation reason for the OTHER term which was inactivated
COALESCE ( SELECT magicNumberFor(s.linkedComponentId)
	from rf2_crefset_sv s, rf2_term_sv t2
	where t2.conceptId = t.conceptId
	AND s.referencedComponentId = t2.id
	and s.refSetId ='900000000000490003' -- Description Inactivation Indicator
	AND s.effectiveTime = t2.effectiveTime
	AND t2.effectiveTime = t.effectiveTime
	AND s.active = 1,
	1),
'FULLYSPECIFIEDNAME CHANGE', TRUE, null 
FROM rf2_term_sv t
WHERE t.typeid = @FSN
AND t.active = 1
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

-- Where there was a status change and the previous version had a different
-- case sensitivity, set an INITIALCAPITALSTATUS CHANGE.  For descriptions only.
UPDATE rf21_COMPONENTHISTORY ch
SET changeType = 2,
status = 0,
reason = 'INITIALCAPITALSTATUS CHANGE'
WHERE ch.isConcept = FALSE
AND EXISTS (
	SELECT 1 FROM rf2_term_sv t1, rf2_term_sv t2
	WHERE ch.componentid = t1.id
	AND t1.id = t2.id
	AND t1.effectiveTime = ch.releaseVersion
	AND t2.effectiveTime = ch.previousVersion
	AND NOT t1.casesignificanceid = t2.casesignificanceid
);

-- When a concept goes inactive, if there is not already a row for 
-- the description changing state, then add one in 
INSERT INTO rf21_COMPONENTHISTORY
SELECT DISTINCT t.id, ch2.releaseVersion, 2, 8, 'DESCRIPTIONSTATUS CHANGE', false, null
FROM rf21_COMPONENTHISTORY ch2, rf21_COMPONENTHISTORY ch3, rf2_term_sv t
WHERE ch2.componentid = ch3.componentid
AND ch2.isConcept = TRUE
AND ch3.releaseVersion = ch2.previousVersion
AND ch2.status > 0
AND t.conceptid = ch2.componentid
AND t.active = 1
AND t.effectiveTime < ch2.releaseVersion
AND NOT EXISTS (
	SELECT 1 FROM rf2_term_sv t2
	WHERE t.id = t2.id
	AND t2.active = 0
	AND t2.effectiveTime <= ch2.releaseVersion 
);

-- When a concept goes inactive, description statuses get set to 8 - "Remains as a valid Description of a Concept which is no longer active."
UPDATE rf21_COMPONENTHISTORY ch
SET status = 8
WHERE ch.isConcept = false
AND EXISTS (
	SELECT 1 FROM rf21_COMPONENTHISTORY ch2, rf2_term t
	WHERE ch.componentId = t.id
	AND ch2.componentId = t.conceptId
	AND ch.releaseVersion = ch2.releaseVersion
	AND ch2.status > 0
	AND ch.status = 0
);

-- And now for some ...hopefully temporary... tweaks because the reason given 
-- in the status change does not appear to be consistent between status codes.
UPDATE rf21_COMPONENTHISTORY
SET reason = 'CONCEPTSTATUS CHANGE'
WHERE status = 4;

-- Now delete anything we haven't found a reason for.  Eg changes to definitionStatusId
DELETE from rf21_COMPONENTHISTORY
WHERE status = -1;