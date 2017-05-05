
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(swimR)
library(shiny)
library(dplyr)
library(magrittr)

db_name <- '~/Documents/Github/shiny-swimming/data/swim_data_base.sqlite'

# Set up database connection
driver <- RSQLite::SQLite()
con <- DBI::dbConnect(driver, db_name)

# Define Server Functions
shinyServer(function(input, output) {

	output$top_times_table <- renderDataTable({
		report_top_times(con,
                 team_name = input$team,
                 gender = input$gender,
                 event = input$event,
                 multiple_results = FALSE) %>%
        select(Athlete = ATHLETE_NAME,
               Gender = GENDER,
               Team = TEAM_NAME,
               Event = EVENT,
               Time = SWIM_TIME_TEXT,
               Rank = RANK) %>%
        arrange(Gender, Team, Event, Rank)

	})
	output$menbox <- renderValueBox({
	    men_count <- athlete_count(con,
	                               team_name = input$team) %>%
        filter(GENDER == 'M')

	    if (nrow(men_count) == 0){
            men_count <- data_frame('GENDER' = 'M', 'C1' = 0)
	    }

	    valueBox(men_count$C1,
	             'Men',
	             icon = icon('male', lib = 'font-awesome')
	    )
	})
	output$womenbox <- renderValueBox({
	    women_count <- athlete_count(con,
	                               team_name = input$team) %>%
	        filter(GENDER == 'F')

	    valueBox(women_count$C1,
	             'Women',
	             icon = icon('female', lib = 'font-awesome')
	    )
	})

})
