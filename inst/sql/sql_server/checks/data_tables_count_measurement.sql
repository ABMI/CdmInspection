-- Clinical data table counts

select 'measurement' as tablename, count_big(*) as count from @cdmDatabaseSchema.measurement
