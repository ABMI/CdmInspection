# Copyright 2020 Observational Health Data Sciences and Informatics
#
# This file is part of CdmInspection
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#' Create the exposure and outcome cohorts
#'
#' @details
#' This function will create the exposure and outcome cohorts following the definitions included in
#' this package.
#'
#' @param connection    An object of type \code{connection} as created using the
#'                             \code{\link[DatabaseConnector]{createConnectionDetails}} function in the
#'                             DatabaseConnector package.
#' @param cdmDatabaseSchema    Schema name where your patient-level data in OMOP CDM format resides.
#'                             Note that for SQL Server, this should include both the database and
#'                             schema name, for example 'cdm_data.dbo'.
#' @param cohortDatabaseSchema Schema name where intermediate data can be stored. You will need to have
#'                             write privileges in this schema. Note that for SQL Server, this should
#'                             include both the database and schema name, for example 'cdm_data.dbo'.
#' @param cohortTable          The name of the table that will be created in the work database schema.
#'                             This table will hold the exposure and outcome cohorts used in this
#'                             study.
#' @param oracleTempSchema     Should be used in Oracle to specify a schema where the user has write
#'                             privileges for storing temporary tables.
#' @param outputFolder         Name of local folder to place results; make sure to use forward slashes
#'                             (/)
#'
#' @export


createCohorts <- function(connection,
                          cdmDatabaseSchema,
                          vocabularyDatabaseSchema = cdmDatabaseSchema,
                          cohortDatabaseSchema,
                          cohortTable,
                          oracleTempSchema,
                          outputFolder) {
  if (!file.exists(outputFolder))
    dir.create(outputFolder)

  conn <- DatabaseConnector::connect(connection)

  # Create study cohort table structure:
  sql <- SqlRender::loadRenderTranslateSql(sqlFilename = "CreateCohortTable.sql",
                                           packageName = "CdmInspection",
                                           dbms = attr(conn, "dbms"),
                                           oracleTempSchema = oracleTempSchema,
                                           cohort_database_schema = cohortDatabaseSchema,
                                           cohort_table = cohortTable)
  DatabaseConnector::executeSql(conn, sql, progressBar = FALSE, reportOverallTime = FALSE)



  # Instantiate cohorts:
  pathToCsv <- system.file("settings", "CohortsToCreate.csv", package = "CdmInspection")
  cohortsToCreate <- read.csv(pathToCsv)
  duration <- data.frame(cohortName = cohortsToCreate$name, executionTime = NA)
  for (i in c(1:5)) {
    start_time <- Sys.time()
    writeLines(paste("Creating cohort:", cohortsToCreate$name[i]))
    sql <- SqlRender::loadRenderTranslateSql(sqlFilename = paste0(cohortsToCreate$name[i], ".sql"),
                                             packageName = "CdmInspection",
                                             dbms = attr(conn, "dbms"),
                                             oracleTempSchema = oracleTempSchema,
                                             cdm_database_schema = cdmDatabaseSchema,
                                             vocabulary_database_schema = vocabularyDatabaseSchema,

                                             target_database_schema = cohortDatabaseSchema,
                                             target_cohort_table = cohortTable,
                                             target_cohort_id = cohortsToCreate$cohortId[i])
    DatabaseConnector::executeSql(conn, sql)
    duration$executionTime[i] <- as.numeric(difftime(Sys.time(),start_time), units="secs")
  }

  # Fetch cohort counts:
  if(attr(conn,"dbms") == 'postgresql'){
    sql <- "SELECT cohort_definition_id as cohortDefinitionId, COUNT(*) AS recordCount, count(distinct subject_id) AS personCount, (select count(person_id) from @cdm_database_schema.person) as totalPersonCount, round(100*cast(count(distinct subject_id) as numeric)/(select count(person_id) from @cdm_database_schema.person),2) AS personProportion FROM @cohort_database_schema.@cohort_table GROUP BY cohort_definition_id"
  }else if(attr(conn,"dbms") == 'oracle'){
    sql <- "SELECT cohort_definition_id as cohortDefinitionId, COUNT(*) AS recordCount, count(distinct subject_id) AS personCount, (select count(person_id) from @cdm_database_schema.person) as totalPersonCount, round(100*cast(count(distinct subject_id) as number(5))/(select count(person_id) from @cdm_database_schema.person),2) AS personProportion FROM @cohort_database_schema.@cohort_table GROUP BY cohort_definition_id"
  }else{
    sql <- "SELECT cohort_definition_id as cohortDefinitionId, COUNT(*) AS recordCount, count(distinct subject_id) AS personCount, (select count(person_id) from @cdm_database_schema.person) as totalPersonCount, round(100*convert(float, count(distinct subject_id))/(select count(person_id) from @cdm_database_schema.person),2) AS personProportion FROM @cohort_database_schema.@cohort_table GROUP BY cohort_definition_id"
  }

  sql <- SqlRender::render(sql,
                           cohort_database_schema = cohortDatabaseSchema,
                           cdm_database_schema = cdmDatabaseSchema,
                           cohort_table = cohortTable)
  sql <- SqlRender::translate(sql, targetDialect = attr(conn, "dbms"))
  counts <- DatabaseConnector::querySql(conn, sql)
  names(counts) <- c("cohortDefinitionId", "recordCount", "personCount", "totalPersonCount", "personProportion")
  counts <- merge(data.frame(cohortDefinitionId = cohortsToCreate$cohortId,
                                     cohortName  = cohortsToCreate$name), counts, all.x = T)
  counts <- merge(counts, duration, by = "cohortName", all.x = T)

  counts <- counts %>% select(cohortDefinitionId, cohortName, recordCount, personCount, totalPersonCount, personProportion, executionTime) %>% arrange(cohortDefinitionId)
  return(counts)
}

