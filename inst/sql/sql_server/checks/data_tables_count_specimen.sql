-- Clinical data table counts

select 'specimen' as tablename, count_big(*) as count from @cdmDatabaseSchema.specimen
