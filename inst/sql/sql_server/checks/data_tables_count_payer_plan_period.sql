-- Clinical data table counts

select 'payer_plan_period' as tablename, count_big(*) as count from @cdmDatabaseSchema.payer_plan_period
