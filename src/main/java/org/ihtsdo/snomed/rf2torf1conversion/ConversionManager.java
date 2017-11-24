package org.ihtsdo.snomed.rf2torf1conversion;

import static org.ihtsdo.snomed.rf2torf1conversion.GlobalUtils.*;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Scanner;
import java.util.Set;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.lang.reflect.Type;
import java.nio.charset.StandardCharsets;
import java.nio.file.Path;
import java.nio.file.Paths;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.filefilter.WildcardFileFilter;
import org.ihtsdo.snomed.rf2torf1conversion.pojo.Concept;
import org.ihtsdo.snomed.rf2torf1conversion.pojo.ConceptDeserializer;
import org.ihtsdo.snomed.rf2torf1conversion.pojo.LateralityIndicator;
import org.ihtsdo.snomed.rf2torf1conversion.pojo.QualifyingRelationshipAttribute;
import org.ihtsdo.snomed.rf2torf1conversion.pojo.QualifyingRelationshipRule;
import org.ihtsdo.snomed.rf2torf1conversion.pojo.RF1SchemaConstants;
import org.ihtsdo.snomed.rf2torf1conversion.pojo.RF2SchemaConstants;

import com.google.common.base.Stopwatch;
import com.google.common.io.Files;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

public class ConversionManager implements RF2SchemaConstants, RF1SchemaConstants {

	File intRf2Archive;
	File extRf2Archive;
	File unzipLocation = null;
	File additionalFilesLocation = null;
	File previousRF1Location;
	boolean useRelationshipIds = false;
	DBManager db;
	String intReleaseDate;
	String extReleaseDate;
	boolean includeHistory = true; 
	boolean includeAllQualifyingRelationships = false;
	boolean includeLateralityIndicators = true;  //Laterality is now obligatory
	boolean isBeta = false;
	boolean onlyHistory = false;
	boolean isExtension = false;
	boolean goInteractive = false;
	boolean isSnapshotConversion = false;
	Edition edition;
	private String EXT = "EXT";
	private String LNG = "LNG";
	private String MOD = "MOD";
	private String DATE = "DATE";
	private String OUT = "OUT";
	private String TYPE = "TYPE";
	private String outputFolderTemplate = "SnomedCT_OUT_MOD_DATE";
	private String ANCIENT_HISTORY = "/sct1_ComponentHistory_Core_INT_20130731.txt";
	private String QUALIFYING_RULES = "/qualifying_relationship_rules.json";
	private String AVAILABLE_SUBSET_IDS = "/available_sctids_partition_03.txt";
	private String AVAILABLE_RELATIONSHIP_IDS = "/available_sctids_partition_02.txt";
	private String RELATIONSHIP_FILENAME = "SnomedCT_OUT_MOD_DATE/Terminology/Content/sct1_Relationships_Core_MOD_DATE.txt";
	private String BETA_PREFIX = "x";
	Set<File> filesLoaded = new HashSet<File>();
	private Long[] subsetIds;
	private Long maxPreviousSubsetId = null;
	private int  previousSubsetVersion = 29;  //Taken from 20160131 RF1 International Release
	private static final String RELEASE_NOTES = "SnomedCTReleaseNotes";
	private static final String DOCUMENTATION_DIR = "Documentation/";
	private static final String LATERALITY_SNAPSHOT_TEMPLATE = "der2_Refset_SimpleSnapshot_MOD_DATE.txt";
	private static final int SUFFICIENT_LATERALITY_DATA = 10;
	
	enum Edition { INTERNATIONAL, SPANISH, US, SG };
	
	class Dialect {
		String langRefSetId;
		String langCode;
		Dialect (String langRefSetId, String langCode) {
			this.langRefSetId = langRefSetId;
			this.langCode = langCode;
		}
	}

	public final Dialect dialectSg = new Dialect ("9011000132109","sg");  //Singapore English
	public final Dialect dialectEs = new Dialect ("450828004","es");  //Latin American Spanish
	public final Dialect dialectGb = new Dialect ("900000000000508004","en-GB");
	public final Dialect dialectUs = new Dialect ("900000000000509007","en-US");
	
	class EditionConfig {
		String editionName;
		String langCode;
		String module;
		String outputName;
		boolean historyAvailable;
		Dialect[] dialects;
		EditionConfig (String editionName, String language, String module, String outputName, boolean historyAvailable, Dialect[] dialects) {
			this.editionName = editionName;
			this.outputName = outputName;
			this.langCode = language;
			this.module = module;
			this.historyAvailable = historyAvailable;
			this.dialects = dialects;
		}
	}
	
	private static final String EDITION_DETERMINER = "sct2_Description_EXTTYPE-LNG_MOD_DATE.txt";
	
	static Map<Edition, EditionConfig> knownEditionMap = new HashMap<Edition, EditionConfig>();
	{
		//Edition Config values: editionName, language, module, outputName, dialects[]
		knownEditionMap.put(Edition.INTERNATIONAL, new EditionConfig("", "en", "INT", "RF1Release", true, new Dialect[]{dialectGb, dialectUs}));   //International Edition has no Extension name
		knownEditionMap.put(Edition.SPANISH, new EditionConfig("SpanishExtension", "es", "INT", "SpanishRelease-es", true ,new Dialect[]{dialectEs}));
		knownEditionMap.put(Edition.US, new EditionConfig("", "en", "US1000124", "RF1Release", false, new Dialect[]{dialectGb, dialectUs}));
		knownEditionMap.put(Edition.SG, new EditionConfig("", "en-SG", "SG1000132", "RF1Release", true, new Dialect[]{dialectGb, dialectUs, dialectSg}));
	}
	
