package org.ihtsdo.snomed.rf2torf1conversion.pojo;

import java.util.ArrayList;
import java.util.List;

public class QualifyingRelationshipAttribute implements Comparable<QualifyingRelationshipAttribute>{
	
	public Concept getType() {
		return type;
	}

	public Concept getDestination() {
		return destination;
	}

	private Concept type;
	private Concept destination;
	private List<QualifyingRelationshipRule> rules;
	private Integer refinability;
	
	public Integer getRefinability() {
		return refinability;
	}

	private transient int hash;
	
	private QualifyingRelationshipAttribute() {
		rules = new ArrayList<QualifyingRelationshipRule>();
	}

	public QualifyingRelationshipAttribute(Concept type, Concept destination, int refinability) {
		this();
		this.type = type;
		this.destination = destination;
		this.refinability = refinability;
		String hashStr = type.getSctId().toString() + "_" + destination.getSctId().toString();
		hash = hashStr.hashCode();
	}
	
	public void addRule(QualifyingRelationshipRule rule) {
		this.rules.add(rule);
	}
	
	public boolean equals(Object obj) {
		if (!(obj instanceof QualifyingRelationshipAttribute)) {
			return false;
		} else {
			QualifyingRelationshipAttribute thisTD = (QualifyingRelationshipAttribute)obj;
			if (this.type.equals(thisTD.type) && this.destination.equals(thisTD.destination)) {
				return true;
			}
		}
		return false;
	}
	
	public List<QualifyingRelationshipRule> getRules() {
		return rules;
	}
	
	public String toString() {
		return "[T: " + type.getSctId() + 
				" D: " + destination.getSctId() + "]";
	}

	public int hashCode() {
		return hash;
	}

	@Override
	public int compareTo(QualifyingRelationshipAttribute other) {
		return this.toString().compareTo(other.toString());
	}

}
