package org.ihtsdo.snomed.rf2torf1conversion.pojo;

import java.util.Set;

public class QualifyingRelationshipRule implements SnomedExpressions {

	String startPoint;  //A SNOMED EXPRESSION DESCENDENT or DESCENDENT AND SELF
	String endPoint;
	Set<Concept> exceptions;
	String[] parts;
	
	public QualifyingRelationshipRule (Concept startPointConcept, CONSTRAINT constraint, Set<Concept> exceptions) {
		this.startPoint = constraint + startPointConcept.toString();
		this.exceptions = exceptions;
	}
	
	public Concept getStartPoint() {
		parts = startPoint.split(" ");
		return Concept.getConcept(Long.parseLong(parts[1]));
	}

	public String getEndPoint() {
		return endPoint;
	}

	public Set<Concept> getExceptions() {
		return exceptions;
	}
	
}
