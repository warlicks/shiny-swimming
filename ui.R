

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


# Dashboard Header ####
################################################################################
header <- dashboardHeader(title = 'College Swimming')

## Dashboard Sidebar ####
################################################################################
side_bar <- dashboardSidebar(

    sidebarMenu(
        menuItem('NCAA', tabName = "ncaa"),
        menuItem('Team Results', tabName = 'team'),
        menuItem('Individual Results', tabName = 'individual'),
        menuItem('College Swimming News', tabName = 'swim_news')
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
        # Tab for NCAA ITEMS
        tabItem(tabName = 'ncaa',
            h2('Filler Content')
        ),
        # Tab for Team
        tabItem(tabName = 'team',
            # Men's Wigits
            fluidRow(
                valueBoxOutput("menbox"),
                valueBoxOutput("menA"),
                valueBoxOutput("menB")
            ),
            # Women's Wigits
            fluidRow(
                valueBoxOutput("womenbox"),
                valueBoxOutput("womenA"),
                valueBoxOutput("womenB")
            ),
            # Table of Top Times
            fluidRow(
                box(dataTableOutput("top_times_table"),
                    collapsible = TRUE),
                tabBox(
                    tabPanel(title = 'Depth By Event',
                             plotOutput('event_depth')
                    ),
                    tabPanel(title = 'Depth By Distance',
                              plotOutput('distance_depth')
                    )

                )
            )
        ),
        # Tab For Individual Swims
        tabItem(tabName = 'individual',
            h2('Filler Content')
        ),
        # Tab for News
        tabItem(tabName = 'swim_news',
            fluidPage(
                    tags$iframe(width="550",
                                height="500",
                                src="https://swimswam.com/iframe-embed/?cat=18",
                                frameborder="0",
                                scrolling="auto"),
                    tags$a(href = "https://swimswam.com/?cat=18",
                           style="font-size:10px;color:#CCC;",
                           tags$br("College Swimming News by SwimSwam")
                           )
                )
        )
    )
)
# Combine dashboard elements into a page
################################################################################
dashboardPage(header, side_bar, body, skin = 'black')