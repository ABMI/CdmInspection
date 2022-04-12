# @file CdmInspection
#
# Copyright 2020 European Health Data and Evidence Network (EHDEN)
#
# This file is part of CatalogueExport
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# @author European Health Data and Evidence Network
# @author Peter Rijnbeek


#' The vocabulary checks (for v5.x)
#'
#' @description
#' \code{CdmInspection} runs a list of checks on the vocabulary as part of the CDM inspection procedure
#'
#' @details
#' \code{CdmInspection} runs a list of checks on the vocabulary as part of the CDM inspection procedure
#'
#' @param connectionDetails                An R object of type \code{connectionDetails} created using the function \code{createConnectionDetails} in the \code{DatabaseConnector} package.
#' @param cdmDatabaseSchema    	           Fully qualified name of database schema that contains OMOP CDM schema.
#'                                         On SQL Server, this should specifiy both the database and the schema, so for example, on SQL Server, 'cdm_instance.dbo'.
#' @param resultsDatabaseSchema		         Fully qualified name of database schema that we can write final results to. Default is cdmDatabaseSchema.
#'                                         On SQL Server, this should specifiy both the database and the schema, so for example, on SQL Server, 'cdm_results.dbo'.
#' @param vocabDatabaseSchema		           String name of database schema that contains OMOP Vocabulary. Default is cdmDatabaseSchema. On SQL Server, this should specifiy both the database and the schema, so for example 'results.dbo'.
#' @param oracleTempSchema                 For Oracle only: the name of the database schema where you want all temporary tables to be managed. Requires create/insert permissions to this database.
#' @param sourceName		                   String name of the data source name. If blank, CDM_SOURCE table will be queried to try to obtain this.
#' @param sqlOnly                          Boolean to determine if Achilles should be fully executed. TRUE = just generate SQL files, don't actually run, FALSE = run Achilles
#' @param outputFolder                     Path to store logs and SQL files
#' @param verboseMode                      Boolean to determine if the console will show all execution steps. Default = TRUE
#' @return                                 An object of type \code{achillesResults} containing details for connecting to the database containing the results
#' @export
dataTablesChecks <- function (connectionDetails,
                              cdmDatabaseSchema,
                              resultsDatabaseSchema = cdmDatabaseSchema,
                              vocabDatabaseSchema = cdmDatabaseSchema,
                              oracleTempSchema = resultsDatabaseSchema,
                              sourceName = "",
                              sqlOnly = FALSE,
                              outputFolder = "output",
                              verboseMode = TRUE) {

  ## run all queries
  if(connectionDetails$dbms == 'oracle'){
    dataTablesCounts <- executeQuery(outputFolder,"data_tables_count_ora.sql", "Data tables count query executed successfully", connectionDetails, sqlOnly, cdmDatabaseSchema, vocabDatabaseSchema, resultsDatabaseSchema)
  } else {
    dataTablesCounts <- executeQuery(outputFolder,"data_tables_count.sql", "Data tables count query executed successfully", connectionDetails, sqlOnly, cdmDatabaseSchema, vocabDatabaseSchema, resultsDatabaseSchema)
    if(is.null(dataTablesCounts[[1]])){
      ParallelLogger::logInfo('Errors occured when counting data tables, Start counting rows by each table')
      tryCatch({dataTablesCounts_person <- executeQuery(outputFolder,"data_tables_count_person.sql", "Data tables - person count query executed successfully", connectionDetails, sqlOnly, cdmDatabaseSchema, vocabDatabaseSchema, resultsDatabaseSchema)})
      tryCatch({dataTablesCounts_care_site <- executeQuery(outputFolder,"data_tables_count_care_site.sql", "Data tables - care site count query executed successfully", connectionDetails, sqlOnly, cdmDatabaseSchema, vocabDatabaseSchema, resultsDatabaseSchema)})
      tryCatch({dataTablesCounts_condition_era <- executeQuery(outputFolder,"data_tables_count_condition_era.sql", "Data tables - condition_era count query executed successfully", connectionDetails, sqlOnly, cdmDatabaseSchema, vocabDatabaseSchema, resultsDatabaseSchema)})
      tryCatch({dataTablesCounts_condition_occurrence <- executeQuery(outputFolder,"data_tables_count_condition_occurrence.sql", "Data tables - condition_occurrence count query executed successfully", connectionDetails, sqlOnly, cdmDatabaseSchema, vocabDatabaseSchema, resultsDatabaseSchema)})
      tryCatch({dataTablesCounts_cost <- executeQuery(outputFolder,"data_tables_count_cost.sql", "Data tables - cost count query executed successfully", connectionDetails, sqlOnly, cdmDatabaseSchema, vocabDatabaseSchema, resultsDatabaseSchema)})
      tryCatch({dataTablesCounts_death <- executeQuery(outputFolder,"data_tables_count_death.sql", "Data tables - death count query executed successfully", connectionDetails, sqlOnly, cdmDatabaseSchema, vocabDatabaseSchema, resultsDatabaseSchema)})
      tryCatch({dataTablesCounts_device_exposure <- executeQuery(outputFolder,"data_tables_count_device_exposure.sql", "Data tables - device count query executed successfully", connectionDetails, sqlOnly, cdmDatabaseSchema, vocabDatabaseSchema, resultsDatabaseSchema)})
      tryCatch({dataTablesCounts_dose_era <- executeQuery(outputFolder,"data_tables_count_dose_era.sql", "Data tables - dose_era count query executed successfully", connectionDetails, sqlOnly, cdmDatabaseSchema, vocabDatabaseSchema, resultsDatabaseSchema)})
      tryCatch({dataTablesCounts_drug_era <- executeQuery(outputFolder,"data_tables_count_drug_era.sql", "Data tables - drug_era count query executed successfully", connectionDetails, sqlOnly, cdmDatabaseSchema, vocabDatabaseSchema, resultsDatabaseSchema)})
      tryCatch({dataTablesCounts_location <- executeQuery(outputFolder,"data_tables_count_location.sql", "Data tables - location count query executed successfully", connectionDetails, sqlOnly, cdmDatabaseSchema, vocabDatabaseSchema, resultsDatabaseSchema)})
      tryCatch({dataTablesCounts_measurement <- executeQuery(outputFolder,"data_tables_count_measurement.sql", "Data tables - measurement count query executed successfully", connectionDetails, sqlOnly, cdmDatabaseSchema, vocabDatabaseSchema, resultsDatabaseSchema)})
      tryCatch({dataTablesCounts_note <- executeQuery(outputFolder,"data_tables_count_note.sql", "Data tables - note count query executed successfully", connectionDetails, sqlOnly, cdmDatabaseSchema, vocabDatabaseSchema, resultsDatabaseSchema)})
      tryCatch({dataTablesCounts_observation <- executeQuery(outputFolder,"data_tables_count_observation.sql", "Data tables - observation count query executed successfully", connectionDetails, sqlOnly, cdmDatabaseSchema, vocabDatabaseSchema, resultsDatabaseSchema)})
      tryCatch({dataTablesCounts_observation_period <- executeQuery(outputFolder,"data_tables_count_observation_period.sql", "Data tables - observation_period count query executed successfully", connectionDetails, sqlOnly, cdmDatabaseSchema, vocabDatabaseSchema, resultsDatabaseSchema)})
      tryCatch({dataTablesCounts_payer_plan_period <- executeQuery(outputFolder,"data_tables_count_payer_plan_period.sql", "Data tables - payer_plan_period count query executed successfully", connectionDetails, sqlOnly, cdmDatabaseSchema, vocabDatabaseSchema, resultsDatabaseSchema)})
      tryCatch({dataTablesCounts_procedure_occurrence <- executeQuery(outputFolder,"data_tables_count_procedure_occurrence.sql", "Data tables - procedure count query executed successfully", connectionDetails, sqlOnly, cdmDatabaseSchema, vocabDatabaseSchema, resultsDatabaseSchema)})
      tryCatch({dataTablesCounts_provider <- executeQuery(outputFolder,"data_tables_count_provider.sql", "Data tables - provider count query executed successfully", connectionDetails, sqlOnly, cdmDatabaseSchema, vocabDatabaseSchema, resultsDatabaseSchema)})
      tryCatch({dataTablesCounts_specimen <- executeQuery(outputFolder,"data_tables_count_specimen.sql", "Data tables - specimen count query executed successfully", connectionDetails, sqlOnly, cdmDatabaseSchema, vocabDatabaseSchema, resultsDatabaseSchema)})
      tryCatch({dataTablesCounts_visit_details <- executeQuery(outputFolder,"data_tables_count_visit_details.sql", "Data tables - visit_details count query executed successfully", connectionDetails, sqlOnly, cdmDatabaseSchema, vocabDatabaseSchema, resultsDatabaseSchema)})
      tryCatch({dataTablesCounts_visit_occurrence <- executeQuery(outputFolder,"data_tables_count_visit_occurrence.sql", "Data tables - visit_occurrence count query executed successfully", connectionDetails, sqlOnly, cdmDatabaseSchema, vocabDatabaseSchema, resultsDatabaseSchema)})

      dataTablesCounts <- list()
      dataTablesCounts[[1]] <- rbind(dataTablesCounts_person[[1]], dataTablesCounts_care_site[[1]], dataTablesCounts_condition_era[[1]],
                                     dataTablesCounts_condition_occurrence[[1]], dataTablesCounts_cost[[1]], dataTablesCounts_death[[1]],
                                     dataTablesCounts_device_exposure[[1]], dataTablesCounts_dose_era[[1]], dataTablesCounts_drug_era[[1]],
                                     dataTablesCounts_location[[1]], dataTablesCounts_measurement[[1]], dataTablesCounts_note[[1]],
                                     dataTablesCounts_observation[[1]], dataTablesCounts_observation_period[[1]], dataTablesCounts_payer_plan_period[[1]],
                                     dataTablesCounts_procedure_occurrence[[1]], dataTablesCounts_provider[[1]], dataTablesCounts_specimen[[1]],
                                     dataTablesCounts_visit_details[[1]], dataTablesCounts_visit_occurrence[[1]])
      dataTablesCounts[[2]] <- sum(dataTablesCounts_person[[2]], dataTablesCounts_care_site[[2]], dataTablesCounts_condition_era[[2]],
                                   dataTablesCounts_condition_occurrence[[2]], dataTablesCounts_cost[[2]], dataTablesCounts_death[[2]],
                                   dataTablesCounts_device_exposure[[2]], dataTablesCounts_dose_era[[2]], dataTablesCounts_drug_era[[2]],
                                   dataTablesCounts_location[[2]], dataTablesCounts_measurement[[2]], dataTablesCounts_note[[2]],
                                   dataTablesCounts_observation[[2]], dataTablesCounts_observation_period[[2]], dataTablesCounts_payer_plan_period[[2]],
                                   dataTablesCounts_procedure_occurrence[[2]], dataTablesCounts_provider[[2]], dataTablesCounts_specimen[[2]],
                                   dataTablesCounts_visit_details[[2]], dataTablesCounts_visit_occurrence[[2]])
      names(dataTablesCounts) <- c('result', 'duration')

      rm(list = apropos(what = 'dataTablesCounts_'))
    }
  }

  totalRecords <- executeQuery(outputFolder,"totalrecords.sql", "Total number of records over time query executed successfully", connectionDetails, sqlOnly, cdmDatabaseSchema, vocabDatabaseSchema, resultsDatabaseSchema)
  recordsPerPerson <- executeQuery(outputFolder,"recordsperperson.sql", "Number of records per person query executed successfully", connectionDetails, sqlOnly, cdmDatabaseSchema, vocabDatabaseSchema, resultsDatabaseSchema)
  conceptsPerPerson <- executeQuery(outputFolder,"conceptsperperson.sql", "Number of records per person query executed successfully", connectionDetails, sqlOnly, cdmDatabaseSchema, vocabDatabaseSchema, resultsDatabaseSchema)

  results <- list(dataTablesCounts=dataTablesCounts,
                  totalRecords=totalRecords,
                  recordsPerPerson=recordsPerPerson,
                  conceptsPerPerson=conceptsPerPerson)
  return(results)
}



