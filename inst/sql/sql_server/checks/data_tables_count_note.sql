-- Clinical data table counts

select 'note' as tablename, count_big(*) as count from @cdmDatabaseSchema.note
