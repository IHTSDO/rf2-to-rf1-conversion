UPDATE rf21_rel r
SET RELATIONSHIPID = relationshipIdFor (r.conceptid1, r.relationshiptype, r.conceptid2, r.relationshipgroup, false)
WHERE r.relationshipid is null;

UPDATE rf21_stated_rel r
SET RELATIONSHIPID = relationshipIdFor (r.conceptid1, r.relationshiptype, r.conceptid2, r.relationshipgroup, true)
WHERE r.relationshipid is null;