-- Clinical data table counts

select 'visit_details' as tablename, count_big(*) as count from @cdmDatabaseSchema.visit_detail
