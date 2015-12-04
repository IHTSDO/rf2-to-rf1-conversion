-- Title        : SNOMED CT Release Format 2 - Load FULL Tables
-- Author       : Jeremy Rogers
-- Date         : 3rd April 2014
-- Copyright    : Crown Coyright
-- Source       : United Kingdom Terminology Centre, Data Standards and Products, NHS Technology Office
-- License      : Open Government License http://www.nationalarchives.gov.uk/doc/open-government-licence/
-- Purpose      : Load an RF2 FULL release into tables
-- 
-- 

DROP TABLE IF EXISTS snomed.IMPORTTIME_RF2;
CREATE TABLE snomed.IMPORTTIME_RF2 (Event VARCHAR(160) BINARY NOT NULL, DTSTAMP VARCHAR(25), TMSTAMP VARCHAR(8));

INSERT INTO snomed.IMPORTTIME_RF2 SET Event = 'START Import RF2', DTSTAMP = CURRENT_DATE, TMSTAMP=CURRENT_TIME;

CALL snomed.RF2_CreateTables('ALL');

INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '  START Import RF2 State Valid Files', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '    START Import IHTSDO RF2 State Valid Files', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_Release_INT_20150131/RF2Release/Full/Terminology/sct2_Concept_Full_INT_20150131.txt" INTO TABLE snomed.rf2_concept_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_Release_INT_20150131/RF2Release/Full/Terminology/sct2_Description_Full-en_INT_20150131.txt" INTO TABLE snomed.rf2_term_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_Release_INT_20150131/RF2Release/Full/Terminology/sct2_Relationship_Full_INT_20150131.txt" INTO TABLE snomed.rf2_rel_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_Release_INT_20150131/RF2Release/Full/Terminology/sct2_StatedRelationship_Full_INT_20150131.txt" INTO TABLE snomed.rf2_rel_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_Release_INT_20150131/RF2Release/Full/Terminology/sct2_Identifier_Full_INT_20150131.txt" INTO TABLE snomed.rf2_identifier_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_Release_INT_20150131/RF2Release/Full/Terminology/sct2_TextDefinition_Full-en_INT_20150131.txt" INTO TABLE snomed.rf2_def_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_Release_INT_20150131/RF2Release/Full/Refset/Content/der2_cRefset_AssociationReferenceFull_INT_20150131.txt" INTO TABLE snomed.rf2_crefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_Release_INT_20150131/RF2Release/Full/Refset/Content/der2_cRefset_AttributeValueFull_INT_20150131.txt" INTO TABLE snomed.rf2_crefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_Release_INT_20150131/RF2Release/Full/Refset/Content/der2_Refset_SimpleFull_INT_20150131.txt" INTO TABLE snomed.rf2_refset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_Release_INT_20150131/RF2Release/Full/Refset/Language/der2_cRefset_LanguageFull-en_INT_20150131.txt" INTO TABLE snomed.rf2_crefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_Release_INT_20150131/RF2Release/Full/Refset/Map/der2_sRefset_SimpleMapFull_INT_20150131.txt" INTO TABLE snomed.rf2_srefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_Release_INT_20150131/RF2Release/Full/Refset/Map/der2_iissscRefset_ComplexMapFull_INT_20150131.txt" INTO TABLE snomed.rf2_iissscrefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_Release_INT_20150131/RF2Release/Full/Refset/Map/der2_iisssccRefset_ExtendedMapFull_INT_20150131.txt" INTO TABLE snomed.rf2_iisssccrefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_Release_INT_20150131/RF2Release/Full/Refset/Metadata/der2_cciRefset_RefsetDescriptorFull_INT_20150131.txt" INTO TABLE snomed.rf2_ccirefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_Release_INT_20150131/RF2Release/Full/Refset/Metadata/der2_ciRefset_DescriptionTypeFull_INT_20150131.txt" INTO TABLE snomed.rf2_cirefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_Release_INT_20150131/RF2Release/Full/Refset/Metadata/der2_ssRefset_ModuleDependencyFull_INT_20150131.txt" INTO TABLE snomed.rf2_ssrefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '    START Import UK Clinical RF2 State Valid Files', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Full/Terminology/sct2_Concept_Full_GB1000000_20150401.txt" INTO TABLE snomed.rf2_concept_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Full/Terminology/sct2_Description_Full-en-GB_GB1000000_20150401.txt" INTO TABLE snomed.rf2_term_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Full/Terminology/sct2_Relationship_Full_GB1000000_20150401.txt" INTO TABLE snomed.rf2_rel_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
# LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Full/Terminology/sct2_StatedRelationship_Full_GB1000000_20150401.txt" INTO TABLE snomed.rf2_rel_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Full/Refset/Language/xder2_cRefset_UKExtensionLanguageFull-en-GB_GB1000000_20150401.txt" INTO TABLE snomed.rf2_crefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Full/Refset/Metadata/xder2_cRefset_MetadataLanguageFull-en-GB_GB1000000_20150401.txt" INTO TABLE snomed.rf2_crefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Full/Refset/Metadata/der2_cciRefset_RefsetDescriptorFull_GB1000000_20150401.txt" INTO TABLE snomed.rf2_ccirefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Full/Refset/Metadata/der2_ssRefset_ModuleDependencyFull_GB1000000_20150401.txt" INTO TABLE snomed.rf2_ssrefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Full/Refset/Crossmap/der2_sRefset_NHSDataModelandDictionaryAESimpleMapFull_GB1000000_20150401.txt" INTO TABLE snomed.rf2_srefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Full/Refset/Crossmap/xder2_iisssciRefset_ICD10FourthEditionComplexMapFull_GB1000000_20150401.txt" INTO TABLE snomed.rf2_iissscirefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Full/Refset/Crossmap/xder2_iisssciRefset_OPCS46ComplexMapFull_GB1000000_20150401.txt" INTO TABLE snomed.rf2_iissscirefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Full/Refset/Content/der2_cRefset_AssociationReferenceFull_GB1000000_20150401.txt" INTO TABLE snomed.rf2_crefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Full/Refset/Content/der2_cRefset_AttributeValueFull_GB1000000_20150401.txt" INTO TABLE snomed.rf2_crefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Full/Refset/Content/Administrative/xder2_icRefset_AdministrativeOrderedFull_GB1000000_20150401.txt" INTO TABLE snomed.rf2_icrefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Full/Refset/Content/CarePlanning/der2_Refset_CarePlanningSimpleFull_GB1000000_20150401.txt" INTO TABLE snomed.rf2_refset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Full/Refset/Content/CareRecordElement/der2_Refset_CareRecordElementSimpleFull_GB1000000_20150401.txt" INTO TABLE snomed.rf2_refset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Full/Refset/Content/ClinicalMessaging/xder2_Refset_ClinicalMessagingSimpleFull_GB1000000_20150401.txt" INTO TABLE snomed.rf2_refset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Full/Refset/Content/DiagnosticImagingProcedure/der2_Refset_DiagnosticImagingProcedureSimpleFull_GB1000000_20150401.txt" INTO TABLE snomed.rf2_refset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Full/Refset/Content/Endoscopy/der2_Refset_EndoscopySimpleFull_GB1000000_20150401.txt" INTO TABLE snomed.rf2_refset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Full/Refset/Content/LinkAssertion/xder2_Refset_LinkAssertionSimpleFull_GB1000000_20150401.txt" INTO TABLE snomed.rf2_refset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Full/Refset/Content/NHSRealmDescription/xder2_cRefset_NHSRealmDescriptionLanguageFull_GB1000000_20150401.txt" INTO TABLE snomed.rf2_crefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Full/Refset/Content/OccupationalTherapy/xder2_Refset_OccupationalTherapySimpleFull_GB1000000_20150401.txt" INTO TABLE snomed.rf2_refset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Full/Refset/Content/PathologyBoundedCodeList/xder2_cRefset_PathologyBoundedCodeListLanguageFull_GB1000000_20150401.txt" INTO TABLE snomed.rf2_crefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Full/Refset/Content/PathologyBoundedCodeList/xder2_Refset_PathologyBoundedCodeListSimpleFull_GB1000000_20150401.txt" INTO TABLE snomed.rf2_refset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Full/Refset/Content/PathologyCatalogue/xder2_Refset_PathologyCatalogueSimpleFull_GB1000000_20150401.txt" INTO TABLE snomed.rf2_refset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Full/Refset/Content/PublicHealthLanguage/xder2_Refset_PublicHealthLanguageSimpleFull_GB1000000_20150401.txt" INTO TABLE snomed.rf2_refset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Full/Refset/Content/Renal/der2_Refset_RenalSimpleFull_GB1000000_20150401.txt" INTO TABLE snomed.rf2_refset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Full/Refset/Content/SSERP/xder2_Refset_SSERPSimpleFull_GB1000000_20150401.txt" INTO TABLE snomed.rf2_refset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Full/Refset/Content/StandardsConsultingGroup/Religions/xder2_cRefset_ReligionsLanguageFull_GB1000000_20150401.txt" INTO TABLE snomed.rf2_crefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Full/Refset/Content/StandardsConsultingGroup/Religions/xder2_Refset_ReligionsSimpleFull_GB1000000_20150401.txt" INTO TABLE snomed.rf2_refset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '    START Import UK Drug RF2 State Valid Files', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000001_20150401/RF2Release/Full/Terminology/sct2_Concept_Full_GB1000001_20150401.txt" INTO TABLE snomed.rf2_concept_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000001_20150401/RF2Release/Full/Terminology/sct2_Description_Full-en-GB_GB1000001_20150401.txt" INTO TABLE snomed.rf2_term_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000001_20150401/RF2Release/Full/Terminology/sct2_Relationship_Full_GB1000001_20150401.txt" INTO TABLE snomed.rf2_rel_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
# LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000001_20150401/RF2Release/Full/Terminology/sct2_StatedRelationship_Full_GB1000001_20150401.txt" INTO TABLE snomed.rf2_rel_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000001_20150401/RF2Release/Full/Refset/Language/xder2_cRefset_UKDrugExtensionLanguageFull-en-GB_GB1000001_20150401.txt" INTO TABLE snomed.rf2_crefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000001_20150401/RF2Release/Full/Refset/Metadata/xder2_cRefset_MetadataLanguageFull-en-GB_GB1000001_20150401.txt" INTO TABLE snomed.rf2_crefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000001_20150401/RF2Release/Full/Refset/Metadata/der2_cciRefset_RefsetDescriptorFull_GB1000001_20150401.txt" INTO TABLE snomed.rf2_ccirefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000001_20150401/RF2Release/Full/Refset/Metadata/der2_ssRefset_ModuleDependencyFull_GB1000001_20150401.txt" INTO TABLE snomed.rf2_ssrefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000001_20150401/RF2Release/Full/Refset/Content/der2_cRefset_AssociationReferenceFull_GB1000001_20150401.txt" INTO TABLE snomed.rf2_crefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000001_20150401/RF2Release/Full/Refset/Content/der2_cRefset_AttributeValueFull_GB1000001_20150401.txt" INTO TABLE snomed.rf2_crefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000001_20150401/RF2Release/Full/Refset/Content/ClinicalMessaging/der2_Refset_ClinicalMessagingSimpleFull_GB1000001_20150401.txt" INTO TABLE snomed.rf2_refset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000001_20150401/RF2Release/Full/Refset/Content/DMD/der2_cRefset_DMDLanguageFull_GB1000001_20150401.txt" INTO TABLE snomed.rf2_crefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000001_20150401/RF2Release/Full/Refset/Content/DMD/der2_Refset_DMDSimpleFull_GB1000001_20150401.txt" INTO TABLE snomed.rf2_refset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000001_20150401/RF2Release/Full/Refset/Content/Drug/xder2_Refset_DrugSimpleFull_GB1000001_20150401.txt" INTO TABLE snomed.rf2_refset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000001_20150401/RF2Release/Full/Refset/Content/EPrescribing/xder2_Refset_EPrescribingSimpleFull_GB1000001_20150401.txt" INTO TABLE snomed.rf2_refset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000001_20150401/RF2Release/Full/Refset/Content/NHSRealmDescription/xder2_cRefset_NHSRealmDescriptionLanguageFull_GB1000001_20150401.txt" INTO TABLE snomed.rf2_crefset_sv FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;


INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '  END Import RF2 State Valid Files', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '  START Import RF2 Snapshot Files', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '    START Import IHTSDO RF2 Snapshot Files', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_Release_INT_20150131/RF2Release/Snapshot/Terminology/sct2_Concept_Snapshot_INT_20150131.txt" INTO TABLE snomed.rf2_concept_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_Release_INT_20150131/RF2Release/Snapshot/Terminology/sct2_Description_Snapshot-en_INT_20150131.txt" INTO TABLE snomed.rf2_term_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_Release_INT_20150131/RF2Release/Snapshot/Terminology/sct2_Relationship_Snapshot_INT_20150131.txt" INTO TABLE snomed.rf2_rel_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_Release_INT_20150131/RF2Release/Snapshot/Terminology/sct2_StatedRelationship_Snapshot_INT_20150131.txt" INTO TABLE snomed.rf2_rel_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_Release_INT_20150131/RF2Release/Snapshot/Terminology/sct2_Identifier_Snapshot_INT_20150131.txt" INTO TABLE snomed.rf2_identifier_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_Release_INT_20150131/RF2Release/Snapshot/Terminology/sct2_TextDefinition_Snapshot-en_INT_20150131.txt" INTO TABLE snomed.rf2_def_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_Release_INT_20150131/RF2Release/Snapshot/Refset/Content/der2_cRefset_AssociationReferenceSnapshot_INT_20150131.txt" INTO TABLE snomed.rf2_crefset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_Release_INT_20150131/RF2Release/Snapshot/Refset/Content/der2_cRefset_AttributeValueSnapshot_INT_20150131.txt" INTO TABLE snomed.rf2_crefset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_Release_INT_20150131/RF2Release/Snapshot/Refset/Content/der2_Refset_SimpleSnapshot_INT_20150131.txt" INTO TABLE snomed.rf2_refset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_Release_INT_20150131/RF2Release/Snapshot/Refset/Language/der2_cRefset_LanguageSnapshot-en_INT_20150131.txt" INTO TABLE snomed.rf2_crefset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_Release_INT_20150131/RF2Release/Snapshot/Refset/Map/der2_sRefset_SimpleMapSnapshot_INT_20150131.txt" INTO TABLE snomed.rf2_srefset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_Release_INT_20150131/RF2Release/Snapshot/Refset/Map/der2_iissscRefset_ComplexMapSnapshot_INT_20150131.txt" INTO TABLE snomed.rf2_iissscrefset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_Release_INT_20150131/RF2Release/Snapshot/Refset/Map/der2_iisssccRefset_ExtendedMapSnapshot_INT_20150131.txt" INTO TABLE snomed.rf2_iisssccrefset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_Release_INT_20150131/RF2Release/Snapshot/Refset/Metadata/der2_cciRefset_RefsetDescriptorSnapshot_INT_20150131.txt" INTO TABLE snomed.rf2_ccirefset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_Release_INT_20150131/RF2Release/Snapshot/Refset/Metadata/der2_ciRefset_DescriptionTypeSnapshot_INT_20150131.txt" INTO TABLE snomed.rf2_cirefset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_Release_INT_20150131/RF2Release/Snapshot/Refset/Metadata/der2_ssRefset_ModuleDependencySnapshot_INT_20150131.txt" INTO TABLE snomed.rf2_ssrefset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '    START Import UK Clinical RF2 Snapshot Files', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Snapshot/Terminology/sct2_Concept_Snapshot_GB1000000_20150401.txt" INTO TABLE snomed.rf2_concept_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Snapshot/Terminology/sct2_Description_Snapshot-en-GB_GB1000000_20150401.txt" INTO TABLE snomed.rf2_term_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Snapshot/Terminology/sct2_Relationship_Snapshot_GB1000000_20150401.txt" INTO TABLE snomed.rf2_rel_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
# LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Snapshot/Terminology/sct2_StatedRelationship_Snapshot_GB1000000_20150401.txt" INTO TABLE snomed.rf2_rel_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Snapshot/Refset/Language/xder2_cRefset_UKExtensionLanguageSnapshot-en-GB_GB1000000_20150401.txt" INTO TABLE snomed.rf2_crefset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Snapshot/Refset/Metadata/xder2_cRefset_MetadataLanguageSnapshot-en-GB_GB1000000_20150401.txt" INTO TABLE snomed.rf2_crefset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Snapshot/Refset/Metadata/der2_cciRefset_RefsetDescriptorSnapshot_GB1000000_20150401.txt" INTO TABLE snomed.rf2_ccirefset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Snapshot/Refset/Metadata/der2_ssRefset_ModuleDependencySnapshot_GB1000000_20150401.txt" INTO TABLE snomed.rf2_ssrefset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Snapshot/Refset/Crossmap/der2_sRefset_NHSDataModelandDictionaryAESimpleMapSnapshot_GB1000000_20150401.txt" INTO TABLE snomed.rf2_srefset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Snapshot/Refset/Crossmap/xder2_iisssciRefset_ICD10FourthEditionComplexMapSnapshot_GB1000000_20150401.txt" INTO TABLE snomed.rf2_iissscirefset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Snapshot/Refset/Crossmap/xder2_iisssciRefset_OPCS46ComplexMapSnapshot_GB1000000_20150401.txt" INTO TABLE snomed.rf2_iissscirefset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Snapshot/Refset/Content/der2_cRefset_AssociationReferenceSnapshot_GB1000000_20150401.txt" INTO TABLE snomed.rf2_crefset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Snapshot/Refset/Content/der2_cRefset_AttributeValueSnapshot_GB1000000_20150401.txt" INTO TABLE snomed.rf2_crefset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Snapshot/Refset/Content/Administrative/xder2_icRefset_AdministrativeOrderedSnapshot_GB1000000_20150401.txt" INTO TABLE snomed.rf2_icrefset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Snapshot/Refset/Content/CarePlanning/der2_Refset_CarePlanningSimpleSnapshot_GB1000000_20150401.txt" INTO TABLE snomed.rf2_refset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Snapshot/Refset/Content/CareRecordElement/der2_Refset_CareRecordElementSimpleSnapshot_GB1000000_20150401.txt" INTO TABLE snomed.rf2_refset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Snapshot/Refset/Content/ClinicalMessaging/xder2_Refset_ClinicalMessagingSimpleSnapshot_GB1000000_20150401.txt" INTO TABLE snomed.rf2_refset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Snapshot/Refset/Content/DiagnosticImagingProcedure/der2_Refset_DiagnosticImagingProcedureSimpleSnapshot_GB1000000_20150401.txt" INTO TABLE snomed.rf2_refset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Snapshot/Refset/Content/Endoscopy/der2_Refset_EndoscopySimpleSnapshot_GB1000000_20150401.txt" INTO TABLE snomed.rf2_refset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Snapshot/Refset/Content/LinkAssertion/xder2_Refset_LinkAssertionSimpleSnapshot_GB1000000_20150401.txt" INTO TABLE snomed.rf2_refset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Snapshot/Refset/Content/NHSRealmDescription/xder2_cRefset_NHSRealmDescriptionLanguageSnapshot_GB1000000_20150401.txt" INTO TABLE snomed.rf2_crefset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Snapshot/Refset/Content/OccupationalTherapy/xder2_Refset_OccupationalTherapySimpleSnapshot_GB1000000_20150401.txt" INTO TABLE snomed.rf2_refset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Snapshot/Refset/Content/PathologyBoundedCodeList/xder2_cRefset_PathologyBoundedCodeListLanguageSnapshot_GB1000000_20150401.txt" INTO TABLE snomed.rf2_crefset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Snapshot/Refset/Content/PathologyBoundedCodeList/xder2_Refset_PathologyBoundedCodeListSimpleSnapshot_GB1000000_20150401.txt" INTO TABLE snomed.rf2_refset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Snapshot/Refset/Content/PathologyCatalogue/xder2_Refset_PathologyCatalogueSimpleSnapshot_GB1000000_20150401.txt" INTO TABLE snomed.rf2_refset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Snapshot/Refset/Content/PublicHealthLanguage/xder2_Refset_PublicHealthLanguageSimpleSnapshot_GB1000000_20150401.txt" INTO TABLE snomed.rf2_refset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Snapshot/Refset/Content/Renal/der2_Refset_RenalSimpleSnapshot_GB1000000_20150401.txt" INTO TABLE snomed.rf2_refset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Snapshot/Refset/Content/SSERP/xder2_Refset_SSERPSimpleSnapshot_GB1000000_20150401.txt" INTO TABLE snomed.rf2_refset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Snapshot/Refset/Content/StandardsConsultingGroup/Religions/xder2_cRefset_ReligionsLanguageSnapshot_GB1000000_20150401.txt" INTO TABLE snomed.rf2_crefset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000000_20150401/RF2Release/Snapshot/Refset/Content/StandardsConsultingGroup/Religions/xder2_Refset_ReligionsSimpleSnapshot_GB1000000_20150401.txt" INTO TABLE snomed.rf2_refset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '    START Import UK Drug RF2 Snapshot Files', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000001_20150401/RF2Release/Snapshot/Terminology/sct2_Concept_Snapshot_GB1000001_20150401.txt" INTO TABLE snomed.rf2_concept_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000001_20150401/RF2Release/Snapshot/Terminology/sct2_Description_Snapshot-en-GB_GB1000001_20150401.txt" INTO TABLE snomed.rf2_term_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000001_20150401/RF2Release/Snapshot/Terminology/sct2_Relationship_Snapshot_GB1000001_20150401.txt" INTO TABLE snomed.rf2_rel_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
# LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000001_20150401/RF2Release/Snapshot/Terminology/sct2_StatedRelationship_Snapshot_GB1000001_20150401.txt" INTO TABLE snomed.rf2_rel_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000001_20150401/RF2Release/Snapshot/Refset/Language/xder2_cRefset_UKDrugExtensionLanguageSnapshot-en-GB_GB1000001_20150401.txt" INTO TABLE snomed.rf2_crefset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000001_20150401/RF2Release/Snapshot/Refset/Metadata/xder2_cRefset_MetadataLanguageSnapshot-en-GB_GB1000001_20150401.txt" INTO TABLE snomed.rf2_crefset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000001_20150401/RF2Release/Snapshot/Refset/Metadata/der2_cciRefset_RefsetDescriptorSnapshot_GB1000001_20150401.txt" INTO TABLE snomed.rf2_ccirefset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000001_20150401/RF2Release/Snapshot/Refset/Metadata/der2_ssRefset_ModuleDependencySnapshot_GB1000001_20150401.txt" INTO TABLE snomed.rf2_ssrefset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000001_20150401/RF2Release/Snapshot/Refset/Content/der2_cRefset_AssociationReferenceSnapshot_GB1000001_20150401.txt" INTO TABLE snomed.rf2_crefset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000001_20150401/RF2Release/Snapshot/Refset/Content/der2_cRefset_AttributeValueSnapshot_GB1000001_20150401.txt" INTO TABLE snomed.rf2_crefset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000001_20150401/RF2Release/Snapshot/Refset/Content/ClinicalMessaging/der2_Refset_ClinicalMessagingSimpleSnapshot_GB1000001_20150401.txt" INTO TABLE snomed.rf2_refset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000001_20150401/RF2Release/Snapshot/Refset/Content/DMD/der2_cRefset_DMDLanguageSnapshot_GB1000001_20150401.txt" INTO TABLE snomed.rf2_crefset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000001_20150401/RF2Release/Snapshot/Refset/Content/DMD/der2_Refset_DMDSimpleSnapshot_GB1000001_20150401.txt" INTO TABLE snomed.rf2_refset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000001_20150401/RF2Release/Snapshot/Refset/Content/Drug/xder2_Refset_DrugSimpleSnapshot_GB1000001_20150401.txt" INTO TABLE snomed.rf2_refset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000001_20150401/RF2Release/Snapshot/Refset/Content/EPrescribing/xder2_Refset_EPrescribingSimpleSnapshot_GB1000001_20150401.txt" INTO TABLE snomed.rf2_refset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE "F:/Terminologies/SNOMED/Content Releases/2015a/SnomedCT_GB1000001_20150401/RF2Release/Snapshot/Refset/Content/NHSRealmDescription/xder2_cRefset_NHSRealmDescriptionLanguageSnapshot_GB1000001_20150401.txt" INTO TABLE snomed.rf2_crefset_sp FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '  END Import RF2 Snapshot Files', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

INSERT INTO snomed.IMPORTTIME_RF2 SET Event = '  END Import RF2 State Valid Files', DTSTAMP = '', TMSTAMP=CURRENT_TIME;

CALL snomed.RF2_CreateIndexes;
CALL snomed.ExtractSnapshot('20151001');
CALL snomed.RF2_FixSnapshots;

# Optional QA step - compare extracted snapshot with officially distributed one
CALL snomed.RF2_CompareSnapshots;

DROP TABLE IF EXISTS snomed.IMPORTTIME_RF2;
CREATE TABLE snomed.IMPORTTIME_RF2 (Event VARCHAR(160) BINARY NOT NULL, DTSTAMP VARCHAR(25), TMSTAMP VARCHAR(8));

INSERT INTO snomed.IMPORTTIME_RF2 SET Event = 'END Import RF2', DTSTAMP = '', TMSTAMP=CURRENT_TIME;
