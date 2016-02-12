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

	File rf2Archive;
	File unzipLocation = null;
	DBManager db;
	String releaseDate;
	boolean includeHistory = false;
	
	static Map<String, String> fileToTable = new HashMap<String, String>();
	{
		fileToTable.put("sct2_Concept_Full_INT_DATE.txt", "rf2_concept_sv");
		fileToTable.put("sct2_Description_Full-en_INT_DATE.txt", "rf2_term_sv");
		fileToTable.put("sct2_Relationship_Full_INT_DATE.txt", "rf2_rel_sv");
		fileToTable.put("sct2_StatedRelationship_Full_INT_DATE.txt", "rf2_rel_sv");
		fileToTable.put("sct2_Identifier_Full_INT_DATE.txt", "rf2_identifier_sv");
		fileToTable.put("sct2_TextDefinition_Full-en_INT_DATE.txt", "rf2_def_sv");

		fileToTable.put("der2_cRefset_AssociationReferenceFull_INT_DATE.txt", "rf2_crefset_sv");
		fileToTable.put("der2_cRefset_AttributeValueFull_INT_DATE.txt", "rf2_crefset_sv");
		fileToTable.put("der2_Refset_SimpleFull_INT_DATE.txt", "rf2_refset_sv");

		fileToTable.put("der2_cRefset_LanguageFull-en_INT_DATE.txt", "rf2_crefset_sv");

		fileToTable.put("der2_sRefset_SimpleMapFull_INT_DATE.txt", "rf2_srefset_sv");
		fileToTable.put("der2_iissscRefset_ComplexMapFull_INT_DATE.txt", "rf2_iissscrefset_sv");
		fileToTable.put("der2_iisssccRefset_ExtendedMapFull_INT_DATE.txt", "rf2_iisssccrefset_sv");

		fileToTable.put("der2_cciRefset_RefsetDescriptorFull_INT_DATE.txt", "rf2_ccirefset_sv");
		fileToTable.put("der2_ciRefset_DescriptionTypeFull_INT_DATE.txt", "rf2_cirefset_sv");
		fileToTable.put("der2_ssRefset_ModuleDependencyFull_INT_DATE.txt", "rf2_ssrefset_sv");
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
				.put("SnomedCT_RF1Release_INT_DATE/Terminology/Content/sct1_Descriptions_en_INT_DATE.txt",
						"select DESCRIPTIONID, DESCRIPTIONSTATUS, CONCEPTID, TERM, INITIALCAPITALSTATUS, US_DESC_TYPE as DESCRIPTIONTYPE, LANGUAGECODE from rf21_term where languageCode in (''en-US'')"
								+ " UNION "
								+ "select DESCRIPTIONID, DESCRIPTIONSTATUS, CONCEPTID, TERM, INITIALCAPITALSTATUS, GB_DESC_TYPE as DESCRIPTIONTYPE, LANGUAGECODE from rf21_term where languageCode =''en-GB''"
								+ " UNION "
								+ "select DESCRIPTIONID, DESCRIPTIONSTATUS, CONCEPTID, TERM, INITIALCAPITALSTATUS, DESC_TYPE as DESCRIPTIONTYPE, LANGUAGECODE from rf21_term where languageCode =''en''");
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
		File tempDBLocation = Files.createTempDir();
		cm.init(args, tempDBLocation);
		cm.createDatabaseSchema();
		File loadingArea = null;
		File exportArea = null;
		Stopwatch stopwatch = Stopwatch.createStarted();
		String completionStatus = "failed";
		try {

			print("\nExtracting RF2 Data...");
			loadingArea = cm.unzipArchive();

			print("\nLoading RF2 Data...");
			cm.releaseDate = findDateInString(loadingArea.listFiles()[0].getName(), false);

			cm.loadRF2Data(loadingArea);

			debug("\nCreating RF2 indexes...");
			cm.db.executeResource("create_rf2_indexes.sql");

			print("\nCalculating RF2 snapshot...");
			cm.calculateRF2Snapshot();

			print("\nConverting RF2 to RF1...");
			cm.convert();

			print("\nExporting RF1 to file...");
			exportArea = cm.exportRF1Data();

			print("\nZipping archive");
			createArchive(exportArea);

			completionStatus = "completed";
		} finally {
			print("\nProcess " + completionStatus + " in " + stopwatch + " after completing " + getProgress() + "/" + getMaxOperations()
					+ " operations.");
			print("Cleaning up resources...");
			try {
				cm.db.shutDown(true); // Also deletes all files
				if (tempDBLocation != null && tempDBLocation.exists()) {
					tempDBLocation.delete();
				}
			} catch (Exception e) {
				debug("Error while cleaning up database " + tempDBLocation.getPath() + e.getMessage());
			}
			try {
				if (loadingArea != null && loadingArea.exists()) {
					FileUtils.deleteDirectory(loadingArea);
				}

				if (exportArea != null && exportArea.exists()) {
					FileUtils.deleteDirectory(exportArea);
				}
			} catch (Exception e) {
				debug("Error while cleaning up loading/export Areas " + loadingArea.getPath() + e.getMessage());
			}
		}
	}

	private File unzipArchive() throws RF1ConversionException {

		File tempDir = null;
		try {
			if (unzipLocation != null) {
				tempDir = File.createTempFile("rf2-to-rf1", "", unzipLocation);
				tempDir.mkdirs();
			} else {
				// Work in the traditional temp file location for the OS
				tempDir = Files.createTempDir();
			}
		} catch (IOException e) {
			throw new RF1ConversionException("Unable to create temporary directory for archive extration");
		}
		// We only need to work with the full files
		unzipFlat(rf2Archive, tempDir, "Full");
		return tempDir;
	}

	private void createDatabaseSchema() throws RF1ConversionException {
		print("Creating database schema");
		db.executeResource("create_rf2_schema.sql");
	}

	private void calculateRF2Snapshot() throws RF1ConversionException {
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
			print("Skipping generation of RF1 History.  Set -h parameter if this is required.");
		}
		db.executeResource("populate_rf1.sql");
	}

	private void init(String[] args, File dbLocation) throws RF1ConversionException {
		if (args.length < 1) {
			print("Usage: java ConversionManager [-v] [-u <unzip location>] <rf2 archive location>");
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
			} else {
				File possibleArchive = new File(thisArg);
				if (possibleArchive.exists() && !possibleArchive.isDirectory() && possibleArchive.canRead()) {
					rf2Archive = possibleArchive;
				}
			}
		}

		if (rf2Archive == null) {
			print("Unable to read RF2 Archive: " + args[args.length - 1]);
			exit();
		}

		db = new DBManager();
		db.init(dbLocation);
	}

	private void loadRF2Data(File loadingArea) throws RF1ConversionException {
		// We can do the load in parallel. Only 3 threads because heavily I/O
		db.startParallelProcessing(3);
		for (Map.Entry<String, String> entry : fileToTable.entrySet()) {
			// Replace DATE in the filename with the actual release date
			String fileName = entry.getKey().replace("DATE", releaseDate);
			File file = new File(loadingArea + File.separator + fileName);
			db.load(file, entry.getValue());
		}
		db.finishParallelProcessing();
	}

	private File exportRF1Data() throws RF1ConversionException {
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
