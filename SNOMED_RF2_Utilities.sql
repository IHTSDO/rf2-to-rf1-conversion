/*
Title        : SNOMED CT Release Format 2 - RF2 Utilities
Author       : Jeremy Rogers
Date         : 3rd April 2014
Copyright    : Crown Coyright
Source       : United Kingdom Terminology Centre, Data Standards and Products, NHS Technology Office
License      : Open Government License http://www.nationalarchives.gov.uk/doc/open-government-licence/
Purpose      : Extract an RF2 Snapshot from the FULL Tables
*/

DELIMITER $$

DROP FUNCTION IF EXISTS `snomed`.`RF2_ModuleSourceFor` $$
CREATE FUNCTION snomed.RF2_ModuleSourceFor(ID VARBINARY(18))
RETURNS CHAR(4)
BEGIN

  DECLARE Source CHAR(4);

  SET Source = (SELECT CASE ID
    WHEN '900000000000207008' THEN 'CORE' /* SNOMED CT core module (core metadata concept) */
    WHEN '900000000000012004' THEN 'META' /* SNOMED CT model component module (core metadata concept) */
    WHEN '999000011000000103' THEN 'UKEX' /* SNOMED CT United Kingdom clinical extension module (core metadata concept) */
    WHEN '999000011000001104' THEN 'UKDG' /* SNOMED CT United Kingdom drug extension module (core metadata concept) */
    WHEN '999000021000000109' THEN 'UKXR' /* SNOMED CT United Kingdom clinical extension reference set module (core metadata concept) */
    WHEN '999000021000001108' THEN 'UKDR' /* SNOMED CT United Kingdom pharmacy extension reference set module (core metadata concept) */
    ELSE 'ERRR'
  END);

  RETURN Source;
END $$

DROP FUNCTION IF EXISTS `snomed`.`RF2_RefSetInfo` $$
CREATE FUNCTION snomed.RF2_RefSetInfo(refSetID VARCHAR(18)) RETURNS VARCHAR(2048) CHARACTER SET utf8 COLLATE utf8_bin
BEGIN

  DECLARE Res VARCHAR(2048) CHARACTER SET utf8 COLLATE utf8_bin;
  DECLARE str VARCHAR(2048) CHARACTER SET utf8 COLLATE utf8_bin;
  DECLARE Field, strDataType VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_bin;
  DECLARE DataType, RefSetType VARCHAR(30);
  DECLARE num, done TINYINT DEFAULT 0;

  DECLARE SCT CURSOR FOR SELECT id1.TERM AS Field, linkedComponentID2 As DataType, id2.TERM As strDataType FROM snomed.rf2_ccirefset
	INNER JOIN snomed.rf2_term id1 ON id1.conceptId = linkedComponentID1 AND id1.typeId = '900000000000013009'
	INNER JOIN snomed.rf2_term id2 ON id2.conceptId = linkedComponentID2 AND id2.typeId = '900000000000013009'
	WHERE ReferencedComponentId = @RefSetID ORDER BY linkedInteger ASC;
  DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;

  -- Retrieves column order and datatypes for a given refset
  -- SET @RefsetId = 'someId';
  -- SELECT ReferencedComponentId as RefsetId, id1.TERM AS Field, id2.TERM As strDataType, linkedInteger As FieldOrder FROM snomed.rf2_ccirefset
  -- 	INNER JOIN snomed.rf2_term id1 ON id1.conceptId = linkedComponentID1 AND id1.typeId = '900000000000013009'
  -- 	INNER JOIN snomed.rf2_term id2 ON id2.conceptId = linkedComponentID2 AND id2.typeId = '900000000000013009'
  -- 	WHERE ReferencedComponentId = @RefsetId ORDER BY linkedInteger ASC;

  SET @RefSetID = refSetID;
  SET Res = CONCAT(@RefSetID, ' not recognised as a RefSet identifier');
  SET RefSetType = '';

  SET str = (SELECT MAX(TERM) FROM snomed.rf2_term WHERE conceptId = @RefSetID AND typeId = '900000000000013009');

  IF NOT (str IS NULL) THEN
  	SET str = CONCAT(@RefSetID,' ',str,' ::');

  	SET num = (SELECT COUNT(refSetID) FROM snomed.rf2_ccirefset WHERE ReferencedComponentId = @RefSetID);
  	IF num > 0 THEN
  		OPEN SCT;
  		REPEAT
  			FETCH SCT INTO Field, DataType, strDataType;
  			SET str = CONCAT(str,'|',Field);
  			SET RefSetType = CONCAT(RefSetType, (SELECT CASE DataType
  				WHEN '900000000000460005' THEN 'c' # Component type (foundation metadata concept)
  				WHEN '900000000000461009' THEN 'c' # Concept type component (foundation metadata concept)
  				WHEN '900000000000462002' THEN 'c' # Description type component (foundation metadata concept)
  				WHEN '900000000000464001' THEN 'c' # Reference set member type component (foundation metadata concept)
  				WHEN '900000000000463007' THEN 'c' # Relationship type component (foundation metadata concept)

  				WHEN '900000000000476001' THEN 'i' # Integer (foundation metadata concept)
  				WHEN '900000000000477005' THEN 'i' # Signed integer (foundation metadata concept)
  				WHEN '900000000000478000' THEN 'i' # Unsigned integer (foundation metadata concept)

  				WHEN '900000000000465000' THEN 's' # String (foundation metadata concept)
	  			WHEN '900000000000466004' THEN 's' # Text (foundation metadata concept)
  				WHEN '900000000000467008' THEN 's' # Single character (foundation metadata concept)
  				WHEN '900000000000468003' THEN 's' # Text less than 256 bytes (foundation metadata concept)
  				WHEN '900000000000475002' THEN 's' # Time (foundation metadata concept)
  				WHEN '900000000000469006' THEN 's' # Uniform resource locator (foundation metadata concept)
  				WHEN '900000000000470007' THEN 's' # Hypertext Markup Language reference (foundation metadata concept)
  				WHEN '900000000000471006' THEN 's' # Image reference (foundation metadata concept)
  				WHEN '900000000000473009' THEN 's' # Graphics Interchange Format reference (foundation metadata concept)
  				WHEN '900000000000472004' THEN 's' # Joint Photographic Experts Group format reference (foundation metadata concept)
  				WHEN '900000000000474003' THEN 's' # Universally Unique Identifier (foundation metadata concept)
  				END));
  			SET num = num - 1;
  		UNTIL num < 1
  		END REPEAT;
  		CLOSE SCT;
  	ELSE
  		SET str = CONCAT(str,'|No entries in RefSet Description RefSet !');
  	END IF;
  END IF;

    SET RefSetType = RIGHT(RefSetType, LENGTH(RefSetType) -1);
  RETURN CONCAT(RefSetType,'refset:',str,'|');

END $$

DELIMITER ;