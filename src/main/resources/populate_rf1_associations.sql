SET @HistoricalAttribute = '10363501000001105'; /* HAD AMP */
SET @Refset = '999001311000000107';	/* Had actual medicinal product association reference set (foundation metadata concept) */
INSERT INTO rf21_rel SELECT  null, s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' FROM rf2_cRefSet s WHERE s.RefSetId = @Refset;

SET @HistoricalAttribute = '10363401000001106'; /* HAD VMP */
SET @Refset = '999001321000000101';	/* Had virtual medicinal product association reference set (foundation metadata concept) */
INSERT INTO rf21_rel SELECT  null, s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' FROM rf2_cRefSet s WHERE s.RefSetId = @Refset;

-- sct1_References appears to only be populated with types 1,4 & 7
-- Replaced By, Alternative, Refers To

SET @HistoricalAttribute = '384598002'; /* MOVED FROM */
SET @Refset = '900000000000525002';	/* MOVED FROM association reference set (foundation metadata concept) */
SET @RefType = 6;
INSERT INTO rf21_rel SELECT null, s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' 
FROM rf2_cRefSet s 
WHERE s.RefSetId = @Refset
AND s.active = 1;

INSERT INTO rf21_reference SELECT s.referencedComponentId, @RefType, linkedComponentID 
FROM rf2_cRefSet s 
WHERE s.RefSetId = @Refset
AND s.active = 1;

SET @HistoricalAttribute = '370125004';    /* MOVED TO */
SET @Refset = '900000000000524003';	/* MOVED TO association reference set (foundation metadata concept) */
INSERT INTO rf21_rel SELECT null, s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' 
FROM rf2_cRefSet s 
WHERE s.RefSetId = @Refset
and s.active = 1;

SET @HistoricalAttribute = '149016008'; /*  MAY BE A */
SET @Refset = '900000000000523009';	/* POSSIBLY EQUIVALENT TO association reference set (foundation metadata concept) */
INSERT INTO rf21_rel SELECT null, s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' 
FROM rf2_cRefSet s 
WHERE s.RefSetId = @Refset
AND s.active = 1;


SET @HistoricalAttribute = '370124000'; /* REPLACED_BY */
SET @Refset = '900000000000526001'; /* 'REPLACED BY association reference set (foundation metadata concept)' */
SET @RefType = 1; 
-- But not when a "MOVED TO" row also exists for this component (null on the left join)
INSERT INTO rf21_rel SELECT null, rep.referencedComponentId, @HistoricalAttribute, rep.linkedComponentID, 2,0,0,'RF2' 
FROM rf2_cRefSet rep LEFT JOIN rf2_cRefSet mvd 
	ON rep.referencedComponentId = mvd.referencedComponentId 
	AND mvd.RefsetId =  '900000000000524003' -- MOVED TO
	AND mvd.active = 1
WHERE rep.RefSetId = @Refset
AND rep.active = 1
AND mvd.linkedComponentID is null;

-- Apparently we only have references for "Replaced By" when the 'slot' in the IS A hierarchy
-- has been taken by a 'MOVED TO' relationship, so basically the complement of the previous 
-- statement
INSERT INTO rf21_reference SELECT s.referencedComponentId, @RefType, s.linkedComponentID 
FROM rf2_cRefSet s, rf2_cRefSet mvd 
WHERE s.RefSetId = @Refset
AND s.referencedComponentId = mvd.referencedComponentId 
AND mvd.RefsetId =  '900000000000524003' -- MOVED TO
AND mvd.active = 1
AND s.active = 1;

SET @HistoricalAttribute = '168666000'; /* SAME_AS */
SET @Refset = '900000000000527005'; /* 'SAME AS association reference set (foundation metadata concept)' */
INSERT INTO rf21_rel SELECT null, s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' 
FROM rf2_cRefSet s 
WHERE s.RefSetId = @Refset
AND s.active = 1;


SET @HistoricalAttribute = '159083000'; /* WAS A */
SET @Refset = '900000000000528000'; /* WAS A association reference set (foundation metadata concept) */
INSERT INTO rf21_rel SELECT null, s.referencedComponentId, @HistoricalAttribute, linkedComponentID, 2,0,0,'RF2' 
FROM rf2_cRefSet s 
WHERE s.RefSetId = @Refset
AND s.active = 1;

