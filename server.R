
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
shinyServer( function(input, output) {

	output$top_times_table <- renderDataTable({
		report_top_times(con,
                 team_name = input$team,
                 gender = input$gender,
                 event = input$event) %>%
        select(Athlete = ATHLETE_NAME,
               Gender = GENDER,
               Team = TEAM_NAME,
               Event = EVENT_NAME,
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
	             icon = icon('female', lib = 'font-awesome'))
	})

	output$menA <- renderValueBox({
	    men_acut <- report_ncaa_qualifiers(con,
	                                         team_name = input$team) %>%
	        filter(GENDER == 'M' & STANDARD == 'A') %>%
	        rename(cnt = `n_distinct(ATHLETE_NAME)`)

	    if(nrow(men_acut) == 0){
	        men_acut <- data_frame('GENDER' = 'M', 'cnt' = 0)
	    }

	    valueBox(men_acut$cnt,
	             'A Cuts',
	             icon = icon('clock-o', lib = 'font-awesome'))
	})

	output$menB <- renderValueBox({
	    men_bcut <- report_ncaa_qualifiers(con,
	                                         team_name = input$team) %>%
	        filter(GENDER == 'M' & STANDARD == 'B') %>%
	        rename(cnt = `n_distinct(ATHLETE_NAME)`)

	    if(nrow(men_bcut) == 0){
	        men_bcut <- data_frame('GENDER' = 'M', 'cnt' = 0)
	    }

	    valueBox(men_bcut$cnt,
	             'B Cuts',
	             icon = icon('clock-o', lib = 'font-awesome'))
	})
	output$womenA <- renderValueBox({
	    women_acut <- report_ncaa_qualifiers(con,
	                                         team_name = input$team) %>%
	        filter(GENDER == 'F' & STANDARD == 'A') %>%
	        rename(cnt = `n_distinct(ATHLETE_NAME)`)

	    if(nrow(women_acut) == 0){
	        women_acut <- data_frame('GENDER' = 'F', 'cnt' = 0)
	    }

        valueBox(women_acut$cnt,
	             'A Cuts',
	             icon = icon('clock-o', lib = 'font-awesome'))
	})

	output$womenB <- renderValueBox({
	    women_bcut <- report_ncaa_qualifiers(con,
	                                         team_name = input$team) %>%
	        filter(GENDER == 'F' & STANDARD == 'B') %>%
	        rename(cnt = `n_distinct(ATHLETE_NAME)`)

	    if(nrow(women_bcut) == 0){
	        women_bcut <- data_frame('GENDER' = 'F', 'cnt' = 0)
	    }

	    valueBox(women_bcut$cnt,
	             'B Cuts',
	             icon = icon('clock-o', lib = 'font-awesome'))
	})

})
