-- Clinical data table counts

select 'observation_period' as tablename, count_big(*) as count from @cdmDatabaseSchema.observation_period
