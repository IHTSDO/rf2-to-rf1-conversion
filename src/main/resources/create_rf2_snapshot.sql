
INSERT INTO rf2_concept
SELECT * FROM rf2_concept_sv s
WHERE s.effectiveTime =
  (SELECT MAX(sv.effectiveTime) AS LatestDate FROM rf2_concept_sv AS sv
   WHERE sv.id=s.id AND sv.effectiveTime <= @RDATE);

INSERT INTO rf2_term
SELECT * FROM rf2_term_sv s
WHERE s.effectiveTime =
  (SELECT MAX(sv.effectiveTime) AS LatestDate FROM rf2_term_sv AS sv
   WHERE sv.id=s.id AND sv.effectiveTime <= @RDATE);

INSERT INTO rf2_def
SELECT * FROM rf2_def_sv s
WHERE s.effectiveTime =
  (SELECT MAX(sv.effectiveTime) AS LatestDate FROM rf2_def_sv AS sv
   WHERE sv.id=s.id AND sv.effectiveTime <= @RDATE);

INSERT INTO rf2_rel
SELECT * FROM rf2_rel_sv s
WHERE s.active = 1 AND s.effectiveTime =
  (SELECT MAX(sv.effectiveTime) AS LatestDate FROM rf2_rel_sv AS sv
   WHERE sv.id=s.id AND sv.effectiveTime <= @RDATE);

INSERT INTO rf2_identifier
SELECT * FROM rf2_identifier_sv s
WHERE s.effectiveTime =
  (SELECT MAX(sv.effectiveTime) AS LatestDate
   FROM rf2_identifier_sv AS sv
   WHERE s.referencedComponentId = sv.referencedComponentId AND s.identifierSchemeId = sv.identifierSchemeId
   AND s.effectiveTime <= @RDATE);

INSERT INTO rf2_refset
SELECT * FROM rf2_refset_sv s
WHERE s.effectiveTime =
  (SELECT MAX(sv.effectiveTime) AS LatestDate FROM rf2_refset_sv AS sv
   WHERE sv.id=s.id AND sv.effectiveTime <= @RDATE);

INSERT INTO rf2_crefset
SELECT * FROM rf2_crefset_sv s
WHERE s.effectiveTime =
  (SELECT MAX(sv.effectiveTime) AS LatestDate FROM rf2_crefset_sv AS sv
   WHERE sv.id=s.id AND sv.effectiveTime <= @RDATE);

INSERT INTO rf2_icrefset
SELECT * FROM rf2_icrefset_sv s
WHERE s.effectiveTime =
  (SELECT MAX(sv.effectiveTime) AS LatestDate FROM rf2_icrefset_sv AS sv
   WHERE sv.id=s.id AND sv.effectiveTime <= @RDATE);

INSERT INTO rf2_srefset
SELECT * FROM rf2_srefset_sv s
WHERE s.effectiveTime =
  (SELECT MAX(sv.effectiveTime) AS LatestDate FROM rf2_srefset_sv AS sv
   WHERE sv.id=s.id AND sv.effectiveTime <= @RDATE);

INSERT INTO rf2_cirefset
SELECT * FROM rf2_cirefset_sv s
WHERE s.effectiveTime =
  (SELECT MAX(sv.effectiveTime) AS LatestDate FROM rf2_cirefset_sv AS sv
   WHERE sv.id=s.id AND sv.effectiveTime <= @RDATE);

INSERT INTO rf2_ccirefset
SELECT * FROM rf2_ccirefset_sv s
WHERE s.effectiveTime =
  (SELECT MAX(sv.effectiveTime) AS LatestDate FROM rf2_ccirefset_sv AS sv
   WHERE sv.id=s.id AND sv.effectiveTime <= @RDATE);

INSERT INTO rf2_ssrefset
SELECT * FROM rf2_ssrefset_sv s
WHERE s.effectiveTime =
  (SELECT MAX(sv.effectiveTime) AS LatestDate FROM rf2_ssrefset_sv AS sv
   WHERE sv.id=s.id AND sv.effectiveTime <= @RDATE);

INSERT INTO rf2_iissscrefset
SELECT * FROM rf2_iissscrefset_sv s
WHERE s.effectiveTime =
  (SELECT MAX(sv.effectiveTime) AS LatestDate FROM rf2_iissscrefset_sv AS sv
   WHERE sv.id=s.id AND sv.effectiveTime <= @RDATE);

INSERT INTO rf2_iissscirefset
SELECT * FROM rf2_iissscirefset_sv s
WHERE s.effectiveTime =
  (SELECT MAX(sv.effectiveTime) AS LatestDate FROM rf2_iissscirefset_sv AS sv
   WHERE sv.id=s.id AND sv.effectiveTime <= @RDATE);

CREATE INDEX idx_concept_id ON rf2_concept(ID);
CREATE INDEX idx_concept_dsid ON rf2_concept(definitionStatusId);
CREATE INDEX idx_term_cid ON rf2_term(conceptId);
CREATE INDEX idx_term_t ON rf2_term(Term);
CREATE INDEX idx_rel_sid ON rf2_rel(sourceId);
CREATE INDEX idx_rel_tid ON rf2_rel(typeId);
CREATE INDEX idx_rel_did ON rf2_rel(destinationId);
CREATE INDEX idx_rel_ctid ON rf2_rel(characteristicTypeId);
CREATE INDEX idx_ref_ref ON rf2_refset(refsetId);
CREATE INDEX idx_cref_ref ON rf2_crefset(refsetId);
CREATE INDEX idx_icref_ref ON rf2_icrefset(refsetId);
CREATE INDEX idx_sref_ref ON rf2_srefset(refsetId);
CREATE INDEX idx_sref_rci ON rf2_srefset(referencedComponentId);

