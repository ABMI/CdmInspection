# *******************************************************
# -----------------INSTRUCTIONS -------------------------
# *******************************************************
#
#-----------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------
# This CodeToRun.R is provided as an example of how to run this package.
# Below you will find 2 sections: the 1st is for installing the dependencies
# required to run the package and the 2nd for running the package.
#
#
#

# *******************************************************
# SECTION 1: Make sure to install all dependencies (not needed if already done) -------------------------------
# *******************************************************
#
# restore all dependencies to your in-package library
install.packages("renv") # you can skip this if you already installed it.
renv::restore()

# or If you want to use your local library, please run 'renv::deactivate()'

# Below is an example .Renviron file's contents: (please remove)
# the "#" below as these too are interprted as comments in the .Renviron file:

# usethis::edit_r_environ()

# 새로 뜨는 창에 아래 내용 입력 후 저장
# DBMS=‘DBMS 정보 입력’
# DB_SEVER=‘서버 정보 입력’
# DB_USER=‘DB 접속을 위한 ID입력’
# DB_PASSWORD=‘비밀번호 입력’
# DB_PORT=‘포트입력’
# FFTEMP_DIR=‘임시 저장 디렉토리 입력’

# r 재시작 (ctrl+shift+F10)


# For example,

# DBMS = "postgresql"
# DB_SERVER = "database.server.com" or '123.456.789/OMOPCDM'
# DB_PORT = 5432
# DB_USER = "database_user_name_goes_here"
# DB_PASSWORD = "your_secret_password"
# FFTEMP_DIR = "C:/fftemp"
#


# *******************************************************
# SECTION 2: Set Local Details
# *******************************************************
library(CdmInspection)

# Prevents errors due to packages being built for other R versions:
Sys.setenv("R_REMOTES_NO_ERRORS_FROM_WARNINGS" = TRUE)
Sys.setlocale("LC_ALL", locale = "KOR")

# Optional: specify where the temporary files (used by the ff package) will be created:
fftempdir <- if (Sys.getenv("FFTEMP_DIR") == "") "~/fftemp" else Sys.getenv("FFTEMP_DIR")
options(fftempdir = fftempdir)

# Details for connecting to the server:
dbms = Sys.getenv("DBMS")
user <- if (Sys.getenv("DB_USER") == "") NULL else Sys.getenv("DB_USER")
password <- if (Sys.getenv("DB_PASSWORD") == "") NULL else Sys.getenv("DB_PASSWORD")
server = Sys.getenv("DB_SERVER")
port = Sys.getenv("DB_PORT")

# connectionString is optional
# if specified, the server, port fields are ignored. If user and password are not specified, they are assumed to already be included in the connection string.
connectionString = if (Sys.getenv("CONNECTION_STRING") == "") NULL else Sys.getenv("CONNECTION_STRING")

# Author details
authors <-"<your_name>" # used on the title page

# Details specific to the database:
databaseId <- "<your_id>" #for example SYNPUF (this will be used as results sub-folder)
databaseName <- "<your_full_databasename>"
databaseDescription <- "<your_description>"

# For Oracle: define a schema that can be used to emulate temp tables:
oracleTempSchema <- NULL

# Details for connecting to the CDM and storing the results
outputFolder <- file.path(getwd(), "results",databaseId)
cdmDatabaseSchema <- "<your_cdm_schema>"
resultsDatabaseSchema <- "<your_results_schema>" #Make sure the Achilles results are in this schema!
vocabDatabaseSchema <- "<your_vocab_schema>"

cohortDatabaseSchema <- "<your_cohort_schema>"
cohortTable <- "CdmInspectionCohort"

# Url to check the version of your local Atlas
# baseUrl <- "<your_baseUrl>"
# example: "http://atlas-demo.ohdsi.org/WebAPI"

# All results smaller than this value are removed from the results.
smallCellCount <- 5

verboseMode <- TRUE

# *******************************************************
# SECTION 3: Run the package
# *******************************************************


folder <- "./Java_home"
DatabaseConnector::downloadJdbcDrivers(dbms = dbms, pathToDriver = folder)

connectionDetails <- DatabaseConnector::createConnectionDetails(dbms = dbms,
                                                                server = server,
                                                                user = user,
                                                                password = password,
                                                                # connectionString = connectionString,
                                                                pathToDriver = folder)

# If your version of DatabaseConnector is < 4.0, please run codes below
# connectionDetails <- DatabaseConnector::createConnectionDetails(dbms = dbms,
#                                                                 server = server,
#                                                                 user = user,
#                                                                 password = password,
#                                                                 # connectionString = connectionString)

results<-cdmInspection(connectionDetails,
                       cdmDatabaseSchema = cdmDatabaseSchema,
                       cohortDatabaseSchema = cohortDatabaseSchema,
                       cohortTable = cohortTable,
                       resultsDatabaseSchema = resultsDatabaseSchema,
                       vocabDatabaseSchema = vocabDatabaseSchema,
                       oracleTempSchema = oracleTempSchema,
                       databaseId = databaseId,
                       databaseName = databaseName,
                       databaseDescription = databaseDescription,
                       runVocabularyChecks = TRUE,
                       runDataTablesChecks = TRUE,
                       runPerformanceChecks = TRUE,
                       createCohorts = TRUE,
                       runWebAPIChecks = FALSE,
                       smallCellCount = smallCellCount,
                       baseUrl,
                       sqlOnly = FALSE,
                       outputFolder = outputFolder,
                       verboseMode = verboseMode)

docTemplate = "FEEDERNET"

generateResultsDocumentKor(results, outputFolder, authors=authors, docTemplate = "FEEDERNET", databaseDescription = databaseDescription, databaseName = databaseName, databaseId = databaseId, smallCellCount = smallCellCount)
