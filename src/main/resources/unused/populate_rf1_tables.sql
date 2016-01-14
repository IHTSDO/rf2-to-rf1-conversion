/*
Title        : SNOMED CT Release Format 2 - Populate RF1 Schema
Author       : Jeremy Rogers
Date         : 3rd May 2015
Copyright    : Crown Copyright
Source       : United Kingdom Terminology Centre, Data Standards and Products, NHS Technology Office
License      : Open Government License http://www.nationalarchives.gov.uk/doc/open-government-licence/
Purpose      : Populate an RF1 Scheme a from an RF2 Snapshot
*/

INSERT INTO IMPORTTIME_RF2 SET Event = 'START Populate RF1 from RF2', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

-- Original SubsetIds are not known in RF2, so we need to populate those
insert into RF2_subset2refset (originalSubsetId, SubsetName, RefsetId) 
values (100032, "GB English Language reference set", 900000000000508004);

insert into RF2_subset2refset (originalSubsetId, SubsetName, RefsetId) 
values (100033, "US English Language reference set", 900000000000509007);

CALL RF2_PopulateRF1;
-- CALL RF2_RF1SnapshotQA;

INSERT INTO IMPORTTIME_RF2 SET Event = 'END Populate RF1 from RF2', DTSTAMP = '', TMSTAMP=CURRENT_TIME;