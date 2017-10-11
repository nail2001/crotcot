
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(
  titlePanel("CROTCOT: a CrossTabs and Correlations tool"),

  sidebarLayout(
    sidebarPanel(
      fileInput('file1', 'Dataset (.xlsx, see template)', accept = c(".xlsx")),
      selectInput("var1", "Choose VAR1:", choices = c("unknown")),
      selectInput("var2", "Choose VAR2:", choices = c("unknown")),
      checkboxInput("summary", "Summary", T),
      checkboxInput("rowprc", "Row percentages", T),
      checkboxInput("colprc", "Col percentages", T),
      checkboxInput("totprc", "Total percentages", T),
      hr(),
      HTML("<font color='#ff0000'><p>Please use the template to send a dataset.</p></font>"),
      downloadButton("downloadData", "Download dataset template")
    ),
    mainPanel(
      htmlOutput('contents')
    )
  )
))
