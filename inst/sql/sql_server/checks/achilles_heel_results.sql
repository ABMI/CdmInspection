-- get achilles heel result

SELECT AH.analysis_id,
AH.rule_id,
AH.achilles_heel_warning,
AH.record_count
FROM @resultsDatabaseSchema.achilles_heel_results AH
