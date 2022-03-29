select 'condition' as domain, standard_concept, count(standard_concept) cnt from @cdmDatabaseSchema.condition_occurrence a, @vocabDatabaseSchema.concept b
where a.condition_concept_id=b.concept_id
group by standard_concept

union
select 'procedure' as domain, standard_concept, count(standard_concept) cnt from @cdmDatabaseSchema.procedure_occurrence a, @vocabDatabaseSchema.concept b
where a.procedure_concept_id=b.concept_id
group by standard_concept

union
select 'device' as domain, standard_concept, count(standard_concept) cnt from @cdmDatabaseSchema.device_exposure a, @vocabDatabaseSchema.concept b
where a.device_concept_id=b.concept_id
group by standard_concept

union
select 'drug' as domain, standard_concept, count(standard_concept) cnt from @cdmDatabaseSchema.drug_exposure a, @vocabDatabaseSchema.concept b
where a.drug_concept_id=b.concept_id
group by standard_concept

union
select 'observation' as domain, standard_concept, count(standard_concept) cnt from @cdmDatabaseSchema.observation a, @vocabDatabaseSchema.concept b
where a.observation_concept_id=b.concept_id
group by standard_concept

union
select 'measurement' as domain, standard_concept, count(standard_concept) cnt from @cdmDatabaseSchema.measurement a, @vocabDatabaseSchema.concept b
where a.measurement_concept_id=b.concept_id
group by standard_concept

union
select 'visit_occurrence' as domain, standard_concept, count(standard_concept) cnt from @cdmDatabaseSchema.visit_occurrence a, @vocabDatabaseSchema.concept b
where a.visit_concept_id=b.concept_id
group by standard_concept

union
select 'measurement-unit' as domain, standard_concept, count(standard_concept) cnt from @cdmDatabaseSchema.measurement a, @vocabDatabaseSchema.concept b
where a.unit_concept_id=b.concept_id and unit_concept_id IS NOT NULL
group by standard_concept

union
select 'observation-unit' as domain, standard_concept, count(standard_concept) cnt from @cdmDatabaseSchema.observation a, @vocabDatabaseSchema.concept b
where a.unit_concept_id=b.concept_id and unit_concept_id IS NOT NULL
group by standard_concept

union
select 'measurement-value' as domain, standard_concept, count(standard_concept) cnt from @cdmDatabaseSchema.measurement a, @vocabDatabaseSchema.concept b
where a.value_as_concept_id=b.concept_id and value_as_concept_id IS NOT NULL
group by standard_concept

union
select 'observation-value' as domain, standard_concept, count(standard_concept) cnt from @cdmDatabaseSchema.observation a, @vocabDatabaseSchema.concept b
where a.value_as_concept_id=b.concept_id and value_as_concept_id IS NOT NULL
group by standard_concept
