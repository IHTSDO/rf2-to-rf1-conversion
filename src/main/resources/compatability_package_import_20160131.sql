/*
Title        : SNOMED CT Release Format 2 - Populate RF1 Schema
Author       : Jeremy Rogers
Date         : 3rd May 2015
Copyright    : Crown Coyright
Source       : United Kingdom Terminology Centre, Data Standards and Products, NHS Technology Office
License      : Open Government License http://www.nationalarchives.gov.uk/doc/open-government-licence/
Purpose      : Populate an RF1 Scheme a from an RF2 Snapshot
*/


INSERT INTO IMPORTTIME_RF2 SET Event = '  START Import RF2-RF1 Compatability Files', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

LOAD DATA LOCAL INFILE "tmp_extracted/der2_cRefset_RefinabilityFull_INT_20160131.txt" INTO TABLE rf2_crefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA LOCAL INFILE "tmp_extracted/res2_cRefset_RefinabilityFull_INT_20160131.txt" INTO TABLE rf2_crefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA LOCAL INFILE "tmp_extracted/sct2_Qualifier_Full_INT_20160131.txt" INTO TABLE rf2_rel_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

INSERT INTO IMPORTTIME_RF2 SET Event = '  END Import RF2-RF1 Compatability Files', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
