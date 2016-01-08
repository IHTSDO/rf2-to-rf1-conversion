/*
Title        : SNOMED CT Release Format 2 - Extract SNAPSHOT
Author       : Jeremy Rogers
Date         : 3rd April 2014
Copyright    : Crown Coyright
Source       : United Kingdom Terminology Centre, Data Standards and Products, NHS Technology Office
License      : Open Government License http://www.nationalarchives.gov.uk/doc/open-government-licence/
Purpose      : Extract an RF2 Snapshot from the FULL Tables
*/

DELIMITER $$
DROP PROCEDURE IF EXISTS `ExtractSnapshot` $$
CREATE PROCEDURE ExtractSnapshot(SnapshotDate VARCHAR(8))
BEGIN

INSERT INTO IMPORTTIME_RF2 SET Event = 'START Extract RF2 snapshot ', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

SET @RDATE = SnapshotDate;

IF @RDATE IN ('') THEN
	INSERT INTO IMPORTTIME_RF2 SET Event = 'No snapshot date specified; assuming latest possible', DTSTAMP = '', TMSTAMP=CURRENT_TIME;	
	SET @RDATE = 'LATEST';
END IF;

IF @RDATE IN ('CURRENT','LATEST') THEN
	SET @RDATE = (SELECT MAX(effectiveTime) FROM rf2_concept_sv);
END IF;

IF @RDATE IN ('NOW','TODAY') THEN
	SET @RDATE = CONCAT(LEFT(CURRENT_DATE,4), MID(CURRENT_DATE,6,2), RIGHT(CURRENT_DATE,2));
END IF;

INSERT INTO IMPORTTIME_RF2 SET Event = 'Snapshot date:', DTSTAMP = @RDATE, TMSTAMP='';	

INSERT INTO rf2_concept
SELECT * FROM rf2_concept_sv s
WHERE s.effectiveTime =
  (SELECT MAX(sv.effectiveTime) AS LatestDate FROM rf2_concept_sv AS sv
   WHERE sv.id=s.id AND sv.effectiveTime <= @RDATE);

INSERT INTO IMPORTTIME_RF2 SET Event = '  Extracted RF2 Concept snapshot', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

INSERT INTO rf2_term
SELECT * FROM rf2_term_sv s
WHERE s.effectiveTime =
  (SELECT MAX(sv.effectiveTime) AS LatestDate FROM rf2_term_sv AS sv
   WHERE sv.id=s.id AND sv.effectiveTime <= @RDATE);

INSERT INTO IMPORTTIME_RF2 SET Event = '  Extracted RF2 Description snapshot', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

INSERT INTO rf2_def
SELECT * FROM rf2_def_sv s
WHERE s.effectiveTime =
  (SELECT MAX(sv.effectiveTime) AS LatestDate FROM rf2_def_sv AS sv
   WHERE sv.id=s.id AND sv.effectiveTime <= @RDATE);
INSERT INTO IMPORTTIME_RF2 SET Event = '  Extracted RF2 Definition snapshot', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

INSERT INTO rf2_rel
SELECT * FROM rf2_rel_sv s
WHERE s.active = 1 AND s.effectiveTime =
  (SELECT MAX(sv.effectiveTime) AS LatestDate FROM rf2_rel_sv AS sv
   WHERE sv.id=s.id AND sv.effectiveTime <= @RDATE);

INSERT INTO IMPORTTIME_RF2 SET Event = '  Extracted RF2 Relationship snapshot (inactive rels discarded)', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

INSERT INTO rf2_identifier
SELECT * FROM rf2_identifier_sv s
WHERE s.effectiveTime =
  (SELECT MAX(sv.effectiveTime) AS LatestDate
   FROM rf2_identifier_sv AS sv
   WHERE s.referencedComponentId = sv.referencedComponentId AND s.identifierSchemeId = sv.identifierSchemeId
   AND s.effectiveTime <= @RDATE);

INSERT INTO IMPORTTIME_RF2 SET Event = '  Extracted RF2 Identifier snapshot', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

INSERT INTO IMPORTTIME_RF2 SET Event = '  START Extract RF2 RefSet snapshots (inactive members discarded)', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

