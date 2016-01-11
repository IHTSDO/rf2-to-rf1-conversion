package org.ihtsdo.snomed.rf2torf1conversion;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import org.apache.commons.io.IOUtils;

public class GlobalUtils {

	public static boolean verbose;

	public static void print(String msg) {
		System.out.println(msg);
	}

	public static void exit() {
		System.exit(-1);
	}

	public static void debug(String msg) {
		if (verbose) {
			System.out.println(msg);
		}
	}

	public static void unzipFlat(File archive, File targetDir, String matchStr) throws RF1ConversionException {

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
						String extractedFileName = p.getFileName().toString();
						if (matchStr == null || extractedFileName.contains(matchStr)) {
							File extractedFile = new File(targetDir, extractedFileName);
							OutputStream out = new FileOutputStream(extractedFile);
							IOUtils.copy(zis, out);
							IOUtils.closeQuietly(out);
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
}
