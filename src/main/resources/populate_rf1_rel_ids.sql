UPDATE rf21_rel r
SET RELATIONSHIPID = relationshipIdFor (r.conceptid1, r.relationshiptype, r.conceptid2, r.relationshipgroup)
WHERE r.relationshipid is null;

UPDATE rf21_stated_rel r
SET RELATIONSHIPID = relationshipIdFor (r.conceptid1, r.relationshiptype, r.conceptid2, r.relationshipgroup)
WHERE r.relationshipid is null;