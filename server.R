
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(swimR)
library(shiny)

db_name <- '~/Documents/Github/shiny-swimming/data/swim_data_base.sqlite'

# Set up database connection
driver <- RSQLite::SQLite()
con <- DBI::dbConnect(driver, db_name)

# Get List of Team Names
teams <- DBI::dbReadTable(con, 'TEAM')
teams <- c(NULL, teams$TEAM_NAME)

shinyServer(function(input, output) {
	output$top_times_table <- renderDataTable({
		report_top_times(con,
                 team_name = input$team,
                 gender = input$gender,
                 event = input$event,
                 multiple_results = FALSE)
	})
  #  output$distPlot <- renderPlot({

  #   # generate bins based on input$bins from ui.R
  #   x    <- faithful[, 2]
  #   bins <- seq(min(x), max(x), length.out = input$bins + 1)

  #   # draw the histogram with the specified number of bins
  #   hist(x, breaks = bins, col = 'darkgray', border = 'white')

  # })

})
