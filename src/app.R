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
  year_data <- read_csv("../data/filtered/year_data.csv")
  
  
  # Layout
  ui <- fluidPage(
    tags$head(
      tags$style(
        HTML(
          ".dashboard-header {
          background-color: #ffc0cb; /* Change the color code to your desired color */
          color: black; /* Change the text color if needed */
          padding: 10px; /* Adjust the padding as needed */
        }
        .chart-container {
          border: 1px solid #ccc; /* Add grey border */
          background-color: #f0f0f0; /* Add grey background */
          padding: 10px; /* Adjust the padding as needed */
          margin-bottom: 20px; /* Add margin bottom for spacing */
        }"  
        )
      )
    ),
    div(class = "dashboard-header",
        titlePanel("Breast Cancer Awareness"),
    p("This Dashboard provides a brief summary about the number of new breast cancer cases in Canada over 10 years(2012-2021)"),
    ),
        p(""),
    tags$style(type = "text/css", 
               ".column-panel { background-color: #f0f0f0; padding: 10px; }",
               ".main-panel { border: 1px solid #ccc; padding: 5px; margin-bottom: 10px; }",
               ".table-container { border: 1px solid #ccc; padding: 5px; }"),
    tags$style(type = "text/css", 
               ".column-panel { background-color: #f0f0f0; padding: 10px; }"),
    sidebarPanel(
           selectInput(
        'x_col_year',
        'SELECT YEAR (for table)',
        choices = year_data$DATE,
        selected = 2012
      ),
      selectInput(
        'x_col_pie',
        'SELECT PROVINCE (for pie chart)',
        choices = type_data$GEO,
        selected = 'Alberta'
      ),
      selectInput(
        'x_col',
        'SELECT PROVINCE (for bar chart)',
        choices = age_data$GEO,
        selected = 'Alberta'
      )
  ),
  mainPanel(
    fluidRow(
      column(
        width = 5,
        div(class = "chart-container",
            h4("Top 5 Provinces (new cases of Breast Cancer)"),
            tableOutput('table')
        )
      ),
      column(
        width = 7,
        div(class = "chart-container",
            h4("Distribution of Top 5 Cancers"),
            plotOutput("pie_chart", height = "220px")
        )
      )
    ),
    div(class = "chart-container",
        h4("Average no. of cases across Age groups"),
        plotOutput("bar_plot", height = "400px")
    )
  )
  )

  
  # Server side callbacks/reactivity
  server <- function(input, output, session) {
    observe({
      updateSelectInput(session, "x_col_year", selected = year_data$DATE[1])
      updateSelectInput(session, "x_col", selected = age_data$GEO[1])
      updateSelectInput(session, "x_col_pie", selected = type_data$GEO[1])
    })
    output$bar_plot <- renderPlot({  # Change 'plot' to 'bar_plot'
      filtered_data <- age_data %>%
        filter(GEO == input$x_col) %>%
        mutate(VALUE = round(VALUE,0))
      
      ggplot(filtered_data, aes(x = Age_group, y = VALUE)) +
        geom_bar(stat = "identity", fill = 'pink')+
        geom_text(aes(label = VALUE), vjust = -0.5, color = "black", size = 5)+
        labs(x = "Age Group",
             y = "Avg no. of new Breast Cancer cases")+
        theme_minimal()+
        theme(panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              axis.text = element_text(color = "black", size = 12))
    })
    output$pie_chart <- renderPlot({
      filtered_data2 <- type_data %>%
        filter(GEO == input$x_col_pie) %>%
        mutate(VALUE = round(Percentage, 2))
      
      # Create pie chart
      ggplot(filtered_data2, aes(x = "", y = VALUE, fill = Cancer_type)) +
        geom_bar(stat = "identity", width = 1) +
        geom_text(aes(label = paste0(round(VALUE/sum(VALUE) * 100), "%")), 
                  position = position_stack(vjust = 0.5), 
                  color = "white", size = 5) +  
        coord_polar(theta = "y") +
        theme_void() +
        theme(legend.position = "right")+
        labs(fill = "Cancer Types")
    })
    output$table <- renderTable({
      table_data <- year_data %>%
        filter(DATE == input$x_col_year) %>%
        dplyr::select(Province = GEO, Value = VALUE) %>%
        mutate(Value = round(Value, 0)) %>%
        arrange(desc(Value)) %>%
        head(5) %>%
        mutate(rank = as.integer(rank(-Value)),
               Value = as.integer(Value)) %>%
        select(rank, Province, Value) 
      return(table_data)
    })
    
  }
  
  # Run the app/dashboard
  shinyApp(ui, server)
