-- Clinical data table counts

select 'provider' as tablename, count_big(*) as count from @cdmDatabaseSchema.provider
