library(shiny)
library(readr)
library(dplyr)

load("./data/data_shiny.Rdata")
data=data_shiny
colnames(data)[8]="latitude"
colnames(data)[9]="longitude"
rm(data_shiny)


getSiftData<-function(states,booking,month,children,adults,cities){
  
    
  logic1=data$user_location_region%in%states
  logic2=data$is_booking==ifelse(booking==1,1,0)
  logic3=data$month>=month[1]&data$month<=month[2]
  logic4=data$srch_children_cnt>=children[1] & data$srch_children_cnt<=children[2]
  logic5=data$srch_adults_cnt>=adults[1] & data$srch_adults_cnt<=adults[2]
  logic6=data$user_location_city %in% cities
  
  if(is.null(states)){
    logicAll=logic2&logic3&logic4&logic5
  }
  
  else if(is.null(cities))
    logicAll=logic1&logic2&logic3&logic4&logic5
  
  else 
    logicAll=logic1&logic2&logic3&logic4&logic5&logic6
  
  return(data[logicAll,])
}

shinyServer(function(input,output,session) {
  
  dataInput <- reactive({
    getSiftData(input$states,input$booking,input$month,input$children,input$adults,input$cities)
    })
  #create the map
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(
        urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png", #pattern from the url
        attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'#bottomright label.
      ) %>%
      setView(lng = -20.85, lat = 25.55, zoom = 3)
  })
  
  
  
  
  #add markers
  
  observe({
    
    leafletProxy("map", data = dataInput()) %>%
      clearMarkers() %>% addCircleMarkers(lng=~longitude,lat=~latitude,
        radius=1.5,
        color="red",
        stroke=FALSE,
        fillOpacity = 0.5
      )
      
    
    
  })
  
  
  # A reactive expression that returns the set of markers that are
  # in bounds right now
  marksInBounds <- reactive({
    if (is.null(input$map_bounds))
      return(data[FALSE,])
    bounds <- input$map_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    
    subset(dataInput(),
            latitude>= latRng[1] & latitude <= latRng[2] &
             longitude >= lngRng[1] & longitude <= lngRng[2])
  
  })
  observe({
    top5=names(sort(table(marksInBounds()$srch_destination_name),decreasing = TRUE)[1:5])
    
    output$rank=renderText(
      paste0("NO.1 ",top5[1],"\n",
            "NO.2 ",top5[2],"\n",
            "NO.3 ",top5[3],"\n",
            "NO.4 ",top5[4],"\n",
            "NO.5 ",top5[5],"\n")
      )
    
  })
  observe({
    cities <- if (is.null(input$states)) character(0) else {
      data%>%
        filter(user_location_region %in% input$states)%>%
        `$`('user_location_city') %>%
        unique() %>%
        sort()
    }
    stillSelected <- isolate(input$cities[input$cities %in% cities])
    updateSelectInput(session, "cities", choices = cities,
                      selected = stillSelected)
  })  
    
    
  

})