	static Map<String, String> editionfileToTable = new HashMap<String, String>();
	{
		editionfileToTable.put("sct2_Concept_EXTTYPE_MOD_DATE.txt", "rf2_concept_sv");
		editionfileToTable.put("sct2_Relationship_EXTTYPE_MOD_DATE.txt", "rf2_rel_sv");
		editionfileToTable.put("sct2_StatedRelationship_EXTTYPE_MOD_DATE.txt", "rf2_rel_sv");
		editionfileToTable.put("sct2_Identifier_EXTTYPE_MOD_DATE.txt", "rf2_identifier_sv");
		//Extensions can use a mix of International and their own descriptions
		editionfileToTable.put(EDITION_DETERMINER, "rf2_term_sv");
		
		//We need to know the International Preferred Term if the Extension doesn't specify one
		editionfileToTable.put("der2_cRefset_LanguageEXTTYPE-LNG_MOD_DATE.txt", "rf2_crefset_sv");
		
		//Concepts still need inactivation reasons from the International Edition
		editionfileToTable.put("der2_cRefset_AssociationReferenceEXTTYPE_MOD_DATE.txt", "rf2_crefset_sv");
		editionfileToTable.put("der2_cRefset_AttributeValueEXTTYPE_MOD_DATE.txt", "rf2_crefset_sv");	
		
		//CTV3 and SNOMED RT Identifiers come from the International Edition
		editionfileToTable.put("der2_sRefset_SimpleMapEXTTYPE_MOD_DATE.txt", "rf2_srefset_sv");
		//intfileToTable.put("der2_iissscRefset_ComplexEXTMapTYPE_MOD_DATE.txt", "rf2_iissscrefset_sv");
		//intfileToTable.put("der2_iisssccRefset_ExtendedMapEXTTYPE_MOD_DATE.txt", "rf2_iisssccrefset_sv");

	}
	
	static Map<String, String> extensionfileToTable = new HashMap<String, String>();
	{
		//Extension could supplement any file in international edition
		extensionfileToTable.putAll(editionfileToTable); 
		extensionfileToTable.put(EDITION_DETERMINER, "rf2_term_sv");
		extensionfileToTable.put("sct2_TextDefinition_EXTTYPE-LNG_MOD_DATE.txt", "rf2_def_sv");

		extensionfileToTable.put("der2_cRefset_AssociationReferenceEXTTYPE_MOD_DATE.txt", "rf2_crefset_sv");
		extensionfileToTable.put("der2_cRefset_AttributeValueEXTTYPE_MOD_DATE.txt", "rf2_crefset_sv");
		extensionfileToTable.put("der2_Refset_SimpleEXTTYPE_MOD_DATE.txt", "rf2_refset_sv");

		extensionfileToTable.put("der2_cRefset_LanguageEXTTYPE-LNG_MOD_DATE.txt", "rf2_crefset_sv");

		extensionfileToTable.put("der2_sRefset_SimpleMapEXTTYPE_MOD_DATE.txt", "rf2_srefset_sv");
		//extfileToTable.put("der2_iissscRefset_ComplexEXTMapTYPE_MOD_DATE.txt", "rf2_iissscrefset_sv");
		//extfileToTable.put("der2_iisssccRefset_ExtendedMapEXTTYPE_MOD_DATE.txt", "rf2_iisssccrefset_sv");

		extensionfileToTable.put("der2_cciRefset_RefsetDescriptorEXTTYPE_MOD_DATE.txt", "rf2_ccirefset_sv");
		extensionfileToTable.put("der2_ciRefset_DescriptionTypeEXTTYPE_MOD_DATE.txt", "rf2_cirefset_sv");
		extensionfileToTable.put("der2_ssRefset_ModuleDependencyEXTTYPE_MOD_DATE.txt", "rf2_ssrefset_sv");
	}
	
	public static Map<String, String>intExportMap = new HashMap<String, String>();
	{
		// The slashes will be replaced with the OS appropriate separator at export time
		intExportMap.put(outputFolderTemplate + "/Terminology/Content/sct1_Concepts_Core_MOD_DATE.txt",
				"select CONCEPTID, CONCEPTSTATUS, FULLYSPECIFIEDNAME, CTV3ID, SNOMEDID, ISPRIMITIVE from rf21_concept");
		intExportMap
				.put(RELATIONSHIP_FILENAME,
						"select RELATIONSHIPID,CONCEPTID1,RELATIONSHIPTYPE,CONCEPTID2,CHARACTERISTICTYPE,REFINABILITY,RELATIONSHIPGROUP from rf21_rel");
		}	

	public static Map<String, String> extExportMap = new HashMap<String, String>();
	{
		// The slashes will be replaced with the OS appropriate separator at export time
		extExportMap
				.put(outputFolderTemplate + "/Terminology/Content/sct1_Descriptions_LNG_MOD_DATE.txt",
						"select DESCRIPTIONID, DESCRIPTIONSTATUS, CONCEPTID, TERM, INITIALCAPITALSTATUS, DESC_TYPE as DESCRIPTIONTYPE, LANGUAGECODE from rf21_term");
		extExportMap.put(outputFolderTemplate + "/Terminology/History/sct1_References_Core_MOD_DATE.txt",
				"select COMPONENTID, REFERENCETYPE, REFERENCEDID from rf21_REFERENCE");
		extExportMap
				.put(outputFolderTemplate + "/Resources/StatedRelationships/res1_StatedRelationships_Core_MOD_DATE.txt",
						"select RELATIONSHIPID,CONCEPTID1,RELATIONSHIPTYPE,CONCEPTID2,CHARACTERISTICTYPE,REFINABILITY,RELATIONSHIPGROUP from rf21_stated_rel");
	}

	public static void main(String[] args) throws RF1ConversionException {
		//Set Windows Line separator as that's an RF1 standard
		System.setProperty("line.separator", "\r\n");
		ConversionManager cm = new ConversionManager();
		cm.doRf2toRf1Conversion(args);
	}