INSERT INTO rf2_refset
SELECT * FROM rf2_refset_sv s
WHERE s.effectiveTime =
  (SELECT MAX(sv.effectiveTime) AS LatestDate FROM rf2_refset_sv AS sv
   WHERE sv.id=s.id AND sv.effectiveTime <= @RDATE);

INSERT INTO IMPORTTIME_RF2 SET Event = '    Extracted RF2 Simple RefSet snapshot', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

INSERT INTO rf2_crefset
SELECT * FROM rf2_crefset_sv s
WHERE s.effectiveTime =
  (SELECT MAX(sv.effectiveTime) AS LatestDate FROM rf2_crefset_sv AS sv
   WHERE sv.id=s.id AND sv.effectiveTime <= @RDATE);

INSERT INTO IMPORTTIME_RF2 SET Event = '    Extracted RF2 cRefSet snapshot', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

INSERT INTO rf2_icrefset
SELECT * FROM rf2_icrefset_sv s
WHERE s.effectiveTime =
  (SELECT MAX(sv.effectiveTime) AS LatestDate FROM rf2_icrefset_sv AS sv
   WHERE sv.id=s.id AND sv.effectiveTime <= @RDATE);

INSERT INTO IMPORTTIME_RF2 SET Event = '    Extracted RF2 icRefSet snapshot', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

INSERT INTO rf2_srefset
SELECT * FROM rf2_srefset_sv s
WHERE s.effectiveTime =
  (SELECT MAX(sv.effectiveTime) AS LatestDate FROM rf2_srefset_sv AS sv
   WHERE sv.id=s.id AND sv.effectiveTime <= @RDATE);

INSERT INTO IMPORTTIME_RF2 SET Event = '    Extracted RF2 Simple sRefSet snapshot', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

INSERT INTO rf2_cirefset
SELECT * FROM rf2_cirefset_sv s
WHERE s.effectiveTime =
  (SELECT MAX(sv.effectiveTime) AS LatestDate FROM rf2_cirefset_sv AS sv
   WHERE sv.id=s.id AND sv.effectiveTime <= @RDATE);

INSERT INTO IMPORTTIME_RF2 SET Event = '    Extracted RF2 ciRefSet snapshot', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

INSERT INTO rf2_ccirefset
SELECT * FROM rf2_ccirefset_sv s
WHERE s.effectiveTime =
  (SELECT MAX(sv.effectiveTime) AS LatestDate FROM rf2_ccirefset_sv AS sv
   WHERE sv.id=s.id AND sv.effectiveTime <= @RDATE);

INSERT INTO IMPORTTIME_RF2 SET Event = '    Extracted RF2 cciRefSet snapshot', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

INSERT INTO rf2_ssrefset
SELECT * FROM rf2_ssrefset_sv s
WHERE s.effectiveTime =
  (SELECT MAX(sv.effectiveTime) AS LatestDate FROM rf2_ssrefset_sv AS sv
   WHERE sv.id=s.id AND sv.effectiveTime <= @RDATE);

INSERT INTO IMPORTTIME_RF2 SET Event = '    Extracted RF2 ssRefSet snapshot', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

INSERT INTO rf2_iissscrefset
SELECT * FROM rf2_iissscrefset_sv s
WHERE s.effectiveTime =
  (SELECT MAX(sv.effectiveTime) AS LatestDate FROM rf2_iissscrefset_sv AS sv
   WHERE sv.id=s.id AND sv.effectiveTime <= @RDATE);

INSERT INTO IMPORTTIME_RF2 SET Event = '    Extracted RF2 iissscRefSet (Mapping) snapshot', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

INSERT INTO rf2_iissscirefset
SELECT * FROM rf2_iissscirefset_sv s
WHERE s.effectiveTime =
  (SELECT MAX(sv.effectiveTime) AS LatestDate FROM rf2_iissscirefset_sv AS sv
   WHERE sv.id=s.id AND sv.effectiveTime <= @RDATE);

INSERT INTO IMPORTTIME_RF2 SET Event = '    Extracted RF2 iisssciRefSet (Mapping) snapshot', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

INSERT INTO IMPORTTIME_RF2 SET Event = '  END Extract RF2 RefSet snapshots', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
INSERT INTO IMPORTTIME_RF2 SET Event = 'END Extract RF2 snapshot', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

