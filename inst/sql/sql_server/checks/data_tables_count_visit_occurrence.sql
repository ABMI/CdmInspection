-- Clinical data table counts

select 'visit_occurrence' as tablename, count_big(*) as count from @cdmDatabaseSchema.visit_occurrence
