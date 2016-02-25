package org.ihtsdo.snomed.rf2torf1conversion;

public class RF1ConversionException extends Exception {

	private static final long serialVersionUID = 1L;

	public RF1ConversionException(String msg, Throwable t) {
		super(msg, t);
	}

	public RF1ConversionException(String msg) {
		super(msg);
	}
}