CREATE INDEX idx_cciref_ref ON rf2_ccirefset(refsetId);
CREATE INDEX idx_ciref_ref ON rf2_cirefset(refsetId);
CREATE INDEX idx_ssref_ref ON rf2_ssrefset(refsetId);
CREATE INDEX idx_iisssref_ref ON rf2_iissscrefset(refsetId);
CREATE INDEX idx_iisssciref_ref ON rf2_iissscirefset(refsetId);
CREATE INDEX idx_ref_rci ON rf2_refset(referencedComponentId);
CREATE INDEX idx_cref_rci ON rf2_crefset(referencedComponentId);
CREATE INDEX idx_icref_rci ON rf2_icrefset(referencedComponentId);

CREATE INDEX idx_cciref_rci ON rf2_ccirefset(referencedComponentId);
CREATE INDEX idx_ciref_rci ON rf2_cirefset(referencedComponentId);
CREATE INDEX idx_ssref_rci ON rf2_ssrefset(referencedComponentId);
CREATE INDEX idx_iissscref_rci ON rf2_iissscrefset(referencedComponentId);
CREATE INDEX idx_iisssciref_rci ON rf2_iissscirefset(referencedComponentId);
CREATE INDEX idx_cref_lci ON rf2_crefset(linkedComponentId);
CREATE INDEX idx_ciref_lci ON rf2_cirefset(linkedComponentId);
CREATE INDEX idx_cciref_lci1 ON rf2_ccirefset(linkedComponentId1);
CREATE INDEX idx_cciref_lci2 ON rf2_ccirefset(linkedComponentId2);
CREATE INDEX idx_iissscref_ci ON rf2_iissscrefset(corelationID);
CREATE INDEX idx_iisssciref_ci ON rf2_iissscirefset(corelationID);

-- INSERT INTO IMPORTTIME_RF2 SET Event = 'START Clean up imported merger of edition snapshots', DTSTAMP = '', TMSTAMP=CURRENT_TIME

DROP TABLE IF EXISTS rf2_temp;
CREATE TABLE rf2_temp (id VARCHAR(38) NOT NULL);

DROP TABLE IF EXISTS rf2_temp2;
CREATE TABLE rf2_temp2 (
	  id VARCHAR(38) NOT NULL,  /* UUID instead of MemberID */
	  effectiveTime VARBINARY(14) NOT NULL,
	  active BOOLEAN NOT NULL,
	  moduleId VARBINARY(18) NOT NULL,
	  refSetId VARBINARY(18) NOT NULL,  /* From metadata hierarchy */
	  referencedComponentId VARBINARY(18) NOT NULL,
	  linkedComponentId VARBINARY(18) NOT NULL);

-- Identify cResfet components for which the union of snapshot files contains more than one row
INSERT INTO rf2_temp (SELECT id FROM rf2_crefset_sp GROUP BY id HAVING COUNT(referencedComponentId) > 1);
CREATE INDEX idx_temp_id ON rf2_temp(id);

-- Retrieve all imported snapshot rows relating to these duplicates
INSERT INTO rf2_temp2 SELECT r.* FROM rf2_crefset_sp r INNER JOIN rf2_temp t ON r.id = t.id;
CREATE INDEX idx_temp2_id ON rf2_temp2(id);

-- Discard all but the newest row
DELETE FROM rf2_temp2 a WHERE
( 
	SELECT TRUE from rf2_temp2 b 
	WHERE a.id = b.id 
	AND a.effectiveTime < b.effectiveTime
);

-- Back in the imported Snapshot file table, discard rows that predating the newest row
DELETE FROM rf2_crefset_sp sp WHERE
(
	SELECT TRUE FROM rf2_temp2 t 
	WHERE sp.ID = t.ID 
	AND sp.effectiveTime <> t.effectiveTime
);

DROP TABLE IF EXISTS rf2_temp;
CREATE TABLE rf2_temp (id VARCHAR(38) NOT NULL);

DROP TABLE IF EXISTS rf2_temp2;
CREATE TABLE rf2_temp2 (
	  id VARCHAR(38) NOT NULL,  /* UUID instead of MemberID */
	  effectiveTime VARBINARY(14) NOT NULL,
	  active BOOLEAN NOT NULL,
	  moduleId VARBINARY(18) NOT NULL,
	  refSetId VARBINARY(18) NOT NULL,  /* From metadata hierarchy */
	  referencedComponentId VARBINARY(18) NOT NULL,
	  linkedComponentId VARBINARY(18) NOT NULL);

-- Identify cResfet components for which the union of snapshot files contains more than one row
INSERT INTO rf2_temp (SELECT id FROM rf2_crefset GROUP BY id HAVING COUNT(referencedComponentId) > 1);
CREATE INDEX idx_temp_id ON rf2_temp(id);

-- Retrieve all imported snapshot rows relating to these duplicates
INSERT INTO rf2_temp2 SELECT r.* FROM rf2_crefset_sp r INNER JOIN rf2_temp t ON r.id = t.id;
CREATE INDEX idx_temp2_id ON rf2_temp2(id);

-- Discard rows stating descriptionId is acceptable where another row says it is preferred
DELETE FROM rf2_temp2 a WHERE
(
	SELECT TRUE from rf2_temp2 b
	WHERE a.id = b.id
	AND a.effectiveTime = b.effectiveTime 
	AND a.linkedComponentId = '900000000000549004'
	AND b.linkedComponentId = '900000000000548007'
);

DELETE FROM rf2_crefset a WHERE
(
	SELECT TRUE from rf2_temp2 b
	WHERE a.ID = b.ID
	AND a.linkedComponentId <> b.linkedComponentId
);

DROP TABLE IF EXISTS rf2_temp;
DROP TABLE IF EXISTS rf2_temp2;



