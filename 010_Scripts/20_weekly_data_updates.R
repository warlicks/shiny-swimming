# Shiny Swimming App
# File: 20_Weekly_Data_Updates
# Sean Warlick
# March 01, 2017
###############################################################################

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

# Set Up Function To Do Data Collection
data_collection <- function(conference, start, end, con) {
	print(paste('Fetching data for', 
			    conference, 
			    'during the week of', 
				start)
	)
	
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

		print(paste('Loading data for',
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

# Start Selenium Server
server <- start_selenium(dir = "~")

# Set Up Dates 
###############################################################################
## Set up for run on Thrusday.
#monday <- as.character(Sys.Date() - 10)
#sunday <- as.character(Sys.Date() - 4)

monday <- '2017-03-06'
sunday <- '2017-03-12'

# Data Collection 
###############################################################################
## The Sun Belt Conference and the Metropolitan swimming conference do not show up when we run top times for them. As a result they are not included in the weekly results.  

data_collection('ACC (Atlantic Coast)', monday, sunday, con)
data_collection('America East', monday, sunday, con)
data_collection('American Athletic Conf', monday, sunday, con)
data_collection('Atlantic 10', monday, sunday, con)
data_collection('Big 12', monday, sunday, con)
data_collection('Big East', monday, sunday, con)
data_collection('Big Ten', monday, sunday, con)
data_collection('Coastal College (CCSA)', monday, sunday, con)
data_collection('Colonial Athletic Assoc', monday, sunday, con)
data_collection('Conference USA', monday, sunday, con)
data_collection('Horizon League', monday, sunday, con)
data_collection('Independent', monday, sunday, con)
data_collection('Ivy League', monday, sunday, con)
data_collection('Metro Atlantic Athl. Conf', monday, sunday, con)
data_collection('Mid-American Conf', monday, sunday, con)
data_collection('Missouri Valley', monday, sunday, con)
data_collection('Mountain Pacific Sports', monday, sunday, con)
data_collection('Mountain West', monday, sunday, con)
data_collection('Northeast Conf', monday, sunday, con)
data_collection('Pacific 12', monday, sunday, con)
data_collection('Pacific Collegiate', monday, sunday, con)
data_collection('SEC (Southeastern)', monday, sunday, con)
data_collection('The Patriot League', monday, sunday, con)
data_collection('The Summit League', monday, sunday, con)
data_collection('Western Athletic Conf', monday, sunday, con)

# Shut Down Server
server$stop()