	private void doRf2toRf1Conversion(String[] args) throws RF1ConversionException {
		File tempDBLocation = Files.createTempDir();
		init(args, tempDBLocation);
		createDatabaseSchema();
		File intLoadingArea = null;
		File extLoadingArea = null;
		File exportArea = null;
		Stopwatch stopwatch = Stopwatch.createStarted();
		String completionStatus = "failed";
		try {
			print("\nExtracting RF2 International Edition Data...");
			intLoadingArea = unzipArchive(intRf2Archive);
			intReleaseDate = findDateInString(intLoadingArea.listFiles()[0].getName(), false);
			extReleaseDate = intReleaseDate;
			determineEdition(intLoadingArea, intReleaseDate);
			
			if (extRf2Archive != null) {
				print("\nExtracting RF2 Extension Data...");
				extLoadingArea = unzipArchive(extRf2Archive);
				extReleaseDate = findDateInString(extLoadingArea.listFiles()[0].getName(), false);
				determineEdition(extLoadingArea, extReleaseDate);	
				isExtension = true;
			}
			String releaseDate = isExtension ? extReleaseDate : intReleaseDate;
			File loadingArea = isExtension ? extLoadingArea : intLoadingArea;
			int releaseIndex = calculateReleaseIndex(releaseDate);
			EditionConfig config = knownEditionMap.get(edition);
			
			//Laterality indicators are now obligatory
			loadLateralityIndicators(intLoadingArea, intReleaseDate, config);
			
			int newSubsetVersion = 0;
			if (previousRF1Location != null) {
				useRelationshipIds = true;
				//This will allow us to set up SubsetIds (using available_sctids_partition_03)
				//And a map of existing relationship Ids to use for reconciliation
				loadPreviousRF1(config);
				
				//Initialise a set of available SCTIDS
				InputStream availableRelIds = ConversionManager.class.getResourceAsStream(AVAILABLE_RELATIONSHIP_IDS);
				RF1Constants.intialiseAvailableRelationships(availableRelIds);
				newSubsetVersion = previousSubsetVersion + 1;
			} else {
				useDeterministicSubsetIds(releaseIndex, config);
				newSubsetVersion = previousSubsetVersion + releaseIndex;
			}
			db.runStatement("SET @useRelationshipIds = " + useRelationshipIds);
			setSubsetIds(newSubsetVersion);
			
			long targetOperationCount = getTargetOperationCount();
			if (onlyHistory) {
				targetOperationCount = 250;
			} else if (isExtension) {
				targetOperationCount = includeHistory? targetOperationCount : 388;
			} else {
				targetOperationCount = includeHistory? targetOperationCount : 391;
			}
			setTargetOperationCount(targetOperationCount);

			completeOutputMap(config);
			db.runStatement("SET @langCode = '" + config.langCode + "'");
			db.runStatement("SET @langRefSet = '" + config.dialects[0].langRefSetId + "'");
			
			print("\nLoading " + edition.toString() +" common RF2 Data...");
			loadRF2Data(intLoadingArea, config, intReleaseDate, editionfileToTable);
			
			//Load the rest of the files from the same loading area if International Release, otherwise use the extensionLoading  Area
			print("\nLoading " + edition +" specific RF2 Data...");
			loadRF2Data(loadingArea, config, releaseDate, extensionfileToTable);

			debug("\nCreating RF2 indexes...");
			db.executeResource("create_rf2_indexes.sql");
			
			if (!onlyHistory) {
				print("\nCalculating RF2 snapshot...");
				calculateRF2Snapshot(releaseDate);
			}

			print("\nConverting RF2 to RF1...");
			convert(config);

			print("\nExporting RF1 to file...");
			exportArea = Files.createTempDir();
			exportRF1Data(intExportMap, releaseDate, intReleaseDate, knownEditionMap.get(edition), exportArea);
			exportRF1Data(extExportMap, releaseDate, releaseDate, knownEditionMap.get(edition), exportArea);

			//Relationship file uses the international release date, even for extensions.  Well, the Spanish one anyway.
			//But we also need the extension release date for the top level directory
			String filePath = getQualifyingRelationshipFilepath(intReleaseDate, extReleaseDate, knownEditionMap.get(edition), exportArea);
			if (includeAllQualifyingRelationships || includeLateralityIndicators) {
				print("\nLoading Inferred Relationship Hierarchy for Qualifying Relationship computation...");
				loadRelationshipHierarchy(knownEditionMap.get(Edition.INTERNATIONAL), intLoadingArea);
			}
			
			if (includeAllQualifyingRelationships) {
				print ("\nGenerating qualifying relationships");
				Set<QualifyingRelationshipAttribute> ruleAttributes = loadQualifyingRelationshipRules();
				generateQualifyingRelationships(ruleAttributes, filePath);
			}
			
			if (includeLateralityIndicators) {
				print ("\nGenerating laterality qualifying relationships");
				generateLateralityRelationships(filePath);
			}
			
			boolean documentationIncluded = false;
			if (additionalFilesLocation != null) {
				documentationIncluded = includeAdditionalFiles(exportArea, releaseDate, knownEditionMap.get(edition));
			}
			
			if (!documentationIncluded) {
				pullDocumentationFromRF2(loadingArea, exportArea, releaseDate, knownEditionMap.get(edition));
			}
			
			print("\nZipping archive");
			createArchive(exportArea);

			completionStatus = "completed";
			
		} finally {
			print("\nProcess " + completionStatus + " in " + stopwatch + " after completing " + getProgress() + "/" + getTargetOperationCount()
					+ " operations.");
			
			if (goInteractive) {
				doInteractive();
			}
			
			try {
				print(RF1Constants.getRelationshipIdUsageSummary());
			} catch (Exception e){}
			
			print("Cleaning up resources...");
			try {
				db.shutDown(true); // Also deletes all files
				if (tempDBLocation != null && tempDBLocation.exists()) {
					tempDBLocation.delete();
				}
			} catch (Exception e) {
				debug("Error while cleaning up database " + tempDBLocation.getPath() + e.getMessage());
			}
			try {
				if (intLoadingArea != null && intLoadingArea.exists()) {
					FileUtils.deleteDirectory(intLoadingArea);
				}
				
				if (extLoadingArea != null && extLoadingArea.exists()) {
					FileUtils.deleteDirectory(extLoadingArea);
				}

				if (exportArea != null && exportArea.exists()) {
					FileUtils.deleteDirectory(exportArea);
				}
			} catch (Exception e) {
				debug("Error while cleaning up loading/export Areas " + e.getMessage());
			}
		}
		
	}

