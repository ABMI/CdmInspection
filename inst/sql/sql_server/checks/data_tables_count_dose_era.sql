-- Clinical data table counts

select 'dose_era' as tablename, count_big(*) as count from @cdmDatabaseSchema.dose_era
