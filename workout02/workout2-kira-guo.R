library(shiny)
library(ggplot2)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Saving & Investing Modalities"),
   
   # Sidebars
   fluidRow(
     column(4,
            sliderInput("initial", "Initial Amount",
                        min = 0,
                        max = 100000,
                        step = 500,
                        value = 1000,
                        pre = "$")
            ),
     column(4, 
            sliderInput("return", "Return Rate (in %)",
                        min = 0,
                        max = 20,
                        step = 0.1,
                        value = 5)
            ),
     column(4,
            sliderInput("years", "Years",
                        min = 0,
                        max = 50,
                        step = 1,
                        value = 10)
            )),
    fluidRow(
      column(4,
            sliderInput("contrib", "Annual Contribution",
                        min = 0, 
                        max = 50000,
                        step = 500,
                        value = 2000,
                        pre = "$")
      ),
      column(4,
            sliderInput("growth", "Growth Rate (in %)",
                        min = 0, 
                        max = 20, 
                        step = 0.1,
                        value = 2)
      ),
      column(4,
            selectInput("facet", "Facet?", 
                        choices = list("Yes", "No"), 
                        selected = "No")
      )
    ),
   
   #display lineplot and data table 
   mainPanel(
     titlePanel("Timelines"),
     plotOutput("timelines", width = 600, height = "300"),
     titlePanel("Balances"),
     verbatimTextOutput("balances")
   )
)
   

# Define server logic required to draw timeline plot and balance data table
server <- function(input, output) {
   
  # Define functions for different saving options
  
  #' @title funciton future_value()
  #' @description calculate the value return
  #' @param amount initial invested amount
  #' @param rate annual rate of return
  #' @param years number of years
  #' @return value of how much money is returned
  
  future_value <- function(amount, rate, years) {
    fv <- amount * (1 + rate)^years
    return(fv)
  }
  
  #' @title funciton annuity()
  #' @description calculate the value return when depositing a certain amount annually
  #' @param contrib contributed amount
  #' @param rate annual rate of return
  #' @param years number of years
  #' @return value of how much money is returned
  
  annuity <- function(contrib, rate, years) {
    fva <- contrib * (((1 + rate)^years - 1) / rate)
    return(fva)
  }
  
  #' @title funciton annuity()
  #' @description calculate the value return when depositing a growing amount annually
  #' @param contrib contributed amount
  #' @param rate annual rate of return
  #' @param growth annual growth rate
  #' @param years number of years
  #' @return value of how much money is returned
  
  growing_annuity <- function(contrib, rate, growth, years) {
    fvga <- contrib * (((1 + rate)^years - (1 + growth)^years) / (rate - growth))
    return(fvga)
  }
  
  #create data table for different modes
  modalities <- reactive( {
    #inputs
    initial = input$initial
    r = input$return/100
    yrs = input$years
    contrib = input$contrib
    growth = input$growth/100
    
    #initialize vectors
    no_contrib <- length(11)
    fixed_contrib <- length(11)
    growing_contrib <- length(11)
    
    #fill in initial value
    no_contrib[1] = initial
    fixed_contrib[1] = initial
    growing_contrib[1] = initial
    
    #fill in the table
    for (i in 1 : yrs) {
      no_contrib[i + 1] <- future_value(amount = initial, rate = r, years = i)
      fixed_contrib[i + 1] <- future_value(amount = initial, rate = r, years = i) + 
        annuity(contrib = contrib, rate = r, years = i)
      growing_contrib[i + 1] <- future_value(amount = initial, rate = r, years = i) +
        growing_annuity(contrib = contrib, rate = r, growth = growth, years = i)
    }
    
    modalities <- data.frame("years" = c(seq(0, 10, 1)), 
                             "no_contrib" = no_contrib, 
                             "fixed_contrib" = fixed_contrib, 
                             "growing_contrib" = growing_contrib)
    modalities
  }
)
  
  # Plot
  output$timelines <- renderPlot({
    df = modalities()
    yrs = input$years
    df = data.frame(year = rep(df$year, 3), 
                    value = c(df$no_contrib, df$fixed_contrib, df$growing_contrib),
                    Mode = factor(c(rep("no_contrib",yrs+1),
                                    rep("fixed_contrib",yrs+1),
                                    rep("growing_contrib",yrs+1)
                    ), levels = c("no_contrib", "fixed_contrib", "growing_contrib")))
    
    if (input$facet == "No") {
      ggplot(df, aes(x = year, y = value, color = Mode)) +
        geom_line(size = 0.5)+
        geom_point(size = 0.5) + 
        labs(title = "Three Modes of Investing", x = "Year", y = "Value", color = "Mode")
      
    } else {
      # Facetting
      ggplot(df, aes(x = year, y = value))+
        geom_line(aes(color = Mode), size = 0.5) +
        geom_point(aes(color = Mode), size = 0.5) +
        geom_area(aes(fill= Mode), alpha = 0.5) +
        facet_wrap(~Mode) +
        labs(title = "Modes of Investing", x = "Year", y = "Value")
    }
  })
  
  # Table output
  output$balances <- renderPrint({
    modalities()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

