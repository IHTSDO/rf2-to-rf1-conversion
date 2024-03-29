-- PARALLEL_START;
	
	CREATE INDEX idx_conceptv_id ON rf2_concept_sv(ID);
	CREATE INDEX idx_conceptv_et ON rf2_concept_sv(effectiveTime);
	CREATE INDEX idx_termv_id ON rf2_term_sv(ID);
	CREATE INDEX idx_termv_et ON rf2_term_sv(effectiveTime);
	CREATE INDEX idx_termv_cid ON rf2_term_sv(conceptid);
	CREATE INDEX idx_termv_flags ON rf2_term_sv(active, casesignificanceid);
	CREATE INDEX idx_defv_id ON rf2_def_sv(ID);
	CREATE INDEX idx_relv_id ON rf2_rel_sv(ID);
	CREATE INDEX idx_identifierv_id ON rf2_identifier_sv(referencedComponentId,identifierSchemeId);
	CREATE INDEX idx_refsetv_id ON rf2_refset_sv(ID);
	
	CREATE INDEX idx_crefsetv_id ON rf2_crefset_sv(id);
	CREATE INDEX idx_crefsetv_rid ON rf2_crefset_sv(refsetid);
	CREATE INDEX idx_crefsetv_rcid ON rf2_crefset_sv(referencedComponentId);
	CREATE INDEX idx_crefsetv_et ON rf2_crefset_sv(effectiveTime);
	CREATE INDEX idx_crefsetv_a ON rf2_crefset_sv(active);	
	
	CREATE INDEX idx_icrefsetv_id ON rf2_icrefset_sv(ID);
	CREATE INDEX idx_ccirefsetv_id ON rf2_ccirefset_sv(ID);
	CREATE INDEX idx_cirefsetv_id ON rf2_cirefset_sv(ID);
	CREATE INDEX idx_srefsetv_id ON rf2_srefset_sv(ID);
	CREATE INDEX idx_ssrefsetv_id ON rf2_ssrefset_sv(ID);
	CREATE INDEX idx_iissscrefsetv_id ON rf2_iissscrefset_sv(ID);
	CREATE INDEX idx_iissscirefsetv_id ON rf2_iissscirefset_sv(ID);
	
	CREATE INDEX idx_conceptp_id ON rf2_concept_sp(ID);
	CREATE INDEX idx_termp_id ON rf2_term_sp(ID);
	CREATE INDEX idx_defp_id ON rf2_def_sp(ID);
	CREATE INDEX idx_relp_id ON rf2_rel_sp(ID);
	CREATE INDEX idx_identifierp_id ON rf2_identifier_sp(referencedComponentId,identifierSchemeId);
	CREATE INDEX idx_refsetp_id ON rf2_refset_sp(ID);
	CREATE INDEX idx_crefsetp_id ON rf2_crefset_sp(ID);
	CREATE INDEX idx_icrefsetp_id ON rf2_icrefset_sp(ID);
	CREATE INDEX idx_ccirefsetp_id ON rf2_ccirefset_sp(ID);
	CREATE INDEX idx_cirefsetp_id ON rf2_cirefset_sp(ID);
	CREATE INDEX idx_srefsetp_id ON rf2_srefset_sp(ID);
	CREATE INDEX idx_ssrefsetp_id ON rf2_ssrefset_sp(ID);
	CREATE INDEX idx_iissscrefsetp_id ON rf2_iissscrefset_sp(ID);
	CREATE INDEX idx_iissscirefsetp_id ON rf2_iissscirefset_sp(ID);

	CREATE INDEX idx_CONCEPT_STATp_X ON rf2_concept_sp(definitionStatusId);
	CREATE INDEX idx_TERM_TERMp_X ON rf2_term_sp(Term);
	CREATE INDEX idx_REL_CUI1p_X ON rf2_rel_sp(sourceId);
	CREATE INDEX idx_REL_RELATIONp_X ON rf2_rel_sp(typeId);
	CREATE INDEX idx_REL_CUI2p_X ON rf2_rel_sp(destinationId);
	CREATE INDEX idx_REL_CHARTYPE_X ON rf2_rel_sp(characteristicTypeId);
	CREATE INDEX idx_refsetp_refId ON rf2_refset_sp(refsetId);
	CREATE INDEX idx_crefsetp_refId ON rf2_crefset_sp(refsetId);
	CREATE INDEX idx_icrefsetp_refId ON rf2_icrefset_sp(refsetId);
	CREATE INDEX idx_srefsetp_refId ON rf2_srefset_sp(refsetId);
	CREATE INDEX idx_ccirefsetp_refId ON rf2_ccirefset_sp(refsetId);
	CREATE INDEX idx_cirefsetp_refId ON rf2_cirefset_sp(refsetId);
	CREATE INDEX idx_ssrefsetp_refId ON rf2_ssrefset_sp(refsetId);
	CREATE INDEX idx_iissscrefsetp_refId ON rf2_iissscrefset_sp(refsetId);
	CREATE INDEX idx_iissscirefsetp_refId ON rf2_iissscirefset_sp(refsetId);
	CREATE INDEX idx_refsetp_comId ON rf2_refset_sp(referencedComponentId);
	CREATE INDEX idx_crefsetp_comId ON rf2_crefset_sp(referencedComponentId);
	CREATE INDEX idx_icrefsetp_comId ON rf2_icrefset_sp(referencedComponentId);
	CREATE INDEX idx_srefsetp_comId ON rf2_srefset_sp(referencedComponentId);
	CREATE INDEX idx_ccirefsetp_comId ON rf2_ccirefset_sp(referencedComponentId);
	CREATE INDEX idx_cirefsetp_comId ON rf2_cirefset_sp(referencedComponentId);
	CREATE INDEX idx_ssrefsetp_comId ON rf2_ssrefset_sp(referencedComponentId);
	CREATE INDEX idx_iissscrefsetp_comId ON rf2_iissscrefset_sp(referencedComponentId);
	CREATE INDEX idx_iissscirefsetp_comId ON rf2_iissscirefset_sp(referencedComponentId);
	CREATE INDEX idx_crefsetp_lcomId ON rf2_crefset_sp(linkedComponentId);
	CREATE INDEX idx_cirefsetp_lcomId ON rf2_cirefset_sp(linkedComponentId);
	CREATE INDEX idx_LUI1p_X ON rf2_ccirefset_sp(linkedComponentId2);
	CREATE INDEX idx_LUI2p_X ON rf2_ccirefset_sp(linkedComponentId1);
	CREATE INDEX idx_iissscrefsetp_corId ON rf2_iissscrefset_sp(corelationID);
	CREATE INDEX idx_iissscirefsetp_corId ON rf2_iissscirefset_sp(corelationID);

	CREATE INDEX idx_s2r_refid ON RF2_subset2refset(refsetID);

-- PARALLEL_END;