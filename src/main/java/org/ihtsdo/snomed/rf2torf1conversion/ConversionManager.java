package org.ihtsdo.snomed.rf2torf1conversion;

import static org.ihtsdo.snomed.rf2torf1conversion.GlobalUtils.*;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.io.FileUtils;

import com.google.common.io.Files;

public class ConversionManager {

	File rf2Archive;
	DBManager db;
	String releaseDate;
	
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
		exportMap.put("sct1_ComponentHistory_Core_INT_DATE.txt", "select * from rf21_COMPONENTHISTORY");
		exportMap.put("sct1_TextDefinitions_en-US_INT_DATE.txt", "select * from rf21_DEF");
		exportMap.put("sct1_References_Core_INT_DATE.txt", "select * from rf21_REFERENCE");
		exportMap.put("der1_SubsetMembers_en-GB_INT_DATE.txt", "select s.* from rf21_SUBSETS s, rf21_SUBSETLIST sl where s.subsetid = sl.subsetid AND sl.languageCode in (''en'',''en-GB'')");
		exportMap.put("der1_SubsetMembers_en-US_INT_DATE.txt", "select s.* from rf21_SUBSETS s, rf21_SUBSETLIST sl where s.subsetid = sl.subsetid AND sl.languageCode in (''en'',''en-US'')");
		exportMap.put("der1_Subsets_en-GB_INT_DATE.txt", "select sl.* from rf21_SUBSETLIST sl where languagecode like ''%GB%''");
		exportMap.put("der1_Subsets_en-GB_INT_DATE.txt", "select sl.* from rf21_SUBSETLIST sl where languagecode like ''%GB%''");
		// exportMap.put("rf21_XMAPLIST");
		// exportMap.put("rf21_XMAPS");
		// exportMap.put("rf21_XMAPTARGET");
		exportMap.put("sct1_Concepts_Core_INT_DATE.txt", "select * from rf21_concept");
		exportMap.put("sct1_Relationships_Core_INT_DATE.txt", "select * from rf21_rel");
		exportMap.put("sct1_Descriptions_en_INT_DATE.txt", "select * from rf21_term");

	}

	public static void main(String[] args) throws RF1ConversionException {
		ConversionManager cm = new ConversionManager();
		File tempDBLocation = Files.createTempDir();
		cm.init(args, tempDBLocation);
		cm.createDatabaseSchema();
		File loadingArea = null;
		try {
			print("Extracting RF2 Data...");
			loadingArea = cm.unzipArchive();

			print("Loading RF2 Data...");
			cm.releaseDate = findDateInString(loadingArea.listFiles()[0].getName(), false);
			cm.loadRF2Data(loadingArea);

			print("Creating indexes...");
			cm.db.executeResource("create_rf2_indexes.sql");

			print("Calculating RF2 snapshot...");
			cm.calculateRF2Snapshot();

			print("Converting RF2 to RF1...");
			cm.convert();

			print("Exporting RF1 to file...");
			cm.exportRF1Data();
		} finally {
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
			} catch (Exception e) {
				debug("Error while cleaning up loading Area " + loadingArea.getPath() + e.getMessage());
			}
		}
	}

	private void calculateRF2Snapshot() throws RF1ConversionException {
		String setDateSql = "SET @RDATE = " + releaseDate;
		db.executeSql(setDateSql);
		db.executeResource("create_rf2_snapshot.sql");
		db.executeResource("populate_subset_2_refset.sql");
	}

	private File unzipArchive() throws RF1ConversionException {
		File tempDir = Files.createTempDir();
		// We only need to work with the full files
		GlobalUtils.unzipFlat(rf2Archive, tempDir, "Full");
		return tempDir;
	}

	private void createDatabaseSchema() throws RF1ConversionException {
		print("Creating database schema");
		db.executeResource("create_schema.sql");
		// db.executeResource("create_rf2_utility_procedures.sql");
		// db.executeResource("create_rf2_extract_snapshot_procedure.sql");
	}

	private void convert() throws RF1ConversionException {
		db.executeResource("populateRF1.sql");
	}

	private void init(String[] args, File dbLocation) throws RF1ConversionException {
		if (args.length < 1) {
			print("Usage: java ConversionManager [-v] <rf2 archive location>");
			exit();
		}

		for (String thisArg : args) {
			if (thisArg.equals("-v")) {
				GlobalUtils.verbose = true;
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

		for (Map.Entry<String, String> entry : fileToTable.entrySet()) {
			// Replace DATE in the filename with the actual release date
			String fileName = entry.getKey().replace("DATE", releaseDate);
			File file = new File(loadingArea + File.separator + fileName);
			db.load(file, entry.getValue());
		}
	}

	private void exportRF1Data() throws RF1ConversionException {
		for (Map.Entry<String, String> entry : exportMap.entrySet()) {
			// Replace DATE in the filename with the actual release date
			String fileName = entry.getKey().replace("DATE", releaseDate);
			File file = new File(fileName);
			db.export(file, entry.getValue());
		}
	}

}
