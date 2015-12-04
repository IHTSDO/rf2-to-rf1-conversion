/*
Title        : SNOMED CT Release Format 2 - Populate RF1 Schema
Author       : Jeremy Rogers
Date         : 3rd May 2015
Copyright    : Crown Coyright
Source       : United Kingdom Terminology Centre, Data Standards and Products, NHS Technology Office
License      : Open Government License http://www.nationalarchives.gov.uk/doc/open-government-licence/
Purpose      : Populate an RF1 Scheme a from an RF2 Snapshot
*/

INSERT INTO snomed.IMPORTTIME_RF2 SET Event = 'START Populate RF1 from RF2', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '  START Import RF2-RF1 Compatability Files', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/RF2/compatpkg/Full/der2_cRefset_RefinabilityFull_INT_20140731.txt" INTO TABLE snomed.rf2_crefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/RF2/compatpkg/Full/res2_cRefset_RefinabilityFull_INT_20140731.txt" INTO TABLE snomed.rf2_crefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/RF2/compatpkg/Full/sct2_Qualifier_Full_INT_20140731.txt" INTO TABLE snomed.rf2_rel_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/Current/SnomedCT_GB1000000_20140401/RF2Release/Resources/xres_UKTCRF1SubsetToRF2ReferenceSetMapping_GB1000000_20140401.txt" INTO TABLE snomed.RF2_SUBSET2REFSET FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/Current/SnomedCT_GB1000001_20140401/RF2Release/Resources/xres_UKTCRF1SubsetToRF2ReferenceSetMapping_GB1000001_20140401.txt" INTO TABLE snomed.RF2_SUBSET2REFSET FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '  END Import RF2-RF1 Compatability Files', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

CALL snomed.RF2_PopulateRF1;
CALL snomed.RF2_RF1SnapshotQA;

INSERT INTO snomed.IMPORTTIME_RF2 SET Event = 'END Populate RF1 from RF2', DTSTAMP = '', TMSTAMP=CURRENT_TIME;