INSERT INTO IMPORTTIME_RF2 SET Event = 'START Index RF2 snapshot', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
INSERT INTO IMPORTTIME_RF2 SET Event = '  INDEXING Concept.ConceptID', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
CREATE INDEX CONCEPT_CUI_X ON rf2_concept(ID);
INSERT INTO IMPORTTIME_RF2 SET Event = '  INDEXING Concept.ConceptStatus', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
CREATE INDEX CONCEPT_STAT_X ON rf2_concept(definitionStatusId);
INSERT INTO IMPORTTIME_RF2 SET Event = '  INDEXING Term.ConceptID', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
CREATE INDEX TERM_CUI_X ON rf2_term(conceptId);
#INSERT INTO IMPORTTIME_RF2 SET Event = '  INDEXING Term.LanguageCode', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
#CREATE INDEX TERM_LANG_X ON rf2_term(languageCode);
INSERT INTO IMPORTTIME_RF2 SET Event = '  INDEXING Term.Term', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
CREATE INDEX TERM_TERM_X ON rf2_term(Term);
INSERT INTO IMPORTTIME_RF2 SET Event = '  INDEXING Rel.ConceptID1', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
CREATE INDEX REL_CUI1_X ON rf2_rel(sourceId);
INSERT INTO IMPORTTIME_RF2 SET Event = '  INDEXING Rel.RelationshipType', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
CREATE INDEX REL_RELATION_X ON rf2_rel(typeId);
INSERT INTO IMPORTTIME_RF2 SET Event = '  INDEXING Rel.ConceptID2', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
CREATE INDEX REL_CUI2_X ON rf2_rel(destinationId);
INSERT INTO IMPORTTIME_RF2 SET Event = '  INDEXING Rel.CharacteristicType', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
CREATE INDEX REL_CHARTYPE_X ON rf2_rel(characteristicTypeId);
INSERT INTO IMPORTTIME_RF2 SET Event = '  INDEXING RefSet.refsetId', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
CREATE INDEX ref_X ON rf2_refset(refsetId);
CREATE INDEX ref_X ON rf2_crefset(refsetId);
CREATE INDEX ref_X ON rf2_icrefset(refsetId);
CREATE INDEX ref_X ON rf2_srefset(refsetId);
CREATE INDEX ref_X ON rf2_ccirefset(refsetId);
CREATE INDEX ref_X ON rf2_cirefset(refsetId);
CREATE INDEX ref_X ON rf2_ssrefset(refsetId);
CREATE INDEX ref_X ON rf2_iissscrefset(refsetId);
CREATE INDEX ref_X ON rf2_iissscirefset(refsetId);
INSERT INTO IMPORTTIME_RF2 SET Event = '  INDEXING RefSet.referencedComponentId', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
CREATE INDEX CUI_X ON rf2_refset(referencedComponentId);
CREATE INDEX CUI_X ON rf2_crefset(referencedComponentId);
CREATE INDEX CUI_X ON rf2_icrefset(referencedComponentId);
CREATE INDEX CUI_X ON rf2_srefset(referencedComponentId);
CREATE INDEX CUI_X ON rf2_ccirefset(referencedComponentId);
CREATE INDEX CUI_X ON rf2_cirefset(referencedComponentId);
CREATE INDEX CUI_X ON rf2_ssrefset(referencedComponentId);
CREATE INDEX CUI_X ON rf2_iissscrefset(referencedComponentId);
CREATE INDEX CUI_X ON rf2_iissscirefset(referencedComponentId);
INSERT INTO IMPORTTIME_RF2 SET Event = '  INDEXING RefSet.linkedComponentIds', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
CREATE INDEX LUI_X ON rf2_crefset(linkedComponentId);
CREATE INDEX LUI_X ON rf2_cirefset(linkedComponentId);
CREATE INDEX LUI1_X ON rf2_ccirefset(linkedComponentId2);
CREATE INDEX LUI2_X ON rf2_ccirefset(linkedComponentId1);
CREATE INDEX LUI_X ON rf2_iissscrefset(corelationID);
CREATE INDEX LUI_X ON rf2_iissscirefset(corelationID);

INSERT INTO IMPORTTIME_RF2 SET Event = 'END Index RF2 snapshot', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

END $$

DROP PROCEDURE IF EXISTS `RF2_FixSnapshots` $$
CREATE PROCEDURE RF2_FixSnapshots()
BEGIN

