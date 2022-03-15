-- Clinical data table counts

select 'death' as tablename, count_big(*) as count from @cdmDatabaseSchema.death