	private void doInteractive() {
		boolean quitDetected = false;
		StringBuilder buff = new StringBuilder();
		try (Scanner in = new Scanner(System.in)) {
			print ("Enter sql command to run, terminate with semicolon or type quit; to finish");
			while (!quitDetected) {
				buff.append(in.nextLine().trim());
				if (buff.length() > 1 && buff.charAt(buff.length()-1) == ';') {
					String command = buff.toString();
					if (command.equalsIgnoreCase("quit;")) {
						quitDetected = true;
					} else {
						try{
							db.runStatement(command.toString());
						} catch (Exception e) {
							e.printStackTrace();
						}
						buff.setLength(0);
					}
				} else {
					buff.append(" ");
				}
			}
		}
	}

	private void completeOutputMap(EditionConfig editionConfig) {
		if (isExtension) {
			String archiveName = "SnomedCT_OUT_MOD_DATE";
			String folderName = "Language-" + editionConfig.langCode;
			String fileRoot = archiveName + File.separator + "Subsets" + File.separator + folderName + File.separator;
			String fileName = "der1_SubsetMembers_"+ editionConfig.langCode + "_MOD_DATE.txt";
			extExportMap.put(fileRoot + fileName,
					"select s.SubsetId, s.MemberID, s.MemberStatus, s.LinkedID from rf21_SUBSETS s, rf21_SUBSETLIST sl where s.SubsetOriginalId = sl.subsetOriginalId AND sl.languageCode = ''" + editionConfig.langCode + "'';");
			
			fileName = "der1_Subsets_" + editionConfig.langCode + "_MOD_DATE.txt";
			extExportMap.put(fileRoot + fileName,
					"select sl.* from rf21_SUBSETLIST sl where languagecode = ''" + editionConfig.langCode + "'';");
			extExportMap.put("SnomedCT_OUT_MOD_DATE/Resources/TextDefinitions/sct1_TextDefinitions_LNG_MOD_DATE.txt",
					"select * from rf21_DEF");
		} else {
			extExportMap.put("SnomedCT_OUT_MOD_DATE/Resources/TextDefinitions/sct1_TextDefinitions_en-US_MOD_DATE.txt",
					"select * from rf21_DEF");
			extExportMap
			.put("SnomedCT_OUT_MOD_DATE/Subsets/Language-en-GB/der1_SubsetMembers_en-GB_MOD_DATE.txt",
					"select s.SubsetId, s.MemberID, s.MemberStatus, s.LinkedID from rf21_SUBSETS s, rf21_SUBSETLIST sl where s.SubsetOriginalId = sl.subsetOriginalId AND sl.languageCode in (''en'',''en-GB'')");
			extExportMap.put("SnomedCT_OUT_MOD_DATE/Subsets/Language-en-GB/der1_Subsets_en-GB_MOD_DATE.txt",
					"select sl.* from rf21_SUBSETLIST sl where languagecode like ''%GB%''");
			extExportMap
					.put("SnomedCT_OUT_MOD_DATE/Subsets/Language-en-US/der1_SubsetMembers_en-US_MOD_DATE.txt",
							"select s.SubsetId, s.MemberID, s.MemberStatus, s.LinkedID from rf21_SUBSETS s, rf21_SUBSETLIST sl where s.SubsetOriginalId = sl.subsetOriginalId AND sl.languageCode in (''en'',''en-US'')");
			extExportMap.put("SnomedCT_RF1Release_MOD_DATE/Subsets/Language-en-US/der1_Subsets_en-US_MOD_DATE.txt",
			"select sl.* from rf21_SUBSETLIST sl where languagecode like ''%US%''");
		}
		
		if (includeHistory) {
			extExportMap.put("SnomedCT_OUT_MOD_DATE/Terminology/History/sct1_ComponentHistory_Core_MOD_DATE.txt",
					"select COMPONENTID, RELEASEVERSION, CHANGETYPE, STATUS, REASON from rf21_COMPONENTHISTORY");
		}
	}

	private void determineEdition(File loadingArea,  String releaseDate) throws RF1ConversionException {
		//Loop through known editions and see if EDITION_DETERMINER file is present
		for (Map.Entry<Edition, EditionConfig> thisEdition : knownEditionMap.entrySet())
			for (File thisFile : loadingArea.listFiles()) {
				EditionConfig parts = thisEdition.getValue();
				String target = EDITION_DETERMINER.replace(EXT, parts.editionName)
									.replace(LNG, parts.langCode)
									.replace(MOD, parts.module)
									.replace(DATE, releaseDate)
									.replace(TYPE, isSnapshotConversion ? "Snapshot" : "Full");
				if (thisFile.getName().equals(target)) {
					this.edition = thisEdition.getKey();
					return;
				}
			}
		throw new RF1ConversionException ("Failed to find file matching any known edition: " + EDITION_DETERMINER + " in " + loadingArea.getAbsolutePath());
	}

	private File unzipArchive(File archive) throws RF1ConversionException {

		File tempDir = null;
		try {
			if (unzipLocation != null) {
				tempDir = java.nio.file.Files.createTempDirectory(unzipLocation.toPath(), "rf2-to-rf1-").toFile();
			} else {
				// Work in the traditional temp file location for the OS
				tempDir = Files.createTempDir();
			}
		} catch (IOException e) {
			throw new RF1ConversionException("Unable to create temporary directory for archive extration");
		}
		// We only need to work with the full files
		// ...mostly, we also need the Snapshot Relationship file in order to work out the Qualifying Relationships
		// Also we'll take the documentation pdf
		String match = isSnapshotConversion ? "Snapshot" : "Full";
		unzipFlat(archive, tempDir, new String[]{ match, "sct2_Relationship_Snapshot","der2_Refset_SimpleSnapshot",RELEASE_NOTES});
		
		return tempDir;
	}

