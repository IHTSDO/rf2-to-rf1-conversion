
CREATE ALIAS magicNumberFor FOR "org.ihtsdo.snomed.rf2torf1conversion.RF1Constants.getMagicNumber";

CREATE ALIAS moduleSourceFor FOR "org.ihtsdo.snomed.rf2torf1conversion.RF1Constants.getModuleSource";

CREATE ALIAS statusFor FOR "org.ihtsdo.snomed.rf2torf1conversion.RF1Constants.translateActive";

CREATE ALIAS descTypeFor FOR "org.ihtsdo.snomed.rf2torf1conversion.RF1Constants.translateDescType";

CREATE ALIAS capitalStatusFor FOR "org.ihtsdo.snomed.rf2torf1conversion.RF1Constants.translateCaseSensitive";

CREATE ALIAS characteristicFor FOR "org.ihtsdo.snomed.rf2torf1conversion.RF1Constants.translateCharacteristic";

CREATE ALIAS refinabilityFor FOR "org.ihtsdo.snomed.rf2torf1conversion.RF1Constants.translateRefinability";

DROP TABLE IF EXISTS rf21_CONCEPT;
CREATE TABLE rf21_CONCEPT (
	CONCEPTID			BIGINT NOT NULL,
	CONCEPTSTATUS		TINYINT (2) UNSIGNED NOT NULL,
	FULLYSPECIFIEDNAME	VARCHAR (255), --	NOT NULL,
	CTV3ID				VARCHAR (8) NOT NULL,
	SNOMEDID			VARCHAR (8), -- NOT NULL
	ISPRIMITIVE			TINYINT (1) UNSIGNED NOT NULL,
	SOURCE				VARCHAR (18) NOT NULL);

/* Table: TERM : Table of unique Terms and their IDs*/
DROP TABLE IF EXISTS rf21_TERM;
CREATE TABLE rf21_TERM (
	DESCRIPTIONID		 BIGINT NOT NULL,
	DESCRIPTIONSTATUS		TINYINT (2) UNSIGNED, -- NOT NULL
	CONCEPTID				BIGINT NOT NULL,
	TERM					VARCHAR (255)	NOT NULL,
	INITIALCAPITALSTATUS	TINYINT (1) UNSIGNED, -- NOT NULL
	US_DESC_TYPE			TINYINT (1) UNSIGNED NOT NULL,
	GB_DESC_TYPE			TINYINT (1) UNSIGNED NOT NULL,
	LANGUAGECODE			VARCHAR (5) NOT NULL,
	SOURCE					VARCHAR (18) NOT NULL);

/* Table: DEF : Table of text definitions */
DROP TABLE IF EXISTS rf21_DEF;
CREATE TABLE rf21_DEF (
 CONCEPTID				BIGINT NOT NULL,
 SNOMEDID				VARCHAR (8), -- NOT NULL
 FULLYSPECIFIEDNAME		VARCHAR (255), --	NOT NULL,
 DEFINITION				VARCHAR (2048)	NOT NULL);

/* Table: REL : Templates*/
DROP TABLE IF EXISTS rf21_REL;
CREATE TABLE rf21_REL (
	RELATIONSHIPID		BIGINT NOT NULL,
	CONCEPTID1			BIGINT NOT NULL,
	RELATIONSHIPTYPE	BIGINT NOT NULL,
	CONCEPTID2			BIGINT NOT NULL,
	CHARACTERISTICTYPE	TINYINT (1) UNSIGNED NOT NULL,
	REFINABILITY		TINYINT (1) UNSIGNED NOT NULL,
	RELATIONSHIPGROUP	TINYINT (2) UNSIGNED NOT NULL,
	SOURCE				VARCHAR (18) NOT NULL);

DROP TABLE IF EXISTS rf21_SUBSETLIST;
CREATE TABLE rf21_SUBSETLIST (
	SubsetId			BIGINT NOT NULL,
	SubsetOriginalID	BIGINT NOT NULL,
	SubsetVersion		VARBINARY(4) NOT NULL,
	SubsetName			VARCHAR(255)	NOT NULL,
	SubsetType			TINYINT (1) UNSIGNED NOT NULL,
	LanguageCode		VARCHAR(5),
	SubsetRealmID		VARBINARY (10) NOT NULL,
	ContextID			TINYINT (1) UNSIGNED NOT NULL);

DROP TABLE IF EXISTS rf21_SUBSETS;
CREATE TABLE rf21_SUBSETS (
	SubsetId	 BIGINT NOT NULL,
	MemberID	 BIGINT NOT NULL,
	MemberStatus TINYINT (1) UNSIGNED NOT NULL,
	LinkedID	 VARCHAR(18) );

DROP TABLE IF EXISTS rf21_XMAPLIST;
CREATE TABLE rf21_XMAPLIST (
	MapSetId			BIGINT NOT NULL,
	MapSetName			VARCHAR (255)	NOT NULL,
	MapSetType			BINARY (1) NOT NULL,
	MapSetSchemeID		VARBINARY (64) NOT NULL,
	MapSetSchemeName	VARCHAR (255)	NOT NULL,
	MapSetSchemeVersion	VARBINARY(10) NOT NULL,
	MapSetRealmID		BIGINT NOT NULL,
	MapSetSeparator		BINARY (1) NOT NULL,
	MapSetRuleType		VARBINARY (2) NOT NULL);

DROP TABLE IF EXISTS rf21_XMAPS;
CREATE TABLE rf21_XMAPS (
	MapSetID		BIGINT NOT NULL,
	MapConceptID	BIGINT NOT NULL,
	MapOption		INTEGER UNSIGNED,
	MapPriority		TINYINT (1) UNSIGNED,
	MapTargetID		BIGINT NOT NULL,
	MapRule			VARCHAR(255)	NOT NULL,
	MapAdvice		VARCHAR(255)	NOT NULL);

DROP TABLE IF EXISTS rf21_XMAPTARGET;
CREATE TABLE rf21_XMAPTARGET (
	TargetID		BIGINT NOT NULL,
	TargetSchemeID 	VARCHAR (64)	NOT NULL,
	TargetCodes		VARCHAR(255) ,
	TargetRule	 	VARCHAR(255)	NOT NULL,
	TargetAdvice	VARCHAR(255)	NOT NULL);

DROP TABLE IF EXISTS rf21_REFERENCE;

CREATE TABLE rf21_REFERENCE (
	COMPONENTID		BIGINT NOT NULL,
	REFERENCETYPE	TINYINT (1) NOT NULL,
	REFERENCEDID	BIGINT NOT NULL,
	SOURCE			VARCHAR (18) NOT NULL);

DROP TABLE IF EXISTS rf21_COMPONENTHISTORY;

CREATE TABLE rf21_COMPONENTHISTORY (
	COMPONENTID		BIGINT NOT NULL,
	RELEASEVERSION	BIGINT NOT NULL,
	CHANGETYPE		TINYINT (1) NOT NULL,
	STAT			TINYINT (1) NOT NULL,
	REASON			VARCHAR(255)	NOT NULL,
	SOURCE			VARCHAR (18) NOT NULL);
	
CREATE INDEX idx_comphist_id ON rf21_COMPONENTHISTORY(COMPONENTID);
CREATE INDEX idx_comphist_et ON rf21_COMPONENTHISTORY(releaseversion);