-- Clinical data table counts

select 'person' as tablename, count_big(*) as count, count(distinct person_id) AS personcount, round(convert(float, count(distinct person_id)) / (SELECT count(distinct person_id) FROM @cdmDatabaseSchema.person), 3) as personcountrate, round(convert(float, count(distinct person_id)) / (SELECT count(distinct person_id) as observationcountrate FROM @cdmDatabaseSchema.observation_period), 3) as observedcountrate from @cdmDatabaseSchema.person
UNION
select 'care_site' as tablename, count_big(*) as count, '-' AS personcount, '-' as personcountrate, '-' as observedcountrate  from @cdmDatabaseSchema.care_site
UNION
select 'condition_era' as tablename, count_big(*) as count, count(distinct person_id) AS personcount, round(convert(float, count(distinct person_id)) / (SELECT count(distinct person_id) FROM @cdmDatabaseSchema.person), 3) as personcountrate, round(convert(float, count(distinct person_id)) / (SELECT count(distinct person_id) as observationcountrate FROM @cdmDatabaseSchema.observation_period), 3) as observedcountrate  from @cdmDatabaseSchema.condition_era
UNION
select 'condition_occurrence' as tablename, count_big(*) as count, count(distinct person_id) AS personcount, round(convert(float, count(distinct person_id)) / (SELECT count(distinct person_id) FROM @cdmDatabaseSchema.person), 3) as personcountrate, round(convert(float, count(distinct person_id)) / (SELECT count(distinct person_id) as observationcountrate FROM @cdmDatabaseSchema.observation_period), 3) as observedcountrate from @cdmDatabaseSchema.condition_occurrence
UNION
select 'drug_exposure' as tablename, count_big(*) as count, count(distinct person_id) AS personcount, round(convert(float, count(distinct person_id)) / (SELECT count(distinct person_id) FROM @cdmDatabaseSchema.person), 3) as personcountrate, round(convert(float, count(distinct person_id)) / (SELECT count(distinct person_id) as observationcountrate FROM @cdmDatabaseSchema.observation_period), 3) as observedcountrate  from @cdmDatabaseSchema.drug_exposure
UNION
select 'cost' as tablename, count_big(*) as count, '-' AS personcount, '-' as personcountrate, '-' as observedcountrate from @cdmDatabaseSchema.cost
UNION
select 'death' as tablename, count_big(*) as count, count(distinct person_id) AS personcount, round(convert(float, count(distinct person_id)) / (SELECT count(distinct person_id) FROM @cdmDatabaseSchema.person), 3) as personcountrate, round(convert(float, count(distinct person_id)) / (SELECT count(distinct person_id) as observationcountrate FROM @cdmDatabaseSchema.observation_period), 3) as observedcountrate  from @cdmDatabaseSchema.death
UNION
select 'device_exposure' as tablename, count_big(*) as count, count(distinct person_id) AS personcount, round(convert(float, count(distinct person_id)) / (SELECT count(distinct person_id) FROM @cdmDatabaseSchema.person), 3) as personcountrate, round(convert(float, count(distinct person_id)) / (SELECT count(distinct person_id) as observationcountrate FROM @cdmDatabaseSchema.observation_period), 3) as observedcountrate  from @cdmDatabaseSchema.device_exposure
UNION
select 'dose_era' as tablename, count_big(*) as count, count(distinct person_id) AS personcount, round(convert(float, count(distinct person_id)) / (SELECT count(distinct person_id) FROM @cdmDatabaseSchema.person), 3) as personcountrate, round(convert(float, count(distinct person_id)) / (SELECT count(distinct person_id) as observationcountrate FROM @cdmDatabaseSchema.observation_period), 3) as observedcountrate  from @cdmDatabaseSchema.dose_era
UNION
select 'drug_era' as tablename, count_big(*) as count, count(distinct person_id) AS personcount, round(convert(float, count(distinct person_id)) / (SELECT count(distinct person_id) FROM @cdmDatabaseSchema.person), 3) as personcountrate, round(convert(float, count(distinct person_id)) / (SELECT count(distinct person_id) as observationcountrate FROM @cdmDatabaseSchema.observation_period), 3) as observedcountrate  from @cdmDatabaseSchema.drug_era
UNION
select 'location' as tablename, count_big(*) as count, '-' AS personcount, '-' as personcountrate, '-' as observedcountrate  from @cdmDatabaseSchema.location
UNION
select 'measurement' as tablename, count_big(*) as count, count(distinct person_id) AS personcount, round(convert(float, count(distinct person_id)) / (SELECT count(distinct person_id) FROM @cdmDatabaseSchema.person), 3) as personcountrate, round(convert(float, count(distinct person_id)) / (SELECT count(distinct person_id) as observationcountrate FROM @cdmDatabaseSchema.observation_period), 3) as observedcountrate  from @cdmDatabaseSchema.measurement
UNION
select 'note' as tablename, count_big(*) as count, count(distinct person_id) AS personcount, round(convert(float, count(distinct person_id)) / (SELECT count(distinct person_id) FROM @cdmDatabaseSchema.person), 3) as personcountrate, round(convert(float, count(distinct person_id)) / (SELECT count(distinct person_id) as observationcountrate FROM @cdmDatabaseSchema.observation_period), 3) as observedcountrate  from @cdmDatabaseSchema.note
UNION
select 'observation' as tablename, count_big(*) as count, count(distinct person_id) AS personcount, round(convert(float, count(distinct person_id)) / (SELECT count(distinct person_id) FROM @cdmDatabaseSchema.person), 3) as personcountrate, round(convert(float, count(distinct person_id)) / (SELECT count(distinct person_id) as observationcountrate FROM @cdmDatabaseSchema.observation_period), 3) as observedcountrate  from @cdmDatabaseSchema.observation
UNION
select 'observation_period' as tablename, count_big(*) as count, count(distinct person_id) AS personcount, round(convert(float, count(distinct person_id)) / (SELECT count(distinct person_id) FROM @cdmDatabaseSchema.person), 3) as personcountrate, round(convert(float, count(distinct person_id)) / (SELECT count(distinct person_id) as observationcountrate FROM @cdmDatabaseSchema.observation_period), 3) as observedcountrate  from @cdmDatabaseSchema.observation_period
UNION
select 'payer_plan_period' as tablename, count_big(*) as count, count(distinct person_id) AS personcount, count(distinct person_id) / (SELECT count(distinct person_id) FROM @cdmDatabaseSchema.person) as personcountrate, count(distinct person_id) / (SELECT count(distinct person_id) as observationcountrate FROM @cdmDatabaseSchema.observation_period) as observedcountrate  from @cdmDatabaseSchema.payer_plan_period
UNION
select 'procedure_occurrence' as tablename, count_big(*) as count, count(distinct person_id) AS personcount, count(distinct person_id) / (SELECT count(distinct person_id) FROM @cdmDatabaseSchema.person) as personcountrate, count(distinct person_id) / (SELECT count(distinct person_id) as observationcountrate FROM @cdmDatabaseSchema.observation_period) as observedcountrate  from @cdmDatabaseSchema.procedure_occurrence
UNION
select 'provider' as tablename, count_big(*) as count, '-' AS personcount, '-' as personcountrate, '-' as observedcountrate from @cdmDatabaseSchema.provider
UNION
select 'specimen' as tablename, count_big(*) as count, count(distinct person_id) AS personcount, count(distinct person_id) / (SELECT count(distinct person_id) FROM @cdmDatabaseSchema.person) as personcountrate, count(distinct person_id) / (SELECT count(distinct person_id) as observationcountrate FROM @cdmDatabaseSchema.observation_period) as observedcountrate  from @cdmDatabaseSchema.specimen
UNION
select 'visit_details' as tablename, count_big(*) as count, count(distinct person_id) AS personcount, count(distinct person_id) / (SELECT count(distinct person_id) FROM @cdmDatabaseSchema.person) as personcountrate, count(distinct person_id) / (SELECT count(distinct person_id) as observationcountrate FROM @cdmDatabaseSchema.observation_period) as observedcountrate  from @cdmDatabaseSchema.visit_detail
UNION
select 'visit_occurrence' as tablename, count_big(*) as count, count(distinct person_id) AS personcount, count(distinct person_id) / (SELECT count(distinct person_id) FROM @cdmDatabaseSchema.person) as personcountrate, count(distinct person_id) / (SELECT count(distinct person_id) as observationcountrate FROM @cdmDatabaseSchema.observation_period) as observedcountrate  from @cdmDatabaseSchema.visit_occurrence
