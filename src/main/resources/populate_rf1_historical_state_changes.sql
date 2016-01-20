-- The scripts in this file are expected to be called in a "multipass" mode so that
-- they are call repeatedly until now more rows are added.

-- Select the latest effective time for each component each pass.  We'll pull the status from attributeValue table later. 

INSERT INTO rf21_COMPONENTHISTORY
SELECT c.id, c.effectiveTime, 1, statusFor(active), 'Status CHANGE', ''
FROM rf2_concept_sv c
WHERE c.effectiveTime = ( select min(c2.effectiveTime) 
						from rf2_concept_sv c2, rf21_COMPONENTHISTORY ch
						where c2.id = ch.componentid
						and c.id = c2.id
						and c2.effectiveTime > (select max(ch2.releaseversion) from rf21_COMPONENTHISTORY ch2
												where ch2.componentid = ch.componentid))