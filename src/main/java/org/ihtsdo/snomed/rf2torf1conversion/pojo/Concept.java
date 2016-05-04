package org.ihtsdo.snomed.rf2torf1conversion.pojo;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

public class Concept implements Comparable<Concept> {

	private static Map<Long, Concept> allInferredConcepts = new HashMap<Long, Concept>();

	private Long sctId;
	Set<Concept> parents = new TreeSet<Concept>();
	Set<Concept> children = new TreeSet<Concept>();

	public static final int DEPTH_NOT_SET = -1;
	public static final int IMMEDIATE_CHILDREN_ONLY = 1;

	public Concept(Long id) {
		this.sctId = id;
	}

	public static Concept getConcept(long sctId) {
		return allInferredConcepts.get(sctId);
	}

	public static Concept registerConcept(String sctIdStr) {

		Long sctId = new Long(sctIdStr);
		// Do we know about this concept?
		Concept concept;
		if (!allInferredConcepts.containsKey(sctId)) {
			concept = new Concept(sctId);
			allInferredConcepts.put(sctId, concept);
		} else {
			concept = allInferredConcepts.get(sctId);
		}
		return concept;
	}


	public void addAttribute(Relationship r) {
		assert this.equals(r.getSourceConcept());

		// Is this an IS A relationship? Add as a parent if so
		if (r.isISA()) {
			parents.add(r.getDestinationConcept());
			// And tell that parent that it has a child
			r.getDestinationConcept().children.add(this);
		} else {
			// For RF1 conversion we're only interested in ISA hierarchy
		}
	}

	@Override
	public int compareTo(Concept other) {
		return this.sctId.compareTo(other.sctId);
	}

	@Override
	public boolean equals(Object other) {
		if (other instanceof Concept) {
			Concept otherConcept = (Concept) other;
			return this.sctId.equals(otherConcept.sctId);
		}
		return false;
	}
	
	@Override
	public int hashCode() {
		return getSctId().toString().hashCode();
	}

	public Long getSctId() {
		return sctId;
	}

	public Set<Concept> getDescendents(int depth) {
		return populateDescendents(new HashSet<Concept>(), depth);
	}

	private Set<Concept> populateDescendents(Set<Concept> allDescendents, int depth) {
		for (Concept thisChild : children) {
			allDescendents.add(thisChild);
			if (depth == DEPTH_NOT_SET || depth > 1) {
				int newDepth = depth == DEPTH_NOT_SET ? DEPTH_NOT_SET : depth - 1;
				thisChild.populateDescendents(allDescendents, newDepth);
			}
		}
		return allDescendents;
	}

	public Set<Concept> getParents() {
		return parents;
	}

	public String toString() {
		return sctId.toString();
	}

	public Set<Concept> getAllDescendents(int depth) {
		Set<Concept> allDescendents = new HashSet<Concept>();
		this.populateAllDescendents(allDescendents, depth);
		return allDescendents;
	}
	
	private void populateAllDescendents(Set<Concept> descendents, int depth) {
		for (Concept thisChild : children) {
			descendents.add(thisChild);
			if (depth == DEPTH_NOT_SET || depth > 1) {
				int newDepth = depth == DEPTH_NOT_SET ? DEPTH_NOT_SET : depth - 1;
				thisChild.populateAllDescendents(descendents, newDepth);
			}
		}
	}


}
