-- Clinical data table counts

select 'cost' as tablename, count_big(*) as count, NULL AS personcount, NULL as personcountrate, NULL as observedcountrate from @cdmDatabaseSchema.cost

