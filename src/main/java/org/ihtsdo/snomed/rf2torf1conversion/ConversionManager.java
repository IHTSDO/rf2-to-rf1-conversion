package org.ihtsdo.snomed.rf2torf1conversion;

import static org.ihtsdo.snomed.rf2torf1conversion.GlobalUtils.*;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

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
	
	enum Edition { INTERNATIONAL, SPANISH };
	
	class EditionFilenameParts {
		String editionName;
		String language;
		EditionFilenameParts (String editionName, String language) {
			this.editionName = editionName;
			this.language = language;
		}
	}
	
	private static final String EDITION_DETERMINER = "sct2_Description_EXTFull-LNG_INT_DATE.txt";
	
	static Map<Edition, EditionFilenameParts> knownEditionMap = new HashMap<Edition, EditionFilenameParts>();
	{
		knownEditionMap.put(Edition.INTERNATIONAL, new EditionFilenameParts("","en"));   //International Edition has no Extension name
		knownEditionMap.put(Edition.SPANISH, new EditionFilenameParts("SpanishExtension", "es"));
	}
	
	static Map<String, String> fileToTable = new HashMap<String, String>();
	{
		fileToTable.put("sct2_Concept_EXTFull_INT_DATE.txt", "rf2_concept_sv");
		fileToTable.put(EDITION_DETERMINER, "rf2_term_sv");
		fileToTable.put("sct2_Relationship_EXTFull_INT_DATE.txt", "rf2_rel_sv");
		fileToTable.put("sct2_StatedRelationship_EXTFull_INT_DATE.txt", "rf2_rel_sv");
		fileToTable.put("sct2_Identifier_EXTFull_INT_DATE.txt", "rf2_identifier_sv");
		fileToTable.put("sct2_TextDefinition_EXTFull-en_INT_DATE.txt", "rf2_def_sv");

		fileToTable.put("der2_cRefset_AssociationReferenceEXTFull_INT_DATE.txt", "rf2_crefset_sv");
		fileToTable.put("der2_cRefset_AttributeValueEXTFull_INT_DATE.txt", "rf2_crefset_sv");
		fileToTable.put("der2_Refset_SimpleEXTFull_INT_DATE.txt", "rf2_refset_sv");

		fileToTable.put("der2_cRefset_LanguageEXTFull-LNG_INT_DATE.txt", "rf2_crefset_sv");

		fileToTable.put("der2_sRefset_SimpleMapEXTFull_INT_DATE.txt", "rf2_srefset_sv");
		fileToTable.put("der2_iissscRefset_ComplexEXTMapFull_INT_DATE.txt", "rf2_iissscrefset_sv");
		fileToTable.put("der2_iisssccRefset_ExtendedMapEXTFull_INT_DATE.txt", "rf2_iisssccrefset_sv");

		fileToTable.put("der2_cciRefset_RefsetDescriptorEXTFull_INT_DATE.txt", "rf2_ccirefset_sv");
		fileToTable.put("der2_ciRefset_DescriptionTypeEXTFull_INT_DATE.txt", "rf2_cirefset_sv");
		fileToTable.put("der2_ssRefset_ModuleDependencyEXTFull_INT_DATE.txt", "rf2_ssrefset_sv");
	}

	public static final Map<String, String> exportMap = new HashMap<String, String>();
	{
		// The slashes will be replaced with the OS appropriate separator at export time
		exportMap.put("SnomedCT_RF1Release_INT_DATE/Terminology/Content/sct1_Concepts_Core_INT_DATE.txt",
				"select CONCEPTID, CONCEPTSTATUS, FULLYSPECIFIEDNAME, CTV3ID, SNOMEDID, ISPRIMITIVE from rf21_concept");
		exportMap
				.put("SnomedCT_RF1Release_INT_DATE/Terminology/Content/sct1_Relationships_Core_INT_DATE.txt",
						"select RELATIONSHIPID,CONCEPTID1,RELATIONSHIPTYPE,CONCEPTID2,CHARACTERISTICTYPE,REFINABILITY,RELATIONSHIPGROUP from rf21_rel");
		exportMap
				.put("SnomedCT_RF1Release_INT_DATE/Terminology/Content/sct1_Descriptions_LNG_INT_DATE.txt",
						"select DESCRIPTIONID, DESCRIPTIONSTATUS, CONCEPTID, TERM, INITIALCAPITALSTATUS, DESC_TYPE as DESCRIPTIONTYPE, LANGUAGECODE from rf21_term");

		exportMap.put("SnomedCT_RF1Release_INT_DATE/Resources/TextDefinitions/sct1_TextDefinitions_en-US_INT_DATE.txt",
				"select * from rf21_DEF");
		exportMap.put("SnomedCT_RF1Release_INT_DATE/Terminology/History/sct1_ComponentHistory_Core_INT_DATE.txt",
				"select COMPONENTID, RELEASEVERSION, CHANGETYPE, STATUS, REASON from rf21_COMPONENTHISTORY");
		exportMap.put("SnomedCT_RF1Release_INT_DATE/Terminology/History/sct1_References_Core_INT_DATE.txt",
				"select COMPONENTID, REFERENCETYPE, REFERENCEDID from rf21_REFERENCE");
		exportMap
				.put("SnomedCT_RF1Release_INT_DATE/Subsets/Language-en-GB/der1_SubsetMembers_en-GB_INT_DATE.txt",
						"select s.SubsetId, s.MemberID, s.MemberStatus, s.LinkedID from rf21_SUBSETS s, rf21_SUBSETLIST sl where s.SubsetOriginalId = sl.subsetOriginalId AND sl.languageCode in (''en'',''en-GB'')");
		exportMap.put("SnomedCT_RF1Release_INT_DATE/Subsets/Language-en-GB/der1_Subsets_en-GB_INT_DATE.txt",
				"select sl.* from rf21_SUBSETLIST sl where languagecode like ''%GB%''");
		exportMap
				.put("SnomedCT_RF1Release_INT_DATE/Subsets/Language-en-US/der1_SubsetMembers_en-US_INT_DATE.txt",
						"select s.SubsetId, s.MemberID, s.MemberStatus, s.LinkedID from rf21_SUBSETS s, rf21_SUBSETLIST sl where s.SubsetOriginalId = sl.subsetOriginalId AND sl.languageCode in (''en'',''en-US'')");
		exportMap.put("SnomedCT_RF1Release_INT_DATE/Subsets/Language-en-US/der1_Subsets_en-US_INT_DATE.txt",
				"select sl.* from rf21_SUBSETLIST sl where languagecode like ''%US%''");
		exportMap
				.put("SnomedCT_RF1Release_INT_DATE/Resources/StatedRelationships/res1_StatedRelationships_Core_INT_DATE.txt",
						"select RELATIONSHIPID,CONCEPTID1,RELATIONSHIPTYPE,CONCEPTID2,CHARACTERISTICTYPE,REFINABILITY,RELATIONSHIPGROUP from rf21_stated_rel");
		// exportMap.put("rf21_XMAPLIST");
		// exportMap.put("rf21_XMAPS");
		// exportMap.put("rf21_XMAPTARGET");

	}

	public static void main(String[] args) throws RF1ConversionException {
		ConversionManager cm = new ConversionManager();
		cm.doRf2toRf1Conversion(args);
	}

	private void doRf2toRf1Conversion(String[] args) throws RF1ConversionException {
		File tempDBLocation = Files.createTempDir();
		init(args, tempDBLocation);
		createDatabaseSchema();
		File loadingArea1 = null;
		File loadingArea2 = null;
		File exportArea = null;
		Stopwatch stopwatch = Stopwatch.createStarted();
		String completionStatus = "failed";
		try {

			print("\nExtracting RF2 International Edition Data...");
			loadingArea1 = unzipArchive(intRf2Archive);
			intReleaseDate = findDateInString(loadingArea1.listFiles()[0].getName(), false);
			determineEdition(loadingArea1, Edition.INTERNATIONAL, intReleaseDate);
			
			if (extRf2Archive != null) {
				print("\nExtracting RF2 Extension Data...");
				loadingArea2 = unzipArchive(extRf2Archive);
				extReleaseDate = findDateInString(loadingArea2.listFiles()[0].getName(), false);
				determineEdition(loadingArea2, null, extReleaseDate);	
				isExtension = true;
			}
			
			print("\nLoading " + Edition.INTERNATIONAL +" RF2 Data...");
			loadRF2Data(loadingArea1,  Edition.INTERNATIONAL, intReleaseDate);
			
			if (isExtension) {
				print("\nLoading " + edition +" RF2 Data...");
				loadRF2Data(loadingArea2, edition, extReleaseDate);				
			}

			debug("\nCreating RF2 indexes...");
			db.executeResource("create_rf2_indexes.sql");

			print("\nCalculating RF2 snapshot...");
			calculateRF2Snapshot(intReleaseDate);

			print("\nConverting RF2 to RF1...");
			convert();

			print("\nExporting RF1 to file...");
			exportArea = exportRF1Data(isExtension? extReleaseDate : intReleaseDate);

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
				if (loadingArea1 != null && loadingArea1.exists()) {
					FileUtils.deleteDirectory(loadingArea1);
				}
				
				if (loadingArea2 != null && loadingArea2.exists()) {
					FileUtils.deleteDirectory(loadingArea2);
				}

				if (exportArea != null && exportArea.exists()) {
					FileUtils.deleteDirectory(exportArea);
				}
			} catch (Exception e) {
				debug("Error while cleaning up loading/export Areas " + e.getMessage());
			}
		}
		
	}

	private void determineEdition(File loadingArea, Edition enforceEdition, String releaseDate) throws RF1ConversionException {
		//Loop through known editions and see if EDITION_DETERMINER file is present
		for (Map.Entry<Edition, EditionFilenameParts> thisEdition : knownEditionMap.entrySet())
			for (File thisFile : loadingArea.listFiles()) {
				EditionFilenameParts parts = thisEdition.getValue();
				String target = EDITION_DETERMINER.replace(EXT, parts.editionName)
									.replace(LNG, parts.language)
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

	private void loadRF2Data(File loadingArea, Edition edition, String releaseDate) throws RF1ConversionException {
		// We can do the load in parallel. Only 3 threads because heavily I/O
		db.startParallelProcessing(3);
		for (Map.Entry<String, String> entry : fileToTable.entrySet()) {
			// Replace DATE in the filename with the actual release date
			String fileName = entry.getKey().replace(DATE, releaseDate)
								.replace(EXT, knownEditionMap.get(edition).editionName)
								.replace(LNG, knownEditionMap.get(edition).language);
			File file = new File(loadingArea + File.separator + fileName);
			if (file.exists()) {
				db.load(file, entry.getValue());
			} else {
				print("Warning, skipping load of file " + file.getName() + " - no present");
			}
		}
		db.finishParallelProcessing();
	}

	private File exportRF1Data(String releaseDate) throws RF1ConversionException {
		File tempExportLocation = Files.createTempDir();
		// We can do the export in parallel. Only 3 threads because heavily I/O
		db.startParallelProcessing(3);
		for (Map.Entry<String, String> entry : exportMap.entrySet()) {
			// Replace DATE in the filename with the actual release date
			String fileName = entry.getKey().replace("DATE", releaseDate);
			String filePath = tempExportLocation + "/" + fileName;
			db.export(filePath, entry.getValue());
		}
		db.finishParallelProcessing();
		return tempExportLocation;
	}

}