INSERT INTO IMPORTTIME_RF2 SET Event = 'START Clean up imported merger of edition snapshots', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

DROP TABLE IF EXISTS rf2_temp;
CREATE TABLE rf2_temp (id VARCHAR(38) BINARY NOT NULL) ENGINE = MEMORY;

DROP TABLE IF EXISTS rf2_temp2;
CREATE TABLE rf2_temp2 (
	  id VARCHAR(38) BINARY NOT NULL,  /* UUID instead of MemberID */
	  effectiveTime VARBINARY(14) NOT NULL,
	  active BOOLEAN NOT NULL,
	  moduleId VARBINARY(18) NOT NULL,
	  refSetId VARBINARY(18) NOT NULL,  /* From metadata hierarchy */
	  referencedComponentId VARBINARY(18) NOT NULL,
	  linkedComponentId VARBINARY(18) NOT NULL) ENGINE = MEMORY;

# Identify cResfet components for which the union of snapshot files contains more than one row
INSERT INTO rf2_temp (SELECT id FROM rf2_crefset_sp GROUP BY id HAVING COUNT(referencedComponentId) > 1);
INSERT INTO IMPORTTIME_RF2 SET Event = CONCAT('  ',ROW_COUNT(),' crefSet ids have >1 row'), DTSTAMP = '', TMSTAMP=CURRENT_TIME;
CREATE INDEX i_x ON rf2_temp(id);

# Retrieve all imported snapshot rows relating to these duplicates
INSERT INTO rf2_temp2 SELECT r.* FROM rf2_crefset_sp r INNER JOIN rf2_temp t ON r.id = t.id;
CREATE INDEX i_x ON rf2_temp2(id);

# Discard all but the newest row
DELETE a.* FROM rf2_temp2 a INNER JOIN rf2_temp2 b ON a.id = b.id WHERE a.effectiveTime < b.effectiveTime;
INSERT INTO IMPORTTIME_RF2 SET Event = CONCAT('  ',ROW_COUNT(),' redundant rows identified'), DTSTAMP = '', TMSTAMP=CURRENT_TIME;

# Back in the imported Snapshot file table, discard rows that predating the newest row
DELETE sp.* FROM rf2_crefset_sp sp INNER JOIN rf2_temp2 t ON sp.ID = t.ID WHERE sp.effectiveTime <> t.effectiveTime;
INSERT INTO IMPORTTIME_RF2 SET Event = CONCAT('  ',ROW_COUNT(),' redundant rows discarded from imported snapshots'), DTSTAMP = '', TMSTAMP=CURRENT_TIME;

DROP TABLE IF EXISTS rf2_temp;
DROP TABLE IF EXISTS rf2_temp2;

INSERT INTO IMPORTTIME_RF2 SET Event = 'END Clean up imported merger of edition snapshots', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

INSERT INTO IMPORTTIME_RF2 SET Event = 'START Clean up computed snapshot for language refsets', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

DROP TABLE IF EXISTS rf2_temp;
CREATE TABLE rf2_temp (id VARCHAR(38) BINARY NOT NULL) ENGINE = MEMORY;

DROP TABLE IF EXISTS rf2_temp2;
CREATE TABLE rf2_temp2 (
	  id VARCHAR(38) BINARY NOT NULL,  /* UUID instead of MemberID */
	  effectiveTime VARBINARY(14) NOT NULL,
	  active BOOLEAN NOT NULL,
	  moduleId VARBINARY(18) NOT NULL,
	  refSetId VARBINARY(18) NOT NULL,  /* From metadata hierarchy */
	  referencedComponentId VARBINARY(18) NOT NULL,
	  linkedComponentId VARBINARY(18) NOT NULL) ENGINE = MEMORY;

# Identify cResfet components for which the union of snapshot files contains more than one row
INSERT INTO rf2_temp (SELECT id FROM rf2_crefset GROUP BY id HAVING COUNT(referencedComponentId) > 1);
INSERT INTO IMPORTTIME_RF2 SET Event = CONCAT('  ',ROW_COUNT(),' crefSet ids have >1 row'), DTSTAMP = '', TMSTAMP=CURRENT_TIME;
CREATE INDEX i_x ON rf2_temp(id);

