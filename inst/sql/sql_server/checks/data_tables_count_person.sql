-- Clinical data table counts

select 'person' as tablename, count_big(*) as count from @cdmDatabaseSchema.person
