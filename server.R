
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(swimR)
library(shiny)
library(dplyr)

db_name <- '~/Documents/Github/shiny-swimming/data/swim_data_base.sqlite'

# Set up database connection
driver <- RSQLite::SQLite()
con <- DBI::dbConnect(driver, db_name)

# Define Server Functions
shinyServer( function(input, output) {

    # Create A Table of Time Times
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

	# Create Athlete Counts By Team
    ############################################################################

	## Men
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

	## Women
	output$womenbox <- renderValueBox({
	    women_count <- athlete_count(con,
	                               team_name = input$team) %>%
	        filter(GENDER == 'F')

	    valueBox(women_count$C1,
	             'Women',
	             icon = icon('female', lib = 'font-awesome'))
	})
    # Create Counts of NCAA Qualifers
	############################################################################

	## Men's A Qualifers
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

	## Men's B Qualifers
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

	## Women's A Cuts
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

	## Women's B Cuts
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

	# Create Plot of Depth By Event
	############################################################################
	output$event_depth <- renderPlot({
	    event_depth(con, input$team, input$gender) %>%
	        ggplot(aes(EVENT, ATHLETE_COUNT, fill = GENDER)) +
	        geom_col( position = 'dodge') +
	        labs(x = 'Event', y = 'Number of Athletes') +
	        theme(axis.text.x=element_text(angle = 45))+
	        scale_fill_discrete(breaks = c('M', 'F'),
	                            labels = c('Men', 'Women'),
	                            guide = guide_legend(title = 'Gender'))
	})

	# Create Plot of Depth By Distance
	output$distance_depth <- renderPlot({
	    distance_depth(con, input$team, input$gender) %>%
	    mutate(DISTANCE = as.numeric((DISTANCE))) %>%
	    arrange(DISTANCE, GENDER) %>%
	    ggplot(aes(as.factor(DISTANCE),
	               `Count(Distinct ATHLETE_ID)`,
	               fill = GENDER)
	    ) +
	    geom_col(position = 'dodge') +
	    scale_fill_discrete(breaks = c('M', 'F'),
	                        labels = c('Men', 'Women'),
	                        guide = guide_legend(title = 'Gender')) +
	    labs(x = 'Distance', y = 'Number of Athletes')
	})

})
