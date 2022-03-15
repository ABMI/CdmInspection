-- Clinical data table counts

select 'drug_era' as tablename, count_big(*) as count from @cdmDatabaseSchema.drug_era
