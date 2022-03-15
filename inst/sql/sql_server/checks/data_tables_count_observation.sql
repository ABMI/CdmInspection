-- Clinical data table counts

select 'observation' as tablename, count_big(*) as count from @cdmDatabaseSchema.observation
