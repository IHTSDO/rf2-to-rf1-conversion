-- Insert all concept changes into history and we'll work out what changes where made
-- in a subsequent pass.
INSERT INTO rf21_COMPONENTHISTORY
SELECT c.id, c.effectiveTime, 'X', 'X', '', TRUE, 
(	SELECT max(c2.effectiveTime) from rf2_concept_sv c2
 	WHERE c.id = c2.id
	AND c2.effectiveTime < c.effectiveTime
)
FROM rf2_concept_sv c;

INSERT INTO rf21_COMPONENTHISTORY
SELECT t.id, t.effectiveTime, 'X', 'X', '', FALSE, 
(	SELECT max(t2.effectiveTime) from rf2_term_sv t2
 	WHERE t.id = t2.id
	AND t2.effectiveTime < t.effectiveTime
)
FROM rf2_term_sv t;

-- Update concepts where the active status has changed
UPDATE rf21_COMPONENTHISTORY ch
SET CHANGETYPE=1,
STAT = statusFor ( select active from rf2_concept_sv c
						where ch.componentid = c.id
						and ch.releaseversion = c.effectiveTime ),
Reason = 'Status change'
WHERE EXISTS (
	SELECT 1 FROM rf2_concept_sv c2, rf2_concept_sv c3
	WHERE ch.componentid = c2.id
	AND c2.id = c3.id
	AND c2.effectiveTime = ch.releaseVersion
	AND c3.effectiveTime = ch.previous_Version
	AND c2.active != c3.active
)
AND ch.IS_CONCEPT = TRUE;

-- Update descriptions where the active status has changed

UPDATE rf21_COMPONENTHISTORY ch
SET CHANGETYPE=1,
STAT = statusFor ( select active from rf2_term_sv t
						where ch.componentid = t.id
						and ch.releaseversion = t.effectiveTime ),
Reason = 'DESCRIPTIONSTATUS CHANGE'
WHERE EXISTS (
	SELECT 1 FROM rf2_term_sv t2, rf2_term_sv t3
	WHERE ch.componentid = t2.id
	AND t2.id = t3.id
	AND t2.effectiveTime = ch.releaseVersion
	AND t3.effectiveTime = ch.previous_Version
	AND t2.active != t3.active
)
AND ch.IS_CONCEPT = FALSE;
-- Where an FSN has been made inactive, add that as a change to the concept
