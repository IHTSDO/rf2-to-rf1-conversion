UPDATE rf21_rel r
SET relationshipId = relationshipIdFor (r.concept1, r.relationshipType, r.concept2, r.relationshipGroup)
WHERE relationshipId is null;