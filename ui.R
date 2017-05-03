
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(shinydashboard)

db_name <- '~/Documents/Github/shiny-swimming/data/swim_data_base.sqlite'

# Set up database connection
driver <- RSQLite::SQLite()
con <- DBI::dbConnect(driver, db_name)

# Get List of Team Names
teams <- DBI::dbReadTable(con, 'TEAM')

# Get List of Events
event_df <- DBI::dbReadTable(con, 'EVENT')
events <- c('All', event_df$EVENT)

shinyUI(
    fluidPage(

  # Application title
    titlePanel("Old Faithful Geyser Data"),

  # Sidebar with a slider input for number of bins
    sidebarLayout(
      sidebarPanel(
        selectInput('team',
                    'Select Team',
                    as.list(teams$TEAM_NAME),
                    selected = NULL,
                    multiple = TRUE),
        radioButtons('gender',
                      'Select Athlete Gender',
                      c('Both' = 'Both',
                        'Men' = 'M',
                        'Women' = 'F')),
        selectInput('event',
                    'Select Event(s)',
                    as.list(events),
                    selected = 'ALL',
                    multiple = TRUE)

      ),

    # Show a plot of the generated distribution
    mainPanel(
      dataTableOutput("top_times_table")
      #plotOutput("distPlot")
    )
  )
))
