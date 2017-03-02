# Shiny Swimming App
# File: 08_CCSA_Data_Collect
# Sean Warlick
# February 10, 2016
###############################################################################

# Notes
###############################################################################
#' I tried to do the data colleciton in set of two loops, however this did not work well.  When there were errors with Selenium it was very hard to restart from the error.  In order to ensure that the error collection is smooth I set up a function and will run it for each week for each conference.  This will make it easier to fix errors as they occur. 
# Set Up R Enviroment
###############################################################################

# Library Load
library(swimR)

# Set Up File Paths
data_path <- '~/Documents/Github/shiny-swimming/data_download'
db_name <- '~/Documents/Github/shiny-swimming/data/swim_data_base.sqlite'

# Set up database connection
driver <- RSQLite::SQLite()
con <- DBI::dbConnect(driver, db_name)

# Create database and tables
swim_db_tables(con)

# Set Up Function To Do Data Collection

data_collection <- function(conference, start, end, con) {
	print(paste('Fetching data for', 
					    conference, 
					    'during week of', 
					    start))
	
	meet_results <- individual_swims(conference,
									start_date = start,
									end_date = end,
									top = 500,
									download_path = data_path
									)

	# Check that the function returned data
	rows <- nrow(meet_results)
	if(rows > 0){
		# Clean up top times report. 
		meet_result_clean <- clean_swim(meet_results)

		# Load Data to database
		swim_db_data_load(con, meet_result_clean, conference)

		print(paste('Data for the',
					  conference,
					  'during the week of',
					  start))
	} else {
		print(paste('No meet results found for the',
				conference,
				'during the week of',
				start))
	}

}

# Data Preperation
###############################################################################
d <- as.Date('2016-08-29')

# Create sequence of mondays and sundays
mondays <- seq(d, by = 7, length.out = 52)
sundays <- seq(d + 6, by = 7, length.out = 52)

# Remove future dates 
mondays <- mondays[mondays < '2017-02-05']
sundays <- sundays[sundays < '2017-02-11']

# Convert vectors to strings
mondays <- as.character(mondays)
sundays <- as.character(sundays)

# Convert vectors to data frame
date_param <- data.frame(cbind(mondays, sundays), stringsAsFactors = FALSE)

# Collect data
###############################################################################
## Get Each Weeks resutl for Coastal College (CCSA)
data_collection('Coastal College (CCSA)', date_param$mondays[1], date_param$sundays[1], con)
data_collection('Coastal College (CCSA)', date_param$mondays[2], date_param$sundays[2], con)
data_collection('Coastal College (CCSA)', date_param$mondays[3], date_param$sundays[3], con)
data_collection('Coastal College (CCSA)', date_param$mondays[4], date_param$sundays[4], con)
data_collection('Coastal College (CCSA)', date_param$mondays[5], date_param$sundays[5], con)
data_collection('Coastal College (CCSA)', date_param$mondays[6], date_param$sundays[6], con)
data_collection('Coastal College (CCSA)', date_param$mondays[7], date_param$sundays[7], con)
data_collection('Coastal College (CCSA)', date_param$mondays[8], date_param$sundays[8], con)
data_collection('Coastal College (CCSA)', date_param$mondays[9], date_param$sundays[9], con)
data_collection('Coastal College (CCSA)', date_param$mondays[10], date_param$sundays[10], con)
data_collection('Coastal College (CCSA)', date_param$mondays[11], date_param$sundays[11], con)
data_collection('Coastal College (CCSA)', date_param$mondays[12], date_param$sundays[12], con)
data_collection('Coastal College (CCSA)', date_param$mondays[13], date_param$sundays[13], con)
data_collection('Coastal College (CCSA)', date_param$mondays[14], date_param$sundays[14], con)
data_collection('Coastal College (CCSA)', date_param$mondays[15], date_param$sundays[15], con)
data_collection('Coastal College (CCSA)', date_param$mondays[16], date_param$sundays[16], con)
data_collection('Coastal College (CCSA)', date_param$mondays[17], date_param$sundays[17], con)
data_collection('Coastal College (CCSA)', date_param$mondays[18], date_param$sundays[18], con)
data_collection('Coastal College (CCSA)', date_param$mondays[19], date_param$sundays[19], con)
data_collection('Coastal College (CCSA)', date_param$mondays[20], date_param$sundays[20], con)
data_collection('Coastal College (CCSA)', date_param$mondays[21], date_param$sundays[21], con)
data_collection('Coastal College (CCSA)', date_param$mondays[22], date_param$sundays[22], con)
data_collection('Coastal College (CCSA)', date_param$mondays[23], date_param$sundays[23], con)