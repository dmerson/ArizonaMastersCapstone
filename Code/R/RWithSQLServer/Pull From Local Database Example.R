library(knitr)	
library(tidyverse)	
library(readxl)	
library(readr)	
library(tidyr)	
library(RODBC)
install.packages("sqldf")
install.packages("DBI")
remove.packages("DBI")
install.packages("RSQLite")
library(RSQLite)
library(sqldf)	
library(readxl)

getSqlQueryFromSUDB <-function(sqlQuery){
  library(RODBC)
  cn <- odbcDriverConnect(connection="driver={SQL Server};server=POWER\\POWER17;database=ScholarshipAwardingSystems;trusted_connection=true")
  resultSet <- sqlQuery(cn,sqlQuery)
  odbcClose(cn)
  return (resultSet)
}
#pull the algorithms
getSqlQueryFromSUDB("Select * from algorithms")

#run all algorithms
getSqlQueryFromSUDB("RunAllAlgorithms  1,   1000,   310,  2")
getSqlQueryFromSUDB("RunAlgorithm1  1,   1600,   300,  2")
getSqlQueryFromSUDB("RunAlgorithm2  1, 1600, 300, 2")
getSqlQueryFromSUDB("RunAlgorithm3   1, 1000, 310, 2")
getSqlQueryFromSUDB("RunAlgorithm4   1, 1600, 300, 2")
getSqlQueryFromSUDB("RunAlgorithm5   1, 1600, 300, 2")
getSqlQueryFromSUDB("RunAlgorithm6   1, 1600, 300, 2")
getSqlQueryFromSUDB("RunAlgorithm7   1, 1600, 300, 2")