# Retrieve all imported snapshot rows relating to these duplicates
INSERT INTO rf2_temp2 SELECT r.* FROM rf2_crefset_sp r INNER JOIN rf2_temp t ON r.id = t.id;
CREATE INDEX i_x ON rf2_temp2(id);

# Discard rows stating descriptionId is acceptable where another row says it is preferred
DELETE a.* FROM rf2_temp2 a INNER JOIN rf2_temp2 b ON a.id = b.id WHERE a.effectiveTime = b.effectiveTime AND a.linkedComponentId = '900000000000549004' AND b.linkedComponentId = '900000000000548007';
INSERT INTO IMPORTTIME_RF2 SET Event = CONCAT('  ',ROW_COUNT(),' redundant rows identified'), DTSTAMP = '', TMSTAMP=CURRENT_TIME;

DELETE a.* FROM rf2_crefset a INNER JOIN rf2_temp2 b ON a.ID = b.ID WHERE a.linkedComponentId <> b.linkedComponentId;
INSERT INTO IMPORTTIME_RF2 SET Event = CONCAT('  ',ROW_COUNT(),' acceptable/preferred descriptions resolved to preferred only'), DTSTAMP = '', TMSTAMP=CURRENT_TIME;

DROP TABLE IF EXISTS rf2_temp;
DROP TABLE IF EXISTS rf2_temp2;

INSERT INTO IMPORTTIME_RF2 SET Event = 'END Clean up computed snapshot for language refsets', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

END $$

DROP PROCEDURE IF EXISTS `RF2_CompareSnapshots` $$
CREATE PROCEDURE RF2_CompareSnapshots()
BEGIN

INSERT INTO IMPORTTIME_RF2 SET Event = 'START Compare computed with received RF2 snapshot', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
INSERT INTO IMPORTTIME_RF2 SET Event = '   (+ve val -> computed snapshot larger than received)', DTSTAMP = '', TMSTAMP='';

SET @Res = ((SELECT COUNT(ID) FROM rf2_concept) - (SELECT COUNT(ID) FROM rf2_concept_sp));
INSERT INTO IMPORTTIME_RF2 SET Event = '  rf2_concept snapshot', DTSTAMP = IF(@Res = 0,'SAME',CONCAT('DIFFERENT (n=',@Res,')')), TMSTAMP=CURRENT_TIME;

SET @Res = ((SELECT COUNT(ID) FROM rf2_term) - (SELECT COUNT(ID) FROM rf2_term_sp));
INSERT INTO IMPORTTIME_RF2 SET Event = '  rf2_term snapshot', DTSTAMP = IF(@Res = 0,'SAME',CONCAT('DIFFERENT (n=',@Res,')')), TMSTAMP=CURRENT_TIME;

SET @Res = ((SELECT COUNT(ID) FROM rf2_def) - (SELECT COUNT(ID) FROM rf2_def_sp));
INSERT INTO IMPORTTIME_RF2 SET Event = '  rf2_definitions snapshot', DTSTAMP = IF(@Res = 0,'SAME',CONCAT('DIFFERENT (n=',@Res,')')), TMSTAMP=CURRENT_TIME;

SET @Res = ((SELECT COUNT(ID) FROM rf2_rel) - (SELECT COUNT(ID) FROM rf2_rel_sp WHERE active = 1));
INSERT INTO IMPORTTIME_RF2 SET Event = '  rf2_rel snapshot', DTSTAMP = IF(@Res = 0,'SAME',CONCAT('DIFFERENT (n=',@Res,')')), TMSTAMP=CURRENT_TIME;

SET @Res = ((SELECT COUNT(ID) FROM rf2_refset) - (SELECT COUNT(ID) FROM rf2_refset_sp));
INSERT INTO IMPORTTIME_RF2 SET Event = '  rf2_refset snapshot', DTSTAMP = IF(@Res = 0,'SAME',CONCAT('DIFFERENT (n=',@Res,')')), TMSTAMP=CURRENT_TIME;

SET @Res = ((SELECT COUNT(ID) FROM rf2_srefset) - (SELECT COUNT(ID) FROM rf2_srefset_sp));
INSERT INTO IMPORTTIME_RF2 SET Event = '  rf2_srefset snapshot', DTSTAMP = IF(@Res = 0,'SAME',CONCAT('DIFFERENT (n=',@Res,')')), TMSTAMP=CURRENT_TIME;

