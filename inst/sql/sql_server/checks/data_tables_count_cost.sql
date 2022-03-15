-- Clinical data table counts

select 'cost' as tablename, count_big(*) as count from @cdmDatabaseSchema.cost
