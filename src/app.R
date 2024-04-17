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
    titlePanel("Breast Cancer Awareness"),
    p("This Dashboard provides a brief summary about the number of new breast cancer cases in Canada over 10 years(2012-2021)"),
    p(""),
    tags$style(type = "text/css", 
               ".column-panel { background-color: #f0f0f0; padding: 10px; }",
               ".main-panel { border: 1px solid #ccc; padding: 10px; margin-bottom: 20px; }",
               ".table-container { border: 1px solid #ccc; padding: 10px; }"),
    tags$style(type = "text/css", 
               ".column-panel { background-color: #f0f0f0; padding: 10px; }"),
    sidebarPanel(
           selectInput(
        'x_col_year',
        'SELECT YEAR (table)',
        choices = year_data$DATE,
        selected = 2015
      ),
      selectInput(
        'x_col',
        'SELECT PROVINCE (bar)',
        choices = age_data$GEO,
        selected = age_data$GEO[1]
      ),
      selectInput(
        'x_col_pie',
        'SELECT PROVINCE (pie)',
        choices = type_data$GEO,
        selected = type_data$GEO[1]
      )
  ),
    mainPanel(
      fluidRow(
        column(
          width = 4,
        h5("Top 5 Provinces (new cases of Breast Cancer)"),
        tableOutput('table'),),
        column(
          width = 8,
        h5("Distribution of top 5 Cancers"),
        plotOutput("pie_chart",height = "200px"),)),
      h5("Average no. of cases across groups"),
      plotOutput("bar_plot",height = "400px"),
    )
  )

  
  # Server side callbacks/reactivity
  server <- function(input, output, session) {
    output$bar_plot <- renderPlot({  # Change 'plot' to 'bar_plot'
      filtered_data <- age_data %>%
        filter(GEO == input$x_col) %>%
        mutate(VALUE = round(VALUE,0))
      
      ggplot(filtered_data, aes(x = Age_group, y = VALUE)) +
        geom_bar(stat = "identity", fill = 'purple')+
        geom_text(aes(label = VALUE), vjust = -0.5, color = "black", size = 3.5)+
        labs(x = "Age Group",
             y = "Avg no. of new Breast Cancer cases")+
        theme_minimal()+
        theme(panel.grid.major = element_blank(),
              panel.grid.minor = element_blank())
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
        dplyr::select(GEO, VALUE) %>%
        mutate(VALUE = round(VALUE,0)) %>%
        arrange(desc(VALUE)) %>%
        head(5)
      return(table_data)
    })
    
  }
  
  # Run the app/dashboard
  shinyApp(ui, server)
