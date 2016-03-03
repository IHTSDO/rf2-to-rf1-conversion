package org.ihtsdo.snomed.rf2torf1conversion;

import static org.ihtsdo.snomed.rf2torf1conversion.GlobalUtils.*;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import org.apache.commons.io.FileUtils;

import com.google.common.base.Stopwatch;
import com.google.common.io.Files;

public class ConversionManager {

	File intRf2Archive;
	File extRf2Archive;
	File unzipLocation = null;
	DBManager db;
	String intReleaseDate;
	String extReleaseDate;
	boolean includeHistory = false;
	boolean isExtension = false;
	Edition edition;
	private String EXT = "EXT";
	private String LNG = "LNG";
	private String DATE = "DATE";
	private String OUT = "OUT";
	Set<File> filesLoaded = new HashSet<File>();
	
	enum Edition { INTERNATIONAL, SPANISH };
	
	class Dialect {
		String langRefSetId;
		String langCode;
		Dialect (String langRefSetId, String langCode) {
			this.langRefSetId = langRefSetId;
			this.langCode = langCode;
		}
	}

	public final Dialect dialectEs = new Dialect ("450828004","es");  //Latin American Spanish
	public final Dialect dialectGb = new Dialect ("900000000000508004","en-GB");
	public final Dialect dialectUs = new Dialect ("900000000000509007","en-US");
	
	class EditionConfig {
		String editionName;
		String langCode;
		String outputName;
		Dialect[] dialects;
		EditionConfig (String editionName, String language, String outputName, Dialect[] dialects) {
			this.editionName = editionName;
			this.outputName = outputName;
			this.langCode = language;
			this.dialects = dialects;
		}
	}
	
	private static final String EDITION_DETERMINER = "sct2_Description_EXTFull-LNG_INT_DATE.txt";
	
	static Map<Edition, EditionConfig> knownEditionMap = new HashMap<Edition, EditionConfig>();
	{
		knownEditionMap.put(Edition.INTERNATIONAL, new EditionConfig("","en", "RF1Release", new Dialect[]{dialectGb, dialectUs}));   //International Edition has no Extension name
		knownEditionMap.put(Edition.SPANISH, new EditionConfig("SpanishExtension", "es", "SpanishRelease-es",new Dialect[]{dialectEs}));
	}
	
	static Map<String, String> intfileToTable = new HashMap<String, String>();
	{
		intfileToTable.put("sct2_Concept_EXTFull_INT_DATE.txt", "rf2_concept_sv");
		intfileToTable.put("sct2_Relationship_EXTFull_INT_DATE.txt", "rf2_rel_sv");
		intfileToTable.put("sct2_StatedRelationship_EXTFull_INT_DATE.txt", "rf2_rel_sv");
		intfileToTable.put("sct2_Identifier_EXTFull_INT_DATE.txt", "rf2_identifier_sv");
		//Extensions can use a mix of International and their own descriptions
		intfileToTable.put(EDITION_DETERMINER, "rf2_term_sv");
	}
	
	static Map<String, String> extfileToTable = new HashMap<String, String>();
	{
		//Extension could supplement any file in international edition
		extfileToTable.putAll(intfileToTable); 
		extfileToTable.put(EDITION_DETERMINER, "rf2_term_sv");
		extfileToTable.put("sct2_TextDefinition_EXTFull-LNG_INT_DATE.txt", "rf2_def_sv");

		extfileToTable.put("der2_cRefset_AssociationReferenceEXTFull_INT_DATE.txt", "rf2_crefset_sv");
		extfileToTable.put("der2_cRefset_AttributeValueEXTFull_INT_DATE.txt", "rf2_crefset_sv");
		extfileToTable.put("der2_Refset_SimpleEXTFull_INT_DATE.txt", "rf2_refset_sv");

		extfileToTable.put("der2_cRefset_LanguageEXTFull-LNG_INT_DATE.txt", "rf2_crefset_sv");

		extfileToTable.put("der2_sRefset_SimpleMapEXTFull_INT_DATE.txt", "rf2_srefset_sv");
		extfileToTable.put("der2_iissscRefset_ComplexEXTMapFull_INT_DATE.txt", "rf2_iissscrefset_sv");
		extfileToTable.put("der2_iisssccRefset_ExtendedMapEXTFull_INT_DATE.txt", "rf2_iisssccrefset_sv");

		extfileToTable.put("der2_cciRefset_RefsetDescriptorEXTFull_INT_DATE.txt", "rf2_ccirefset_sv");
		extfileToTable.put("der2_ciRefset_DescriptionTypeEXTFull_INT_DATE.txt", "rf2_cirefset_sv");
		extfileToTable.put("der2_ssRefset_ModuleDependencyEXTFull_INT_DATE.txt", "rf2_ssrefset_sv");
	}
	
