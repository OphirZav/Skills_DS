
# Setup -------------------------------------------------------------------

library(dplyr)
library(shiny)
library(shinydashboard) # make powerfull dashboards 
# https://rstudio.github.io/shinydashboard/index.html





# Data --------------------------------------------------------------------

data <- readxl::read_xlsx("file_a3664f94-0441-4e67-bc94-d4ada374a1db.xlsx", 
                          range = "A19:I39") |> 
  rename(Year = 1) |> 
  mutate(across(.fns = as.numeric)) |> 
  tidyr::pivot_longer(-Year, names_to = "Type", values_to = "Tons") |> 
  mutate(Type = factor(Type))

head(data)






# ui ----------------------------------------------------------------------

ui <- dashboardPage(
  dashboardHeader(title = "Recycling In Israel"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Plot", tabName = "itm_plot", icon = icon("chart-line")),
      menuItem("Table", tabName = "itm_tab", icon = icon("table"))  
    )
  ),
  
  dashboardBody(
    # Inputs
    selectInput("gar_type", "Select type to highlight",
                choices = unique(data$Type)),
    sliderInput("yr_range",
                "Year Range",
                min = min(data$Year),
                max = max(data$Year),
                value = range(data$Year)),
    
    h3("Output"),
    
    # Tabbed outputs 
    tabItems(
      tabItem("itm_plot",
              fluidRow(
                plotOutput("plot_gar")
              )),
      
      
      tabItem("itm_tab",
              fluidRow(
                tableOutput("tab_summ")
              )) 
    )
  ), skin = "green"
)







# server ------------------------------------------------------------------

server <- function(input, output) {
  output$plot_gar <- renderPlot({
    ggplot2::ggplot()
  })
  
  output$tab_summ <- renderTable({
    data.frame(Var = NA)
  })
}








# Run ---------------------------------------------------------------------

shinyApp(ui, server)






# Exercise ----------------------------------------------------------------

# 1. Make the outputs:
# 1.1. "plot_gar" should be a plot with time (x) and tons (y). It should react
#     to "gar_type" - highlighting (somehow) the selected type.
# 1.2. "tab_summ" should be a table of summary statistics for each 'type' of
#     waste. It should be reactive to "yr_range" - showing info only for the
#     selected range of years.
# 
# 2. Add an action-button. Make some reactivity dependent on pressing it.
# 
# 3. Add another type of input and another type of output.
#
# 4. Play around with the layout.


