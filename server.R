library(caret)
library(randomForest)
data <- read.csv("Diamond_price.csv", header=TRUE)
data$Price <- gsub('\\$', '', data$Price)
data$Price <- gsub(',', '', data$Price)
mydata <- data[,c(1,2,3,4,5,7,10)]
mydata$Price <- as.numeric(as.character(mydata$Price))
mydata <- mydata[mydata$Price <15000,]
inTrain <- createDataPartition(mydata$Price, p=0.7,list = FALSE)
traindata <- mydata[inTrain,]
testdata <- mydata[-inTrain,]
model.forest <- train(Price~., mydata, method = "rf", trControl = trainControl(method = "cv", number = 3))
testdata$pred <- predict(model.forest, newdata = testdata)

diamondPrice <- function(x){
   predict(model.forest, newdata = x)
}

library(shiny)
shinyServer(
   function(input, output) {
      output$prediction <- renderPrint(diamondPrice(x = data.frame(Shape=input$Shape, Carat=input$Carat,Cut=input$Cut, Color=input$Color, Clarity=input$Clarity, Depth=input$Depth)))
   }
)
