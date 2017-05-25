

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


# Dashboard Header ####
################################################################################
header <- dashboardHeader(title = 'College Swimming')

## Dashboard Sidebar ####
################################################################################
side_bar <- dashboardSidebar(

    sidebarMenu(
        menuItem('NCAA', tabName = "ncaa"),
        menuItem('Team Results', tabName = 'team'),
        menuItem('Individual Results', tabName = 'individual')
    ),

    h4('Filters'),
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
    )
# Dashboard Body ####
################################################################################
body <- dashboardBody(
    tabItems(
        tabItem(tabName = 'ncaa',
            h2('Filler Content')
        ),
        tabItem(tabName = 'team',
            fluidRow(
                valueBoxOutput("menbox"),
                valueBoxOutput("menA"),
                valueBoxOutput("menB")
            ),

            fluidRow(
                valueBoxOutput("womenbox"),
                valueBoxOutput("womenA"),
                valueBoxOutput("womenB")
            ),

            fluidRow(
                box(dataTableOutput("top_times_table"),
                    collapsible = TRUE,
                    width = 12)
            )
        ),

        tabItem(tabName = 'individual',
            h2('Filler Content')
        )
    )
)

dashboardPage(header, side_bar, body, skin = 'black')