-- Title        : SNOMED CT Release Format 2 - Load FULL Tables
-- Author       : Jeremy Rogers
-- Date         : 23rd November 2015
-- Copyright    : Crown Coyright
-- Source       : United Kingdom Terminology Centre, Data Standards and Products, NHS Technology Office
-- License      : Open Government License http://www.nationalarchives.gov.uk/doc/open-government-licence/
-- Purpose      : Load an RF2 FULL release into tables
-- 
-- 

DROP TABLE IF EXISTS IMPORTTIME_RF2;
CREATE TABLE IMPORTTIME_RF2 (Event VARCHAR(160) BINARY NOT NULL, DTSTAMP VARCHAR(25), TMSTAMP VARCHAR(8));

INSERT INTO IMPORTTIME_RF2 SET Event = 'START Import RF2', DTSTAMP = CURRENT_DATE, TMSTAMP=CURRENT_TIME;

CALL RF2_CreateTables('ALL');

INSERT INTO IMPORTTIME_RF2 SET Event = '  START Import RF2 State Valid Files', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

LOAD DATA LOCAL INFILE "tmp_extracted/sct2_Concept_Full_INT_20160131.txt" INTO TABLE rf2_concept_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA LOCAL INFILE "tmp_extracted/sct2_Description_Full-en_INT_20160131.txt" INTO TABLE rf2_term_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA LOCAL INFILE "tmp_extracted/sct2_Relationship_Full_INT_20160131.txt" INTO TABLE rf2_rel_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA LOCAL INFILE "tmp_extracted/sct2_StatedRelationship_Full_INT_20160131.txt" INTO TABLE rf2_rel_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA LOCAL INFILE "tmp_extracted/sct2_Identifier_Full_INT_20160131.txt" INTO TABLE rf2_identifier_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA LOCAL INFILE "tmp_extracted/sct2_TextDefinition_Full-en_INT_20160131.txt" INTO TABLE rf2_def_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE "tmp_extracted/der2_cRefset_AssociationReferenceFull_INT_20160131.txt" INTO TABLE rf2_crefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA LOCAL INFILE "tmp_extracted/der2_cRefset_AttributeValueFull_INT_20160131.txt" INTO TABLE rf2_crefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA LOCAL INFILE "tmp_extracted/der2_Refset_SimpleFull_INT_20160131.txt" INTO TABLE rf2_refset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE "tmp_extracted/der2_cRefset_LanguageFull-en_INT_20160131.txt" INTO TABLE rf2_crefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE "tmp_extracted/der2_sRefset_SimpleMapFull_INT_20160131.txt" INTO TABLE rf2_srefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA LOCAL INFILE "tmp_extracted/der2_iissscRefset_ComplexMapFull_INT_20160131.txt" INTO TABLE rf2_iissscrefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA LOCAL INFILE "tmp_extracted/der2_iisssccRefset_ExtendedMapFull_INT_20160131.txt" INTO TABLE rf2_iisssccrefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE "tmp_extracted/der2_cciRefset_RefsetDescriptorFull_INT_20160131.txt" INTO TABLE rf2_ccirefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA LOCAL INFILE "tmp_extracted/der2_ciRefset_DescriptionTypeFull_INT_20160131.txt" INTO TABLE rf2_cirefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA LOCAL INFILE "tmp_extracted/der2_ssRefset_ModuleDependencyFull_INT_20160131.txt" INTO TABLE rf2_ssrefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

INSERT INTO IMPORTTIME_RF2 SET Event = '  END Import RF2 State Valid Files', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

CALL RF2_CreateIndexes;
CALL ExtractSnapshot('LATEST');
CALL RF2_FixSnapshots;

# Optional QA step - compare extracted snapshot with officially distributed one
# CALL RF2_CompareSnapshots;

INSERT INTO IMPORTTIME_RF2 SET Event = 'END Import RF2', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
