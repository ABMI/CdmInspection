-- Clinical data table counts

select 'drug_exposure' as tablename, count_big(*) as count from @cdmDatabaseSchema.drug_exposure