SET @Refset = '900000000000531004'; /* REFERS TO CONCEPT association reference set (foundation metadata concept) */
SET @RefType = 7; /*Refers To*/
INSERT INTO rf21_reference 
SELECT s.referencedComponentId, @RefType, linkedComponentID 
FROM rf2_cRefSet s 
WHERE s.RefSetId = @Refset
AND s.active = 1;

SET @Refset = '900000000000530003'; /* | ALTERNATIVE association reference set (foundation metadata concept) */
SET @RefType = 4; /*Alternative*/
INSERT INTO rf21_reference 
SELECT s.referencedComponentId, @RefType, linkedComponentID 
FROM rf2_cRefSet s 
WHERE s.RefSetId = @Refset
AND s.active = 1;

-- Now we may have picked up some historical associations (which become is-a in RF1) for concepts that we don't use in RF1
-- so filter those back out again
DELETE from rf21_rel
WHERE conceptid1 IN (
	SELECT r.conceptid1 FROM rf21_rel r LEFT JOIN rf21_concept c
	ON r.conceptid1 = c.conceptid
	WHERE c.conceptid is null );

SET @InactiveParent = '363661006'; /* Reason not stated */
INSERT INTO rf21_rel SELECT  null, c.CONCEPTID, @ISA, @InactiveParent, 0,0,0,c.SOURCE FROM rf21_concept c WHERE c.CONCEPTSTATUS = 1;

SET @InactiveParent = '363662004'; /* Duplicate */
INSERT INTO rf21_rel SELECT  null, c.CONCEPTID, @ISA, @InactiveParent, 0,0,0,c.SOURCE FROM rf21_concept c WHERE c.CONCEPTSTATUS = 2;

SET @InactiveParent = '363663009'; /* Outdated */
INSERT INTO rf21_rel SELECT  null, c.CONCEPTID, @ISA, @InactiveParent, 0,0,0,c.SOURCE FROM rf21_concept c WHERE c.CONCEPTSTATUS = 3;

SET @InactiveParent = '363660007'; /*Ambiguous concept */
INSERT INTO rf21_rel SELECT  null, c.CONCEPTID, @ISA, @InactiveParent, 0,0,0,c.SOURCE FROM rf21_concept c WHERE c.CONCEPTSTATUS = 4;

SET @InactiveParent = '443559000'; /* Limited */
INSERT INTO rf21_rel SELECT  null, c.CONCEPTID, @ISA, @InactiveParent, 0,0,0,c.SOURCE FROM rf21_concept c WHERE c.CONCEPTSTATUS = 6;

SET @InactiveParent = '363664003'; /* Erroneous */
INSERT INTO rf21_rel SELECT  null, c.CONCEPTID, @ISA, @InactiveParent, 0,0,0,c.SOURCE FROM rf21_concept c WHERE c.CONCEPTSTATUS = 5;

SET @InactiveParent = '370126003'; /* Moved elsewhere */
INSERT INTO rf21_rel SELECT  null, c.CONCEPTID, @ISA, @InactiveParent, 0,0,0,c.SOURCE FROM rf21_concept c WHERE c.CONCEPTSTATUS = 10;

-- Copy all these Inactive Parents into the Stated Relationship table
-- Except that the existing conversion processes sees these as 'defining', so set
-- characteristic type to 0
INSERT INTO rf21_stated_rel
SELECT RELATIONSHIPID, CONCEPTID1, RELATIONSHIPTYPE, CONCEPTID2, 0/*CHARACTERISTICTYPE*/, 0 /*REFINABILITY*/, RELATIONSHIPGROUP, SOURCE 
FROM rf21_rel
WHERE relationshiptype = @ISA
AND conceptid2 in (363661006/* Reason not stated */, 363662004/* Duplicate */, 363663009/* Outdated */, 363660007/*Ambiguous concept */, 443559000/* Limited */, 363664003/* Erroneous */, 370126003/* Moved elsewhere */);
