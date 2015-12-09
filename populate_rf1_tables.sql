/*
Title        : SNOMED CT Release Format 2 - Populate RF1 Schema
Author       : Jeremy Rogers
Date         : 3rd May 2015
Copyright    : Crown Coyright
Source       : United Kingdom Terminology Centre, Data Standards and Products, NHS Technology Office
License      : Open Government License http://www.nationalarchives.gov.uk/doc/open-government-licence/
Purpose      : Populate an RF1 Scheme a from an RF2 Snapshot
*/

INSERT INTO IMPORTTIME_RF2 SET Event = 'START Populate RF1 from RF2', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

CALL RF2_PopulateRF1;
-- CALL RF2_RF1SnapshotQA;

INSERT INTO IMPORTTIME_RF2 SET Event = 'END Populate RF1 from RF2', DTSTAMP = '', TMSTAMP=CURRENT_TIME;