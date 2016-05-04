package org.ihtsdo.snomed.rf2torf1conversion.pojo;

import java.lang.reflect.Type;

import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonParseException;

public class ConceptDeserializer implements JsonDeserializer<Concept>{
	
	public static String DELIMITER = "\\|";

	@Override
	public Concept deserialize(JsonElement json, Type typeOfT,
			JsonDeserializationContext context) throws JsonParseException {
		//We're going to strip off the FSN when loading from JSON because we only need
		//the sctids for machien processing
		String[] conceptParts = json.getAsString().split(DELIMITER);
		if (conceptParts.length != 2) {
			throw new JsonParseException("Unable to extract SCTID from " + json.getAsString());
		}
		return new Concept(Long.parseLong(conceptParts[0].trim()));
	}
}
