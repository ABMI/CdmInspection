-- Clinical data table counts

select 'provider' as tablename, count_big(*) as count, NULL AS personcount, NULL as personcountrate, NULL as observedcountrate from @cdmDatabaseSchema.provider
