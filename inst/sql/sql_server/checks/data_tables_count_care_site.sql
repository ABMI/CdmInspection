-- Clinical data table counts

select 'care_site' as tablename, count_big(*) as count from @cdmDatabaseSchema.care_site
