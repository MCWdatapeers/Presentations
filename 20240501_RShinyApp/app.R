
### Data Peers Presentation 2024-05-01 ###
# Lisa Rein: lrein@mcw.edu

# About Shiny ------------------------------------------------------------

# Shiny is a package of wrapper functions that write code to create a web based dashboard
# Shiny is available for R and Python
# Little to no knowledge of web development (html, Java, CSS) required to use Shiny

# SECTION 0: Global -------------------------------------------------------

# Code in this section can be accessed by all parts of the Shiny app
# Use this section to load packages and datasets
# This code can be placed in a separate file called 'global.R'

# Note: do not hard code any paths (via setwd...) like I did when I set this up!
#   When you deploy your app, the home directory will be wherever the app.R file is
# setwd("Z:/presentations/Data Peers/20240501_shinyapp/datapeers_shiny_exp")

library(shiny)
library(tidyverse)
library(bslib)

namedat <- readRDS("names.RDS")

# SECTION 1: User Interface (UI) ------------------------------------------
#
# The ui specifies the layout of everything the user will see and interact with
#  - Page layout:
#     * Layout functions:
#     * Layout is a grid with width of 12
#  - themes: https://bootswatch.com/
#  - Headers and body text
#  - Reactive user input widgets: buttons, check boxes, sliders, drop down menu
#     * Shiny pre-built widgets: https://shiny.posit.co/r/gallery/widgets/widget-gallery/
#     * shinyWidgets R package: https://github.com/dreamRs/shinyWidgets
#     * Other R packages have unique widgets (exp: a color picker widget https://deanattali.com/blog/colourpicker-package/)
#  - Display reactive output objects: plots, tables, text, images
#     * dataTableOutput
#     * htmlOutput
#     * imageOutput
#     * plotOutput
#     * tableOutput
#     * textOutput
#     * uiOutput
#     * verbatimTextOutput

ui <- fluidPage(

    # Application title
    titlePanel("Data Peers Example Shiny App")
    
    # Apply a theme:
    # ,theme = bs_theme(version = 5, bootswatch= "vapor", font_scale = 0.8)
    
    # this adds a horizontal rule linebreak:
    ,hr() 

    # Sidebar layout with input widgets and reactive output:
    ,h3("Display top names for given year")
    ,sidebarLayout(
        sidebarPanel(
            selectInput(inputId = "year"
                        ,label = "Select Year"
                        ,choices = 1880:2022
                        ,selected = 2020
                        ,multiple = FALSE
                        ,selectize = TRUE
                        )
            ,radioButtons(inputId = "gender"
                          ,label = "Select Gender"
                          ,choices = list("Female" = "F"
                                         ,"Male" = "M"
                                         )
                          ,selected = "F"
                          )
            ,sliderInput(inputId = "num"
                         ,label = "Number of names to display:"
                         ,min = 5
                         ,max = 50
                         ,step = 5
                         ,value = 5
                         )
        )

        ,mainPanel(
            textOutput("selected_year")
            ,hr()
            ,textOutput("selected_gender")
            ,hr()
            ,dataTableOutput("topnames")
        )
    )
    ,hr()

    # No sidebar layout with observer outputs:
    ,bslib::card(
        h3("Name popularity over time")
        # ,hr()
        ,textInput(inputId = "searchname_txt"
                   , label = "Name"
                   , value = "Enter name here..."
                   )
        ,hr()
        ,actionButton(inputId = "searchname_button"
                      , label = "Search Name"
                      , icon = NULL
                      , width = '20%'
                      )
        ,hr()
        ,plotOutput("searchname_plot")
        ,dataTableOutput("searchname_rdt")

    )
)


# SECTION 2: Server -------------------------------------------------------

# The server section includes a function
#   - must have input and output arguments, but can have additional arguments
#   - includes R code for any calculations, modeling, graphing, etc.
#   - Re-activity:
#      * Reactive inputs: user input (access via input$inputId)
#      * Reactive outputs: something that appears in browser window 
#         + access via output$outputId
#         + Rendering functions: renderText, renderDataTable, renderPlot, etc.
#         + Reactive outputs are lazy: only react when input changes
#   - Observers: Use 'observe' when you want to induce a 'side-effect'  
#         + One example would be to tie a calculation/effect to an event such as a button push

# Define server logic required to draw a histogram
server <- function(input, output) {

    ### Reactive outputs: (output$*) ###
    output$selected_year <- renderText({
        paste("You have selected the year: ", input$year)
    })
    output$selected_gender <- renderText({
        paste("You have selected gender: ", input$gender)
    })

    output$topnames <- renderDataTable({
        namedat %>%
            dplyr::filter(sex %in% input$gender) %>%
            dplyr::filter(year %in% input$year) %>%
            dplyr::arrange(-freq) %>%
            head(n = input$num)
    })

    ### observe with bindEvent: do a calculation only when the button is pushed ###
    
    # use reactiveValues to store a list of calculated value that will change with reactive input 
    r <- reactiveValues(names_searchname = NULL)

    observe({

        r$names_searchname <- namedat %>% dplyr::filter(name %in% input$searchname_txt)

    }) %>% bindEvent(input$searchname_button)

    output$searchname_plot <- renderPlot({
        if (!is.null(r$names_searchname)){
           p <- ggplot(data = r$names_searchname, aes(x = year, y = freq, group = sex)) +
                       geom_line() +
                       facet_wrap(~sex) +
                       theme_bw() +
                       scale_x_discrete(breaks = seq(1880, 2020, 20)) +
                       ylab("Annual Frequency") +
                       theme(panel.grid.major.x = element_blank()
                             ,panel.grid.major.y = element_blank()
                             )
           p
        }
    })

    output$searchname_rdt <- renderDataTable({
        r$names_searchname
    })
}


# Run the app locally: ---------------------------------------------------

# You can also click the green arrow 'Run App' button in top right corner in RStudio

shinyApp(ui = ui, server = server)

# Advanced Shiny topics ---------------------------------------------------

# Modules
#   - A module is a section of an app that is developed as it's own separate mini-app
#   - Better organization when app is complex
#   - Makes components of app re-useable (kind of like a function or macro)
#   - Makes troubleshooting easier
# Frameworks for creating 'production grade' Shiny apps:
#   - Golem
#   - Rhino (Appsilon)
# Deployment outside of local machine
#   - share as a zip file?
#   - install as R package (Golem)
#   - shinyapps.io
#   - docker

# Resources -------------------------------------------------------------

# 'Mastering Shiny' by Hadley Wickham: https://mastering-shiny.org/index.html
# DSLC (formerly R4DS) slack channel
# Posit video tutorials:
#  - https://posit.co/resources/videos/reactivity-pt-1-joe-cheng/
# Appsilon conference and videos:
#  - https://www.youtube.com/@appsilon_official/videos