	private void createDatabaseSchema() throws RF1ConversionException {
		print("Creating database schema");
		db.executeResource("create_rf2_schema.sql");
	}

	private void calculateRF2Snapshot(String releaseDate) throws RF1ConversionException {
		String setDateSql = "SET @RDATE = " + releaseDate;
		db.runStatement(setDateSql);
		db.executeResource("create_rf2_snapshot.sql");
		db.executeResource("populate_subset_2_refset.sql");
	}

	private void convert(EditionConfig config) throws RF1ConversionException {
		db.executeResource("create_rf1_schema.sql");
		if (includeHistory && config.historyAvailable) {
			db.executeResource("populate_rf1_historical.sql");
		} else {
			print("\nSkipping generation of RF1 History.  Set -h parameter if this is required (selected Editions only).");
		}
		
		if (!onlyHistory) {
			db.executeResource("populate_rf1.sql");
			if (isExtension) {
				db.executeResource("populate_rf1_ext_descriptions.sql");
			} else {
				db.executeResource("populate_rf1_int_descriptions.sql");
			}
			db.executeResource("populate_rf1_associations.sql");
			
			if (useRelationshipIds) {
				db.executeResource("populate_rf1_rel_ids.sql");
			}
		}
	}

	private void init(String[] args, File dbLocation) throws RF1ConversionException {
		if (args.length < 1) {
			print("Usage: java ConversionManager [-v] [-h] [-b] [-i] [-a <additional files location>] [-p <previous RF1 archive] [-u <unzip location>] <rf2 archive location> [<rf2 extension archive>]");
			print("  b - beta indicator, causes an x to be prepended to output filenames");
			print("  p - previous RF1 archive required for SubsetId and Relationship Id generation");
			exit();
		}
		boolean isUnzipLocation = false;
		boolean isAdditionalFilesLocation = false;
		boolean isPreviousRF1Location = false;

		for (String thisArg : args) {
			if (thisArg.equals("-v")) {
				GlobalUtils.verbose = true;
			} else if (thisArg.equals("-i")) {
				goInteractive = true;
			} else if (thisArg.equals("-s")) {
				//New feature, currently undocumented until proven.
				print ("Option set to perform conversion on Snapshot files.  No history will be produced.");
				isSnapshotConversion = true;
				includeHistory = false;
				if (onlyHistory) {
					throw new RF1ConversionException("History is not possible with a snapshot conversion");
				}
			} else if (thisArg.equals("-H")) {
				includeHistory = true;
				onlyHistory = true;
				if (isSnapshotConversion) {
					throw new RF1ConversionException("History is not possible with a snapshot conversion");
				}
			} else if (thisArg.equals("-b")) {
				isBeta = true;
			}else if (thisArg.equals("-u")) {
				isUnzipLocation = true;
			} else if (thisArg.equals("-a")) {
				isAdditionalFilesLocation = true;
			} else if (thisArg.equals("-p")) {
				isPreviousRF1Location = true;
			} else if (thisArg.equals("-q")) {
				//The rule file for generating these relationships is currently incomplete and incorrect.
				includeAllQualifyingRelationships = true;
			} else if (isUnzipLocation) {
				unzipLocation = new File(thisArg);
				if (!unzipLocation.isDirectory()) {
					throw new RF1ConversionException(thisArg + " is an invalid location to unzip archive to!");
				}
				isUnzipLocation = false;
			} else if (isAdditionalFilesLocation) {
				additionalFilesLocation = new File(thisArg);
				if (!additionalFilesLocation.isDirectory()) {
					throw new RF1ConversionException(thisArg + " is an invalid location to find additional files.");
				}
				isAdditionalFilesLocation = false;
			} else if (isPreviousRF1Location) {
				previousRF1Location = new File(thisArg);
				if (!previousRF1Location.exists() || !previousRF1Location.canRead()) {
					throw new RF1ConversionException(thisArg + " does not appear to be a valid RF1 archive.");
				}
				isPreviousRF1Location = false;
			} else if (intRf2Archive == null){
				File possibleArchive = new File(thisArg);
				if (possibleArchive.exists() && !possibleArchive.isDirectory() && possibleArchive.canRead()) {
					intRf2Archive = possibleArchive;
				}
			} else {
				File possibleArchive = new File(thisArg);
				if (possibleArchive.exists() && !possibleArchive.isDirectory() && possibleArchive.canRead()) {
					extRf2Archive = possibleArchive;
				}
			}
		}

		if (intRf2Archive == null) {
			print("Unable to load RF2 Archive: " + args[args.length - 1]);
			exit();
		}

		db = new DBManager();
		db.init(dbLocation);
	}

	private void loadRF2Data(File loadingArea, EditionConfig config, String releaseDate, Map<String, String> fileToTable) throws RF1ConversionException {
		// We can do the load in parallel. Only 3 threads because heavily I/O
		db.startParallelProcessing(3);
		String releaseType = isSnapshotConversion ? "Snapshot":"Full";
		for (Map.Entry<String, String> entry : fileToTable.entrySet()) {
			// Replace DATE in the filename with the actual release date
			String fileName = entry.getKey().replace(DATE, releaseDate)
								.replace(EXT, config.editionName)
								.replace(LNG, config.langCode)
								.replace(MOD, config.module)
								.replace(TYPE, releaseType);
			
			File file = new File(loadingArea + File.separator + fileName);
			
			//Only load each file once
			if (filesLoaded.contains(file)) {
				debug ("Skipping " + file.getName() + " already loaded as a common file.");
			} else if (file.exists()) {
				db.load(file, entry.getValue());
				filesLoaded.add(file);
			} else {
				print("\nWarning, skipping load of file " + file.getName() + " - not present");
			}
		}
		db.finishParallelProcessing();
	}

