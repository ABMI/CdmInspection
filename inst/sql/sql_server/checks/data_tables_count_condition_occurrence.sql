-- Clinical data table counts

select 'condition_occurrence' as tablename, count_big(*) as count from @cdmDatabaseSchema.condition_occurrence
