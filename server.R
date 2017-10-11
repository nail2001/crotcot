
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(readxl)
library(sjPlot)

shinyServer(function(input, output, session) {
  observeEvent(input$file1, {
    if(is.null(input$file1)) return(NULL)

    inFile <- input$file1
    file.rename(inFile$datapath, paste(inFile$datapath, ".xlsx", sep=""))
    session$userData$mydata <- read_excel(paste(inFile$datapath, ".xlsx", sep=""), 1)
    session$userData$mydata <- as.data.frame(session$userData$mydata)
    session$userData$mydata[session$userData$mydata == "NA"] <- NA #correct NA's
    session$userData$mydata <- droplevels(session$userData$mydata) #remove NA level
    
    updateSelectInput(session, "var1", choices=names(session$userData$mydata))
    updateSelectInput(session, "var1", selected=names(session$userData$mydata)[2])
    updateSelectInput(session, "var2", choices=names(session$userData$mydata))
    updateSelectInput(session, "var2", selected=names(session$userData$mydata)[3])
  })
  
  output$contents <- renderUI({
    if(is.null(input$file1)) return(NULL)

    mytab <- sjt.xtab(session$userData$mydata[, input$var1], session$userData$mydata[, input$var2],
             var.labels = c(input$var1, input$var2),
             show.col.prc = input$colprc,
             show.row.prc = input$rowprc,
             show.cell.prc = input$totprc,
             show.summary = input$summary,
             show.na = F,
             wrap.labels = 50,
             tdcol.col = "#1f97cf",
             emph.total = T,
             emph.color = "#e5f4fb",
             use.viewer = T,
             CSS = list(css.table = "border: 1px solid;",
                        css.tdata = "border: 1px solid;"))
    
    HTML(mytab$knitr)
  })
  
  output$downloadData <- downloadHandler(
    filename = "template.xlsx",
    content = function(file) {
      file.copy("template.xlsx", file)
    }
  )
})
