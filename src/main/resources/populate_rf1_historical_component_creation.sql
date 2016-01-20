--Insert Concept Component History, first creation
INSERT INTO rf21_COMPONENTHISTORY
SELECT id, effectiveTime, 0, 0, '',''
FROM rf2_concept_sv c
WHERE c.effectiveTime =
  (SELECT MIN(c2.effectiveTime) AS firstCreated FROM rf2_concept_sv AS c2
   WHERE c.id=c2.id );	
   
--Insert Description Component History, first creation
INSERT INTO rf21_COMPONENTHISTORY
SELECT id, effectiveTime, 0, 0, '',''
FROM rf2_term_sv d
WHERE d.effectiveTime =
  (SELECT MIN(d2.effectiveTime) AS firstCreated FROM rf2_term_sv AS d2
   WHERE d.id=d2.id );