	public static Map<String, String>intExportMap = new HashMap<String, String>();
	{
		// The slashes will be replaced with the OS appropriate separator at export time
		intExportMap.put("SnomedCT_OUT_INT_DATE/Terminology/Content/sct1_Concepts_Core_INT_DATE.txt",
				"select CONCEPTID, CONCEPTSTATUS, FULLYSPECIFIEDNAME, CTV3ID, SNOMEDID, ISPRIMITIVE from rf21_concept");
		intExportMap
				.put("SnomedCT_OUT_INT_DATE/Terminology/Content/sct1_Relationships_Core_INT_DATE.txt",
						"select RELATIONSHIPID,CONCEPTID1,RELATIONSHIPTYPE,CONCEPTID2,CHARACTERISTICTYPE,REFINABILITY,RELATIONSHIPGROUP from rf21_rel");
		}	

	public static Map<String, String> extExportMap = new HashMap<String, String>();
	{
		// The slashes will be replaced with the OS appropriate separator at export time
		extExportMap
				.put("SnomedCT_OUT_INT_DATE/Terminology/Content/sct1_Descriptions_LNG_INT_DATE.txt",
						"select DESCRIPTIONID, DESCRIPTIONSTATUS, CONCEPTID, TERM, INITIALCAPITALSTATUS, DESC_TYPE as DESCRIPTIONTYPE, LANGUAGECODE from rf21_term");
		extExportMap.put("SnomedCT_OUT_INT_DATE/Terminology/History/sct1_ComponentHistory_Core_INT_DATE.txt",
				"select COMPONENTID, RELEASEVERSION, CHANGETYPE, STATUS, REASON from rf21_COMPONENTHISTORY");
		extExportMap.put("SnomedCT_OUT_INT_DATE/Terminology/History/sct1_References_Core_INT_DATE.txt",
				"select COMPONENTID, REFERENCETYPE, REFERENCEDID from rf21_REFERENCE");
		extExportMap
				.put("SnomedCT_OUT_INT_DATE/Resources/StatedRelationships/res1_StatedRelationships_Core_INT_DATE.txt",
						"select RELATIONSHIPID,CONCEPTID1,RELATIONSHIPTYPE,CONCEPTID2,CHARACTERISTICTYPE,REFINABILITY,RELATIONSHIPGROUP from rf21_stated_rel");
	}

	public static void main(String[] args) throws RF1ConversionException {
		ConversionManager cm = new ConversionManager();
		cm.doRf2toRf1Conversion(args);
	}

