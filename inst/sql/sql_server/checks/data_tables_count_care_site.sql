-- Clinical data table counts

select 'care_site' as tablename, count_big(*) as count, NULL AS personcount, NULL as personcountrate, NULL as observedcountrate  from @cdmDatabaseSchema.care_site
