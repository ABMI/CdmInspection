-- Clinical data table counts

select 'location' as tablename, count_big(*) as count from @cdmDatabaseSchema.location
