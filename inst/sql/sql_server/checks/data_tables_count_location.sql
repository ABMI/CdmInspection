-- Clinical data table counts

select 'location' as tablename, count_big(*) as count, NULL AS personcount, NULL as personcountrate, NULL as observedcountrate  from @cdmDatabaseSchema.location
