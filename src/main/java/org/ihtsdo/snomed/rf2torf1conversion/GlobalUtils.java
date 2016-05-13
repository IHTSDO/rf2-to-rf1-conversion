package org.ihtsdo.snomed.rf2torf1conversion;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;

import org.apache.commons.io.IOUtils;

public class GlobalUtils {

	public static boolean verbose;

	private static long maxOperations = 448;
	private static long queriesRun = 0;
	private static String BETA_PREFIX = "x";

	public static void print(String msg) {
		System.out.println(msg);
	}

	public static void printn(String msg) {
		System.out.print(msg);
	}

	public static void exit() {
		System.exit(-1);
	}

	public static void debug(String msg) {
		if (verbose) {
			System.out.println(msg);
		}
	}

	public static void unzipFlat(File archive, File targetDir, String[] matchArray) throws RF1ConversionException {

		if (!targetDir.exists() || !targetDir.isDirectory()) {
			throw new RF1ConversionException(targetDir + " is not a viable directory in which to extract archive");
		}
		try {
			ZipInputStream zis = new ZipInputStream(new FileInputStream(archive));
			ZipEntry ze = zis.getNextEntry();
			try {
				while (ze != null) {
					if (!ze.isDirectory()) {
						Path p = Paths.get(ze.getName());
						String extractedFilename = p.getFileName().toString();
						for (String matchStr : matchArray) {
							if (matchStr == null || extractedFilename.contains(matchStr)) {
								//If the filename is a beta file with x prefix, remove the prefix
								if (extractedFilename.startsWith(BETA_PREFIX)) {
									extractedFilename = extractedFilename.substring(1);
								}
								debug("Extracting " + extractedFilename);
								File extractedFile = new File(targetDir, extractedFilename);
								OutputStream out = new FileOutputStream(extractedFile);
								IOUtils.copy(zis, out);
								IOUtils.closeQuietly(out);
								updateProgress();
							}
						}
					}
					ze = zis.getNextEntry();
				}
			} finally {
				zis.closeEntry();
				zis.close();
			}
		} catch (IOException e) {
			throw new RF1ConversionException("Failed to expand archive " + archive.getName(), e);
		}
	}

	public static String findDateInString(String str, boolean optional) throws RF1ConversionException {
		Matcher dateMatcher = Pattern.compile("(\\d{8})").matcher(str);
		if (dateMatcher.find()) {
			return dateMatcher.group();
		} else {
			if (optional) {
				print("Did not find a date in: " + str);
			} else {
				throw new RF1ConversionException("Unable to determine date from " + str);
			}
		}
		return null;
	}

	public static long getProgress() {
		return queriesRun;
	}

	public static long getMaxOperations() {
		return GlobalUtils.maxOperations;
	}
	
	synchronized public static void setMaxOperations(long maxOperations) {
		GlobalUtils.maxOperations = maxOperations;
	}

	synchronized public static void updateProgress() {
		queriesRun++;
		if (!verbose && queriesRun <= maxOperations) {
			double percentageComplete = (((double)queriesRun) / ((double)maxOperations)) * 100d;
			printn("\r" + String.format("%.2f", percentageComplete) + "% complete.");
		}
	}

	public static void createArchive(File exportLocation) throws RF1ConversionException {
		try {
			// The zip filename will be the name of the first thing in the zip location
			// ie in this case the directory SnomedCT_RF1Release_INT_20150731
			String zipFileName = exportLocation.listFiles()[0].getName() + ".zip";
			int fileNameModifier = 1;
			while (new File(zipFileName).exists()) {
				zipFileName = exportLocation.listFiles()[0].getName() + "_" + fileNameModifier++ + ".zip";
			}
			ZipOutputStream out = new ZipOutputStream(new FileOutputStream(zipFileName));
			String rootLocation = exportLocation.getAbsolutePath() + File.separator;
			debug("Creating archive : " + zipFileName + " from files found in " + rootLocation);
			addDir(rootLocation, exportLocation, out);
			out.close();
		} catch (IOException e) {
			throw new RF1ConversionException("Failed to create RF1 Archive from " + exportLocation, e);
		}
	}

	public static void addDir(String rootLocation, File dirObj, ZipOutputStream out) throws IOException {
		File[] files = dirObj.listFiles();
		byte[] tmpBuf = new byte[1024];

		for (int i = 0; i < files.length; i++) {
			if (files[i].isDirectory()) {
				addDir(rootLocation, files[i], out);
				continue;
			}
			FileInputStream in = new FileInputStream(files[i].getAbsolutePath());
			String relativePath = files[i].getAbsolutePath().substring(rootLocation.length());
			debug(" Adding: " + relativePath);
			updateProgress();
			out.putNextEntry(new ZipEntry(relativePath));
			int len;
			while ((len = in.read(tmpBuf)) > 0) {
				out.write(tmpBuf, 0, len);
			}
			out.closeEntry();
			in.close();
		}
	}
}
