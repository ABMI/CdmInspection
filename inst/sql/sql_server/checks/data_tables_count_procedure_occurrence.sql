-- Clinical data table counts

select 'procedure_occurrence' as tablename, count_big(*) as count from @cdmDatabaseSchema.procedure_occurrence
