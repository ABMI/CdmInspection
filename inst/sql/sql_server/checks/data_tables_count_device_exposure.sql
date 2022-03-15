-- Clinical data table counts

select 'device_exposure' as tablename, count_big(*) as count from @cdmDatabaseSchema.device_exposure
