-- Clinical data table counts

select 'death' as tablename, count_big(*) as count, count(distinct person_id) AS personcount, 100 * round(convert(float, count(distinct person_id)) / (SELECT count(distinct person_id) FROM @cdmDatabaseSchema.person), 3) as personcountrate, 100 *round(convert(float, count(distinct person_id)) / (SELECT count(distinct person_id) as observationcountrate FROM @cdmDatabaseSchema.observation_period), 3) as observedcountrate  from @cdmDatabaseSchema.death
