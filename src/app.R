# If you want the same port each time and enable hot reloading
options(shiny.port = 8050, shiny.autoreload = TRUE)

library(shiny)
library(ggplot2)
library(dplyr)
library(tidyr)
library(readr)

# No explicit initialization in Shiny

# Data loading
age_data <- read.csv("../data/filtered/age_data.csv") 
type_data <- read_csv("../data/filtered/canc_type_data.csv")

# Layout
ui <- fluidPage(
  h1("Breast Cancer Awareness"),
  p("This Dashboard provides a brief summary about the number of new breast cancer cases in Canada over the past 10 years"),
  p(""),
  plotOutput("bar_plot", width = "500px"),  # Change 'plot' to 'bar_plot'
  # plotOutput("pie_chart"),
  selectInput(
    'x_col',
    'SELECT PROVINCE',
    choices = age_data$GEO,
    selected = 'Alberta'
  )
)

# Server side callbacks/reactivity
server <- function(input, output, session) {
  output$bar_plot <- renderPlot({  # Change 'plot' to 'bar_plot'
    filtered_data <- age_data %>%
      filter(GEO == input$x_col) %>%
      mutate(VALUE = round(VALUE,0))
    
    ggplot(filtered_data, aes(x = Age_group, y = VALUE)) +
      geom_bar(stat = "identity", fill = 'darkblue')+
      geom_text(aes(label = VALUE), vjust = -0.5, color = "black", size = 3.5)+
      labs(x = "Age Group",
           y = "Avg no. of new Breast Cancer cases",
           title = "Average no. of cases across groups")
  })
  output$pie_chart <- renderPlot({
    filtered_data2 <- type_data %>%
      filter(GEO == input$x_col) %>%
      mutate(VALUE = round(Percentage, 2))
    
    # Create pie chart
    pie(filtered_data2$Percentage, labels = filtered_data2$Cancer_type, main = "Distribution of Cancer Types")
  })
  
}

# Run the app/dashboard
shinyApp(ui, server)
