
library(ggplot2)
library(shiny)
library(leaps)
library(rsconnect)


data <- read.csv("BodyFat_Cleaned.csv") 
modelfinal <- lm(BODYFAT ~ WEIGHT + ABDOMEN , data = data)


bodyfat_tables <- list(
  "20-29" = data.frame(
    Category = c("Low (Increased Health Risk)", "Excellent/Fit (Healthy)", "Good/Normal (Healthy)", "Fair/Average (Healthy)", "Poor (Increased Health Risk)", "High (Increased Health Risk)"),
    Percentage = c("<8%", "<=10.5%", "10.6-14.8%", "14.9-18.6%", "18.7-23.1%", ">=23.2%")
  ),
  "30-39" = data.frame(
    Category = c("Low (Increased Health Risk)", "Excellent/Fit (Healthy)", "Good/Normal (Healthy)", "Fair/Average (Healthy)", "Poor (Increased Health Risk)", "High (Increased Health Risk)"),
    Percentage = c("<8%", "<=14.5%", "14.6-18.2%", "18.3-21.3%", "21.4-24.9%", ">=25%")
  ),
  "40-49" = data.frame(
    Category = c("Low (Increased Health Risk)", "Excellent/Fit (Healthy)", "Good/Normal (Healthy)", "Fair/Average (Healthy)", "Poor (Increased Health Risk)", "High (Increased Health Risk)"),
    Percentage = c("<8%", "<=17.4%", "17.5-20.6%", "20.7-23.4%", "23.5-26.6%", ">=26.7%")
  ),
  "50-59" = data.frame(
    Category = c("Low (Increased Health Risk)", "Excellent/Fit (Healthy)", "Good/Normal (Healthy)", "Fair/Average (Healthy)", "Poor (Increased Health Risk)", "High (Increased Health Risk)"),
    Percentage = c("<8%", "<=19.1%", "19.2-22.1%", "22.2-24.6%", "24.7-27.8%", ">=27.9%")
  ),
  "60-69" = data.frame(
    Category = c("Low (Increased Health Risk)", "Excellent/Fit (Healthy)", "Good/Normal (Healthy)", "Fair/Average (Healthy)", "Poor (Increased Health Risk)", "High (Increased Health Risk)"),
    Percentage = c("<8%", "<=19.7%", "19.8-22.6%", "22.7-25.2%", "25.3-28.4%", ">=28.5%")
  )
)

#UI
ui <- fluidPage(
  
  titlePanel("Body Fat Prediction"),
  
  
  fluidRow(
    
    column(4,
           numericInput("weight", "Weight(lbs):", value = 180, min = 0, max = 1235, step = 1),
           numericInput("abdomen", "Abdomen Circumference(cm):", value = 95, min = 0, max = 600, step = 0.1),
           #CLIP BUTTON
           actionButton("submit", "Predict Body Fat")
    ),
    
    column(8,
           htmlOutput("prediction"),
           
           #AGE SELECT
           selectInput("age_group", "Select Age Group:",
                       choices = c("20-29 years" = "20-29", "30-39 years" = "30-39", "40-49 years" = "40-49", "50-59 years" = "50-59", "60-69 years" = "60-69")),
           
           h3("Body Fat Percentage Table for Men"),
           tableOutput("bodyfat_table")
    )
  ),
  
  h3("Need help?"),
  p("If you have any questions about the app, feel free to contact us at:"),
  p("Email: hyunseung@stat.wisc.edu, clou25@wisc.edu, rming@wisc.edu, szhang655@wisc.edu, myu259@wisc.edu"),
  p("Copyright @ Fall2024-Stat628-Module2-Group5")
)

#SERVER
server <- function(input, output) {
  output$bodyfat_table <- renderTable({
    selected_age_group <- input$age_group
    bodyfat_tables[[selected_age_group]]
  })
  
  # PREDIECT
  observeEvent(input$submit, {
    #EXAM ERROR
    if (input$weight > 1235 || input$weight < 0) {
      output$prediction <- renderText({
        "Error: Please enter a valid weight between 50 and 1235 lbs."
      })
    } else if (input$abdomen > 600 || input$abdomen < 0) {
      output$prediction <- renderText({
        "Error: Please enter a valid abdomen circumference between 50 and 150 cm."
      })
    } else {
      new_data <- data.frame(
        WEIGHT = input$weight,
        ABDOMEN = input$abdomen
      )
      
      
      predicted_bodyfat <- predict(modelfinal, new_data)
      
      #PREIDECT ERROR
      if (predicted_bodyfat <= 0 || predicted_bodyfat >= 100) {
        output$prediction <- renderText({
          "Error: The predicted body fat is invalid. Please check your input values."
        })
      } else {
        output$prediction <- renderUI({
          HTML(paste("<strong>Predicted Body Fat:</strong>", round(predicted_bodyfat, 2), "%</div>"))
        })
      }
    }
  })
}

shinyApp(ui = ui, server = server)



