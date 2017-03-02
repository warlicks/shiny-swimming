# Shiny Swimming App
# File: 10_Data_Validation
# Sean Warlick
# March 01, 2017
###############################################################################

# Set up R Enviroment
###############################################################################

# Library Load
library(swimR)
library(DBI)
library(dplyr)

# Set Up database connection
db_name <- "./data/swim_data_base.sqlite"

# Set up database connection
driver <- RSQLite::SQLite()
con <- DBI::dbConnect(driver, db_name)

# Find Conferences with no resutls
###############################################################################

# Get Conference List From Database
query <- dbSendQuery(con, "Select * From Conference")
confernce_results <- dbFetch(query)
dbClearResult(query)

# Get Conference List From USA Swimming
usas_confernces <- get_conferences(1)
names(usas_confernces) <- "NAME"

# Compare the two lists 
usas_confernces %>% anti_join(., confernce_results)

## Only 2 confernces do not appear on the list.  The Sun Belt Conferencce no 
## long sponsors swimming.  The Metropolitan Swimming con contains teams from
## all three divisions.  When I run the top times report for the whole season 
## there are no results for the Metropolitan Conference

# Check on the Event Table 
###############################################################################


## The event table is not populated in the database.  We will try to populate 
## the table by running swim_db_tables().  This potentially could be a problem
## in the swimR package.  

