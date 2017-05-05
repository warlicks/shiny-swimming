

# Set Up R Enviroment ####
################################################################################
################################################################################

# Libary Load
library(dplyr)
library(magrittr)
library(shiny)
library(shinydashboard)

# Set Database Path
db_name <- '~/Documents/Github/shiny-swimming/data/swim_data_base.sqlite'

# Set up database connection
driver <- RSQLite::SQLite()
con <- DBI::dbConnect(driver, db_name)

# Get List of Team Names For Input
teams <- DBI::dbReadTable(con, 'TEAM')
teams <- teams %>% arrange(TEAM_NAME)

# Get List of Events For Input
event_df <- DBI::dbReadTable(con, 'EVENT')
events <- c('All', event_df$EVENT)

# Dashboard Layout ####
################################################################################
################################################################################
dashboardPage(

# Dashboard Header ####
################################################################################
    dashboardHeader(title = 'College Swimming'),

## Dashboard Sidebar ####
################################################################################
    dashboardSidebar(
        selectInput('team',
                     'Select Team',
                     as.list(teams$TEAM_NAME),
                     selected = teams$TEAM_NAME[1],
                     multiple = FALSE),
        radioButtons('gender',
                     'Select Athlete Gender',
                     c('Both' = 'Both',
                       'Men' = 'M',
                       'Women' = 'F')),
         selectInput('event',
                     'Select Event(s)',
                      as.list(events),
                     selected = 'All',
                     multiple = TRUE)
    ),
# Dashboard Body ####
################################################################################
    dashboardBody(
        fluidRow(
            valueBoxOutput("menbox"),
            valueBox(1, 'A Cut', icon = icon('clock-o', lib = 'font-awesome')),
            valueBox(2, 'B Cut', icon = icon('clock-o', lib = 'font-awesome'))
        ),
        fluidRow(
            valueBoxOutput("womenbox"),
            valueBox(1, 'A Cut', icon = icon('clock-o', lib = 'font-awesome')),
            valueBox(2, 'B Cut', icon = icon('clock-o', lib = 'font-awesome'))
        ),
        fluidRow(
            box(dataTableOutput("top_times_table"),
                collapsible = TRUE,
                width = 12)
        )
    )
)