	private void exportRF1Data(Map<String, String> exportMap, String packageReleaseDate, String fileReleaseDate, EditionConfig config, File exportArea) throws RF1ConversionException {
		// We can do the export in parallel. Only 3 threads because heavily I/O
		db.startParallelProcessing(3);
		for (Map.Entry<String, String> entry : exportMap.entrySet()) {
			// Replace DATE in the filename with the actual release date
			String fileName = entry.getKey().replaceFirst(DATE, packageReleaseDate)
					.replace(DATE, fileReleaseDate)
					.replace(OUT, config.outputName)
					.replace(LNG, config.langCode)
					.replace(MOD, config.module);
			
			fileName = modifyFilenameIfBeta(fileName);
			String filePath = exportArea + File.separator + fileName;
			
			//If we're doing the history file, then we need to prepend the static
			//resource file
			InputStream isInclude = null;
			if (includeHistory && fileName.contains("ComponentHistory")) {
				isInclude = ConversionManager.class.getResourceAsStream(ANCIENT_HISTORY);
				if (isInclude == null) {
					throw new RF1ConversionException("Unable to obtain history file: " + ANCIENT_HISTORY);
				}
			}
			
			db.export(filePath, entry.getValue(), isInclude);
		}
		db.finishParallelProcessing();
	}
	

	private String modifyFilenameIfBeta(String fileName) {
		if (isBeta) {
			//Beta prefix before the file shortname, but also for the leading directory
			int lastSlash = fileName.lastIndexOf(File.separator) + 1;
			fileName = BETA_PREFIX + fileName.substring(0,lastSlash) + BETA_PREFIX + fileName.substring(lastSlash);
		}
		return fileName;
	}

	private void loadRelationshipHierarchy(EditionConfig config, File intLoadingArea) throws RF1ConversionException {
		String fileName = intLoadingArea.getAbsolutePath() + File.separator + "sct2_Relationship_Snapshot_MOD_DATE.txt";
		fileName = fileName.replace(DATE, intReleaseDate)
							.replace(MOD, config.module);
		GraphLoader gl = new GraphLoader (fileName);
		gl.loadRelationships();
	}
	

	private Set<QualifyingRelationshipAttribute> loadQualifyingRelationshipRules() {
		GsonBuilder gsonBuilder = new GsonBuilder();
		gsonBuilder.registerTypeAdapter(Concept.class, new ConceptDeserializer());
		Gson gson = gsonBuilder.create();
		InputStream jsonStream = ConversionManager.class.getResourceAsStream(QUALIFYING_RULES);
		BufferedReader jsonReader = new BufferedReader(new InputStreamReader(jsonStream));
		Type listType = new TypeToken<Set<QualifyingRelationshipAttribute>>() {}.getType();
		Set<QualifyingRelationshipAttribute> attributes = gson.fromJson(jsonReader, listType);
		return attributes;
	}
	
	/**
	 * This is a temporary measure until we can get the Laterality Reference published as a refset.
	 * at which point it will stop being an external file
	 * @param loadingArea 
	 */
	private void loadLateralityIndicators(File loadingArea, String releaseDate, EditionConfig config) throws RF1ConversionException {
		String targetFilename = LATERALITY_SNAPSHOT_TEMPLATE.replace(DATE, releaseDate).replace(MOD, config.module);
		File lateralityFile = new File(loadingArea.getAbsolutePath() + File.separator + targetFilename);
		boolean sufficientDataReadOK = true;
		if (!lateralityFile.canRead()) {
			debug ("Could not find " + targetFilename + " among " + GlobalUtils.listDirectory(loadingArea));
			sufficientDataReadOK = false;
		} else {
			int linesRead = 0;
			try (BufferedReader br = new BufferedReader(new FileReader(lateralityFile))) {
				String line;
				boolean firstLine = true;
				while ((line = br.readLine()) != null) {
					if (!firstLine) {
						String[] columns = line.split(FIELD_DELIMITER);
						if (columns[SIMP_IDX_ACTIVE].equals("1") && columns[SIMP_IDX_REFSETID].equals(LATERALITY_REFSET_ID)) {
							LateralityIndicator.registerIndicator(columns[SIMP_IDX_REFCOMPID]);
							linesRead++;
						}
					} else {
						firstLine = false;
					}
				}
				if (linesRead < SUFFICIENT_LATERALITY_DATA) {
					sufficientDataReadOK = false;
				}
			} catch (IOException ioe) {
				throw new RF1ConversionException ("Unable to import laterality reference file " + lateralityFile.getAbsolutePath(), ioe);
			}
		}
		
		if (!sufficientDataReadOK && useRelationshipIds) {
			String msg = "Laterality Reference Set not detected/available/sufficient in Simple Refset Snapshot: " + targetFilename + ".\nThis refset is compulsory in this version of the RF2 to RF1 converter, if Relationship IDs are to be generated.";
			print("\n" + msg);
			throw new RF1ConversionException (msg);
		}
	}
	

	private void generateQualifyingRelationships(
			Set<QualifyingRelationshipAttribute> ruleAttributes, String filePath) throws RF1ConversionException {
		//For each attribute, work through each rule creating rules for self and all children of starting points,
		//except for exceptions
		
		try(FileWriter fw = new FileWriter(filePath, true);
				BufferedWriter bw = new BufferedWriter(fw);
				PrintWriter out = new PrintWriter(bw))
			{
				for (QualifyingRelationshipAttribute thisAttribute : ruleAttributes) {
					StringBuffer commonRF1 = new StringBuffer().append(FIELD_DELIMITER)
											.append(thisAttribute.getType().getSctId()).append(FIELD_DELIMITER)
											.append(thisAttribute.getDestination().getSctId()).append(FIELD_DELIMITER)
											.append("1\t")//Qualifying Rel type
											.append(thisAttribute.getRefinability()).append("\t0"); //Refineable, Group 0
					for (QualifyingRelationshipRule thisRule : thisAttribute.getRules()) {
						Set<Concept> potentialApplications = thisRule.getStartPoint().getAllDescendents(Concept.DEPTH_NOT_SET);
						Collection<Concept> ruleAppliedTo = CollectionUtils.subtract(potentialApplications, thisRule.getExceptions());
						for (Concept thisException : thisRule.getExceptions()) {
							Set<Concept> exceptionDescendents = thisException.getAllDescendents(Concept.DEPTH_NOT_SET);
							ruleAppliedTo = CollectionUtils.subtract(ruleAppliedTo, exceptionDescendents);
						}
						//Now the remaining concepts that the rules applies to can be written out to file
						for (Concept thisConcept : ruleAppliedTo) {
							//Concept may already have this attribute as a defining relationship, skip if so.
							if (!thisConcept.hasAttribute(thisAttribute)) {
								String rf1Line = FIELD_DELIMITER + thisConcept.getSctId() + commonRF1;
								out.println(rf1Line);
							}
						}
					}
				}
			} catch (IOException e) {
				throw new RF1ConversionException ("Failure while outputting Qualifying Relationships: " + e.toString());
			}
	}
	
