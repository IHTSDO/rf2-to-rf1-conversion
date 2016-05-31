package org.ihtsdo.snomed.rf2torf1conversion;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.ihtsdo.snomed.rf2torf1conversion.pojo.RF2SchemaConstants;
import org.ihtsdo.snomed.rf2torf1conversion.pojo.Relationship;

public class GraphLoader implements RF2SchemaConstants {

	private final String inferredFile;
	private Map<String, Relationship> inferredRelationships;

	public GraphLoader(String inferredFile) {
		this.inferredFile = inferredFile;
	}
	
	public void loadRelationships() throws RF1ConversionException {
		inferredRelationships = loadRelationshipFile(inferredFile, CHARACTERISTIC.INFERRED);
	}
	

	private Map<String, Relationship> loadRelationshipFile(String filePath, CHARACTERISTIC characteristic) throws RF1ConversionException {
		Map<String, Relationship> loadedRelationships = new HashMap<String, Relationship>();
		try {
			// Does this file exist and not as a directory?
			File file = getFile(filePath);

			try (BufferedReader br = new BufferedReader(new FileReader(file))) {
				String line;
				boolean isFirstLine = true;
				while ((line = br.readLine()) != null) {
					if (!isFirstLine) {
						String[] lineItems = line.split(FIELD_DELIMITER);
						// Only store active ISA relationships
						if (lineItems[REL_IDX_ACTIVE].equals(ACTIVE_FLAG)
								&& !lineItems[REL_IDX_CHARACTERISTICTYPEID].equals(ADDITIONAL_RELATIONSHIP)) {
							Relationship r = new Relationship(lineItems, characteristic);
							loadedRelationships.put(r.getUuid(), r);
						}
					} else {
						isFirstLine = false;
						continue;
					}
				}
			}
		} catch (IOException e) {
			throw new RF1ConversionException ("IO Exception while loading Relationship file: " + filePath, e);
		}
		return loadedRelationships;
	}
	
	private File getFile(String filePath) throws IOException {
		// Does this file exist and not as a directory?
		File file = new File(filePath);
		if (!file.exists() || file.isDirectory()) {
			throw new IOException("Unable to read file " + filePath);
		}
		return file;
	}


}
