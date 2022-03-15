-- Clinical data table counts

select 'condition_era' as tablename, count_big(*) as count from @cdmDatabaseSchema.condition_era