	private void generateLateralityRelationships(String filePath) throws RF1ConversionException {
		//Check every concept to see if has a laterality indicator, and doesn't already have that 
		//attribute as a defining relationship
		Set<Concept> allConcepts = Concept.getConcept(SNOMED_ROOT_CONCEPT).getAllDescendents(Concept.DEPTH_NOT_SET);
		StringBuffer commonRF1 = new StringBuffer().append(FIELD_DELIMITER)
				.append(LATERALITY_ATTRIB).append(FIELD_DELIMITER)
				.append(SIDE_VALUE).append(FIELD_DELIMITER)
				.append("1\t")//Qualifying Rel type
				.append(RF1Constants.MUST_REFINE).append("\t0"); //Refineable, Group 0
		
		Concept lat = Concept.getConcept(Long.parseLong(LATERALITY_ATTRIB));
		Concept side = Concept.getConcept(Long.parseLong(SIDE_VALUE));
		QualifyingRelationshipAttribute LateralityAttribute = new QualifyingRelationshipAttribute (lat, side, RF1Constants.MUST_REFINE);
		
		try(FileWriter fw = new FileWriter(filePath, true);
				BufferedWriter bw = new BufferedWriter(fw);
				PrintWriter out = new PrintWriter(bw))
			{
				for (Concept thisConcept : allConcepts) {
					if (LateralityIndicator.hasLateralityIndicator(thisConcept.getSctId())) {
						if (!thisConcept.hasAttribute(LateralityAttribute)) {
							String relId = "";  //Default is to blank relationship ids
							if (useRelationshipIds) {
								relId = RF1Constants.lookupRelationshipId(thisConcept.getSctId().toString(),
									LATERALITY_ATTRIB,
									SIDE_VALUE,
									UNGROUPED,
									false);  //working with inferred relationship ids
							}
							String rf1Line = relId + FIELD_DELIMITER + thisConcept.getSctId() + commonRF1;
							out.println(rf1Line);
						}
					}
					
				}
			}catch (IOException e){
				throw new RF1ConversionException ("Failure while output Laterality Relationships: " + e.toString());
			}
	}


	private String getQualifyingRelationshipFilepath(String intReleaseDate,
			String extReleaseDate, EditionConfig config, File exportArea) throws RF1ConversionException {
		// Replace the top level Date with the Extension Date, and the 
		// Relationship file with the extension release date
		String fileName = RELATIONSHIP_FILENAME.replaceFirst(DATE, extReleaseDate)
				.replace(DATE, intReleaseDate)
				.replace(OUT, config.outputName)
				.replace(LNG, config.langCode)
				.replace(MOD,  config.module);
		fileName = modifyFilenameIfBeta(fileName);
		String filePath = exportArea + File.separator + fileName;
		File outputFile = new File(filePath);
		try{
			if (!outputFile.exists()) {
				outputFile.getParentFile().mkdirs();
				outputFile.createNewFile();
			}
		} catch (IOException e) {
			throw new RF1ConversionException("Unable to create file for Qualifying Relationships: " + e);
		}
		return filePath;
	}

	private boolean includeAdditionalFiles(File outputDirectory, String releaseDate, EditionConfig editionConfig){
		Map<String, String> targetLocation = new HashMap<String, String>();
		boolean documentationIncluded = false;
		targetLocation.put(".pdf", DOCUMENTATION_DIR);
		targetLocation.put("KeyIndex_", "Resources/Indexes/");
		targetLocation.put("Canonical", "Resources/Canonical Table/");
		String rootPath = getOutputRootPath(outputDirectory, releaseDate, editionConfig);
		File[] directoryListing = additionalFilesLocation.listFiles();
		if (directoryListing != null) {
			for (File child : directoryListing) {
				String childFilename = child.getName();
				//Do we know to put this file in a particular location?
				//otherwise path will remain the root path
				for (String match : targetLocation.keySet()) {
					if (childFilename.contains(match)) {
						childFilename = targetLocation.get(match) + childFilename;
						break;
					}
				}
				//Ensure path exists for where file is being copied to
				File copiedFile = new File (rootPath + childFilename);
				copiedFile.getParentFile().mkdirs();
				try {
					FileUtils.copyFile(child, copiedFile);
					print ("Copied additional file to " + copiedFile.getAbsolutePath());
					if (copiedFile.getName().contains(RELEASE_NOTES)) {
						documentationIncluded = true;
					}
				} catch (IOException e) {
					print ("Unable to copy additional file " + childFilename + " due to " + e.getMessage());
				}
			}
		}
		return documentationIncluded;
	}


	private String getOutputRootPath(File outputDirectory, String releaseDate,
			EditionConfig config) {
		String rootPath = outputDirectory.getAbsolutePath() 
			+ File.separator 
			+ (isBeta?BETA_PREFIX:"")
			+ outputFolderTemplate  
			+ File.separator;
		rootPath = rootPath.replace(OUT, config.outputName)
			.replace(DATE, releaseDate)
			.replace(MOD, config.module);
		return rootPath;
	}

