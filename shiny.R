library(shiny)
library(quantmod)
library(dplyr)
library(ggplot2)
library(data.table)
library(DT)
library(plotly)
library(tidyr)
library(shinydashboard)

header <- dashboardHeader(title = "Personas Desaparecidas o Extraviadas en Mexico")

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem(
      fileInput(
        inputId = "fileinput",
        label = "Selecione csv"
      )
    ),
    menuItem(
      selectInput(
        inputId = "Selector",
        label = "Seleccione una opcion",
        choices = c("Sexo", "Estado", "Nacionalidad") 
      )
    )
  )
)


body <- dashboardBody(
  tabsetPanel(
    tabPanel(
      title = "Tabla",
      dataTableOutput("tabla")
    ),
    tabPanel(
      title = "Grafica de los datos",
      plotlyOutput("plot")
    )
  )
)

ui <- dashboardPage(header = header,
                    sidebar =sidebar,
                    body = body)

server <- function(input, output)
{
  personas <- reactive(
    {
      if (is.null(input$fileinput)){
        personas <- read.csv("~/actividades/RNPEDFF.csv")
        return(personas)
      }
      
      personas <- read.csv(as.character(input$fileinput[1]))
      return(personas)
    }
  )   
  output$tabla <- renderDataTable(
    {personas()},
    class = "display noerap compact",
    filter = "bot",
    options = list(scrollx = TRUE, scrollCollapse = TRUE)
  )
  output$plot <- plotlyOutput({
    return(NULL)
  })
}
shinyApp(ui = ui, server = server)