	private void doRf2toRf1Conversion(String[] args) throws RF1ConversionException {
		File tempDBLocation = Files.createTempDir();
		init(args, tempDBLocation);
		createDatabaseSchema();
		File intLoadingArea = null;
		File extloadingArea = null;
		File exportArea = null;
		Stopwatch stopwatch = Stopwatch.createStarted();
		String completionStatus = "failed";
		try {

			print("\nExtracting RF2 International Edition Data...");
			intLoadingArea = unzipArchive(intRf2Archive);
			intReleaseDate = findDateInString(intLoadingArea.listFiles()[0].getName(), false);
			determineEdition(intLoadingArea, Edition.INTERNATIONAL, intReleaseDate);
			
			if (extRf2Archive != null) {
				print("\nExtracting RF2 Extension Data...");
				extloadingArea = unzipArchive(extRf2Archive);
				extReleaseDate = findDateInString(extloadingArea.listFiles()[0].getName(), false);
				determineEdition(extloadingArea, null, extReleaseDate);	
				isExtension = true;
			}
			
			long maxOperations = getMaxOperations();
			if (isExtension) {
				maxOperations = includeHistory? maxOperations : 388;
			} else {
				maxOperations = includeHistory? maxOperations : 391;
			}
			setMaxOperations(maxOperations);
			
			EditionConfig config = knownEditionMap.get(edition);
			completeOutputMap(config);
			db.runStatement("SET @langCode = '" + config.langCode + "'");
			db.runStatement("SET @langRefSet = '" + config.dialects[0].langRefSetId + "'");
			
			print("\nLoading " + Edition.INTERNATIONAL +" common RF2 Data...");
			loadRF2Data(intLoadingArea,  Edition.INTERNATIONAL, intReleaseDate, intfileToTable);
			
			//Load the rest of the files from the same loading area if International Release, otherwise use the extensionLoading  Area
			File loadingArea = isExtension ? extloadingArea : intLoadingArea;
			String releaseDate = isExtension ? extReleaseDate : intReleaseDate;
			print("\nLoading " + edition +" RF2 Data...");
			loadRF2Data(loadingArea, edition, releaseDate, extfileToTable);				

			debug("\nCreating RF2 indexes...");
			db.executeResource("create_rf2_indexes.sql");

			print("\nCalculating RF2 snapshot...");
			calculateRF2Snapshot(releaseDate);

			print("\nConverting RF2 to RF1...");
			convert();

			print("\nExporting RF1 to file...");
			exportArea = Files.createTempDir();
			exportRF1Data(intExportMap, intReleaseDate, knownEditionMap.get(edition), exportArea);
			exportRF1Data(extExportMap, extReleaseDate, knownEditionMap.get(edition), exportArea);

			
			print("\nZipping archive");
			createArchive(exportArea);

			completionStatus = "completed";
		} finally {
			print("\nProcess " + completionStatus + " in " + stopwatch + " after completing " + getProgress() + "/" + getMaxOperations()
					+ " operations.");
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
				
				if (extloadingArea != null && extloadingArea.exists()) {
					FileUtils.deleteDirectory(extloadingArea);
				}

				if (exportArea != null && exportArea.exists()) {
					FileUtils.deleteDirectory(exportArea);
				}
			} catch (Exception e) {
				debug("Error while cleaning up loading/export Areas " + e.getMessage());
			}
		}
		
	}

	private void completeOutputMap(EditionConfig editionConfig) {
		if (isExtension) {
			String archiveName = "SnomedCT_OUT_INT_DATE";
			String folderName = "Language-" + editionConfig.langCode;
			String fileRoot = archiveName + File.separator + "Subsets" + File.separator + folderName + File.separator;
			String fileName = "der1_SubsetMembers_"+ editionConfig.langCode + "_INT_DATE.txt";
			extExportMap.put(fileRoot + fileName,
					"select s.SubsetId, s.MemberID, s.MemberStatus, s.LinkedID from rf21_SUBSETS s, rf21_SUBSETLIST sl where s.SubsetOriginalId = sl.subsetOriginalId AND sl.languageCode = ''" + editionConfig.langCode + "'';");
			
			fileName = "der1_Subsets_" + editionConfig.langCode + "_INT_DATE.txt";
			extExportMap.put(fileRoot + fileName,
					"select sl.* from rf21_SUBSETLIST sl where languagecode = ''" + editionConfig.langCode + "'';");
			extExportMap.put("SnomedCT_OUT_INT_DATE/Resources/TextDefinitions/sct1_TextDefinitions_LNG_INT_DATE.txt",
					"select * from rf21_DEF");
		} else {
			extExportMap.put("SnomedCT_OUT_INT_DATE/Resources/TextDefinitions/sct1_TextDefinitions_en-US_INT_DATE.txt",
					"select * from rf21_DEF");
			extExportMap
			.put("SnomedCT_OUT_INT_DATE/Subsets/Language-en-GB/der1_SubsetMembers_en-GB_INT_DATE.txt",
					"select s.SubsetId, s.MemberID, s.MemberStatus, s.LinkedID from rf21_SUBSETS s, rf21_SUBSETLIST sl where s.SubsetOriginalId = sl.subsetOriginalId AND sl.languageCode in (''en'',''en-GB'')");
			extExportMap.put("SnomedCT_OUT_INT_DATE/Subsets/Language-en-GB/der1_Subsets_en-GB_INT_DATE.txt",
					"select sl.* from rf21_SUBSETLIST sl where languagecode like ''%GB%''");
			extExportMap
					.put("SnomedCT_OUT_INT_DATE/Subsets/Language-en-US/der1_SubsetMembers_en-US_INT_DATE.txt",
							"select s.SubsetId, s.MemberID, s.MemberStatus, s.LinkedID from rf21_SUBSETS s, rf21_SUBSETLIST sl where s.SubsetOriginalId = sl.subsetOriginalId AND sl.languageCode in (''en'',''en-US'')");
			extExportMap.put("SnomedCT_RF1Release_INT_DATE/Subsets/Language-en-US/der1_Subsets_en-US_INT_DATE.txt",
			"select sl.* from rf21_SUBSETLIST sl where languagecode like ''%US%''");
		}
	}

	private void determineEdition(File loadingArea, Edition enforceEdition, String releaseDate) throws RF1ConversionException {
		//Loop through known editions and see if EDITION_DETERMINER file is present
		for (Map.Entry<Edition, EditionConfig> thisEdition : knownEditionMap.entrySet())
			for (File thisFile : loadingArea.listFiles()) {
				EditionConfig parts = thisEdition.getValue();
				String target = EDITION_DETERMINER.replace(EXT, parts.editionName)
									.replace(LNG, parts.langCode)
									.replace(DATE, releaseDate);
				if (thisFile.getName().equals(target)) {
					this.edition = thisEdition.getKey();
					if (enforceEdition != null && this.edition != enforceEdition) {
						throw new RF1ConversionException("Needed " + enforceEdition + ", instead found " + this.edition);
					}
					return;
				}
			}
		throw new RF1ConversionException ("Failed to fine file matching any known edition: " + EDITION_DETERMINER + " in" + loadingArea.getAbsolutePath());
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
		unzipFlat(archive, tempDir, "Full");
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

	private void convert() throws RF1ConversionException {
		db.executeResource("create_rf1_schema.sql");
		if (includeHistory) {
			db.executeResource("populate_rf1_historical.sql");
		} else {
			print("\nSkipping generation of RF1 History.  Set -h parameter if this is required.");
		}
		db.executeResource("populate_rf1.sql");
		if (isExtension) {
			db.executeResource("populate_rf1_ext_descriptions.sql");
		} else {
			db.executeResource("populate_rf1_int_descriptions.sql");
		}
		db.executeResource("populate_rf1_associations.sql");
	}

	private void init(String[] args, File dbLocation) throws RF1ConversionException {
		if (args.length < 1) {
			print("Usage: java ConversionManager [-v] [-u <unzip location>] <rf2 archive location> [<rf2 extension archive>]");
			exit();
		}
		boolean isUnzipLocation = false;

		for (String thisArg : args) {
			if (thisArg.equals("-v")) {
				GlobalUtils.verbose = true;
			} else if (thisArg.equals("-h")) {
				includeHistory = true;
			} else if (thisArg.equals("-u")) {
				isUnzipLocation = true;
			} else if (isUnzipLocation) {
				unzipLocation = new File(thisArg);
				if (!unzipLocation.isDirectory()) {
					throw new RF1ConversionException(thisArg + " is an invalid location to unzip archive to!");
				}
				isUnzipLocation = false;
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
			print("Unable to determine RF2 Archive: " + args[args.length - 1]);
			exit();
		}

		db = new DBManager();
		db.init(dbLocation);
	}

	private void loadRF2Data(File loadingArea, Edition edition, String releaseDate, Map<String, String> fileToTable) throws RF1ConversionException {
		// We can do the load in parallel. Only 3 threads because heavily I/O
		db.startParallelProcessing(3);
		for (Map.Entry<String, String> entry : fileToTable.entrySet()) {
			// Replace DATE in the filename with the actual release date
			String fileName = entry.getKey().replace(DATE, releaseDate)
								.replace(EXT, knownEditionMap.get(edition).editionName)
								.replace(LNG, knownEditionMap.get(edition).langCode);
			File file = new File(loadingArea + File.separator + fileName);
			
			//Only load each file once
			if (filesLoaded.contains(file)) {
				debug ("Skipping " + file.getName() + " already loaded as part of Internation Edition");
			} else if (file.exists()) {
				db.load(file, entry.getValue());
				filesLoaded.add(file);
			} else {
				print("\nWarning, skipping load of file " + file.getName() + " - not present");
			}
		}
		db.finishParallelProcessing();
	}

	private void exportRF1Data(Map<String, String> exportMap, String releaseDate, EditionConfig editionConfig, File exportArea) throws RF1ConversionException {
		// We can do the export in parallel. Only 3 threads because heavily I/O
		db.startParallelProcessing(3);
		for (Map.Entry<String, String> entry : exportMap.entrySet()) {
			// Replace DATE in the filename with the actual release date
			String fileName = entry.getKey().replace(DATE, releaseDate)
					.replace(OUT, editionConfig.outputName)
					.replace(LNG, editionConfig.langCode);
			String filePath = exportArea + File.separator + fileName;
			db.export(filePath, entry.getValue());
		}
		db.finishParallelProcessing();
	}

}