	private void loadPreviousRF1(EditionConfig config) throws RF1ConversionException {
		int previousRelFilesLoaded = 0;
		try {
			ZipInputStream zis = new ZipInputStream(new FileInputStream(previousRF1Location));
			ZipEntry ze = zis.getNextEntry();
			try {
				while (ze != null) {
					if (!ze.isDirectory()) {
						Path p = Paths.get(ze.getName());
						String fileName = p.getFileName().toString();
						if (fileName.contains("der1_Subsets")) {
							updateSubsetIds(zis, config);
						} else if (fileName.contains("sct1_Relationships")) {
							//We need to use static methods here so that H2 can access as functions.
							print ("\nLoading previous RF1 inferred relationships");
							RF1Constants.loadPreviousRelationships(zis, false);
							previousRelFilesLoaded++;
						}else if (fileName.contains("res1_StatedRelationships")) {
							print ("\nLoading previous RF1 stated relationships");
							RF1Constants.loadPreviousRelationships(zis, true);
							previousRelFilesLoaded++;
						}
					}
					ze = zis.getNextEntry();
				}
			} finally {
				zis.closeEntry();
				zis.close();
			}
		} catch (IOException e) {
			throw new RF1ConversionException("Failed to load previous RF1 archive " + previousRF1Location.getName(), e);
		}
		
		if (previousRelFilesLoaded != 2) {
			throw new RF1ConversionException("Expected to load 2 previous relationship files, instead loaded " + previousRelFilesLoaded );
		}
	}
	
	private void updateSubsetIds(ZipInputStream zis, EditionConfig config) throws NumberFormatException, IOException {
		//This function will also pick up and set the previous subset version
		Long subsetId = loadSubsetsFile(zis);
		//Do we need to recover a new set of subsetIds?
		if (maxPreviousSubsetId == null || subsetId > maxPreviousSubsetId) {
			maxPreviousSubsetId = subsetId;
			InputStream is = ConversionManager.class.getResourceAsStream(AVAILABLE_SUBSET_IDS);
			try (BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))){
				String line;
				int subsetIdsSet = 0;
				subsetIds = new Long[config.dialects.length];
				while ((line = br.readLine()) != null && subsetIdsSet < config.dialects.length) {
					Long thisAvailableSubsetId = Long.parseLong(line.trim());
					if (thisAvailableSubsetId.compareTo(maxPreviousSubsetId) > 0) {
						debug ("Obtaining new Subset Ids from resource file");
						subsetIds[subsetIdsSet] = thisAvailableSubsetId;
						subsetIdsSet++;
					}
				}
			}
		}
		
	}
	
	/*
	 * @return the greatest subsetId in the file
	 */
	private Long loadSubsetsFile(ZipInputStream zis) throws IOException {
		Long maxSubsetIdInFile = null;
		BufferedReader br = new BufferedReader(new InputStreamReader(zis, StandardCharsets.UTF_8));
		String line;
		boolean isFirstLine = true;
		while ((line = br.readLine()) != null) {
			if (isFirstLine) {
				isFirstLine = false;
				continue;
			}
			String[] lineItems = line.split(FIELD_DELIMITER);
			//SubsetId is the first column
			Long thisSubsetId = Long.parseLong(lineItems[RF1_IDX_SUBSETID]);
			if (maxSubsetIdInFile == null || thisSubsetId > maxSubsetIdInFile) {
				maxSubsetIdInFile = thisSubsetId;
			}
			//SubsetVersion is the 3rd
			int thisSubsetVersion = Integer.parseInt(lineItems[RF1_IDX_SUBSETVERSION]);
			if (thisSubsetVersion > previousSubsetVersion) {
				previousSubsetVersion = thisSubsetVersion;
			}
		}
		return maxSubsetIdInFile;
	}

	private void useDeterministicSubsetIds(int releaseIndex, EditionConfig config) throws RF1ConversionException {
		try {
			InputStream is = ConversionManager.class.getResourceAsStream(AVAILABLE_SUBSET_IDS);
			try (BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))){
				String line;
				int subsetIdsSet = 0;
				subsetIds = new Long[config.dialects.length];
				int filePos = 0;
				while ((line = br.readLine()) != null && subsetIdsSet < config.dialects.length) {
					filePos++;
					Long thisAvailableSubsetId = Long.parseLong(line.trim());
					if (filePos >= releaseIndex) {
						debug ("Obtaining new Subset Ids from resource file");
						subsetIds[subsetIdsSet] = thisAvailableSubsetId;
						subsetIdsSet++;
					}
				}
			}
		} catch (IOException e) {
			throw new RF1ConversionException("Unable to determine new subset Ids",e);
		}
	}
	
	private void setSubsetIds(int newSubsetVersion) {
		for (int i=0 ; i<subsetIds.length; i++) {
			db.runStatement("SET @SUBSETID_" + (i+1) + " = " + subsetIds[i]);
		}
		db.runStatement("SET @SUBSET_VERSION = " + newSubsetVersion);
	}

	int calculateReleaseIndex(String releaseDate) {
		//returns a number that can be used when a previous release is not available
		//to give an incrementing variable that we can use to move through the SCTID 02 & 03 files
		int year = Integer.parseInt(releaseDate.substring(0, 4));
		int month = Integer.parseInt(releaseDate.substring(4,6));
		int index = ((year - 2016)*10) + month;
		return index;
	}
	

	private void pullDocumentationFromRF2(File loadingArea, File exportArea, String releaseDate, EditionConfig editionConfig) {
		FileFilter fileFilter = new WildcardFileFilter("*" + RELEASE_NOTES + "*");
		File[] files = loadingArea.listFiles(fileFilter);
		String outputRootPath = getOutputRootPath(exportArea, releaseDate, editionConfig);
		String destDir = outputRootPath + File.separator + DOCUMENTATION_DIR + File.separator;
		for (File file : files) {
			try{
				File destFile = new File (destDir + file.getName());
				FileUtils.copyFile(file, destFile);
			} catch (IOException e) {
				debug ("Failed to copy "  + file +  " to destination area: " + e.toString());
			}
		}
	}
}