SET @Res = ((SELECT COUNT(ID) FROM rf2_ssrefset) - (SELECT COUNT(ID) FROM rf2_ssrefset_sp));
INSERT INTO IMPORTTIME_RF2 SET Event = '  rf2_ssrefset snapshot', DTSTAMP = IF(@Res = 0,'SAME',CONCAT('DIFFERENT (n=',@Res,')')), TMSTAMP=CURRENT_TIME;

SET @Res = ((SELECT COUNT(ID) FROM rf2_crefset) - (SELECT COUNT(ID) FROM rf2_crefset_sp));
INSERT INTO IMPORTTIME_RF2 SET Event = '  rf2_crefset snapshot', DTSTAMP = IF(@Res = 0,'SAME',CONCAT('DIFFERENT (n=',@Res,')')), TMSTAMP=CURRENT_TIME;

INSERT INTO IMPORTTIME_RF2
(SELECT CONCAT(moduleSourceFor(a.moduleId),' ',a.RefSetId,' ',IF(c.FullySpecifiedName IS NULL,'** unrecognised refset **',c.FullySpecifiedName)) As EVENT,  
       IF((a.NUM - b.NUM) = 0,'SAME',CONCAT('DIFFERENT (n=',(a.NUM - b.NUM),')')) AS DTSTAMP, '' AS TMSTAMP FROM 
	(SELECT moduleId, refsetid, COUNT(ID) AS NUM FROM rf2_crefset GROUP BY moduleId, refsetId) a
		LEFT JOIN (SELECT moduleId, refsetid, COUNT(ID) AS NUM FROM rf2_crefset_sp GROUP BY moduleId, refsetId) b
		ON a.moduleId = b.moduleId AND a.RefsetId = b.RefsetId
LEFT JOIN rf21_concept c ON c.CONCEPTID = a.refSetId
ORDER BY ABS(a.NUM-b.NUM) DESC,a.moduleId, a.refSetID);

SET @Res = ((SELECT COUNT(ID) FROM rf2_icrefset) - (SELECT COUNT(ID) FROM rf2_icrefset_sp));
INSERT INTO IMPORTTIME_RF2 SET Event = '  rf2_icrefset snapshot', DTSTAMP = IF(@Res = 0,'SAME',CONCAT('DIFFERENT (n=',@Res,')')), TMSTAMP=CURRENT_TIME;

SET @Res = ((SELECT COUNT(ID) FROM rf2_cirefset) - (SELECT COUNT(ID) FROM rf2_cirefset_sp));
INSERT INTO IMPORTTIME_RF2 SET Event = '  rf2_cirefset snapshot', DTSTAMP = IF(@Res = 0,'SAME',CONCAT('DIFFERENT (n=',@Res,')')), TMSTAMP=CURRENT_TIME;

SET @Res = ((SELECT COUNT(ID) FROM rf2_ccirefset) - (SELECT COUNT(ID) FROM rf2_ccirefset_sp));
INSERT INTO IMPORTTIME_RF2 SET Event = '  rf2_ccirefset snapshot', DTSTAMP = IF(@Res = 0,'SAME',CONCAT('DIFFERENT (n=',@Res,')')), TMSTAMP=CURRENT_TIME;

SET @Res = ((SELECT COUNT(ID) FROM rf2_iissscrefset) - (SELECT COUNT(ID) FROM rf2_iissscrefset_sp));
INSERT INTO IMPORTTIME_RF2 SET Event = '  rf2_iissscrefset snapshot', DTSTAMP = IF(@Res = 0,'SAME',CONCAT('DIFFERENT (n=',@Res,')')), TMSTAMP=CURRENT_TIME;

SET @Res = ((SELECT COUNT(ID) FROM rf2_iissscirefset) - (SELECT COUNT(ID) FROM rf2_iissscirefset_sp));
INSERT INTO IMPORTTIME_RF2 SET Event = '  rf2_iissscirefset snapshot', DTSTAMP = IF(@Res = 0,'SAME',CONCAT('DIFFERENT (n=',@Res,')')), TMSTAMP=CURRENT_TIME;

INSERT INTO IMPORTTIME_RF2 SET Event = 'END Compare computed and received RF2 snapshot', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

END $$

DELIMITER ;
