library(leaflet)


vars<-c("Region")
navbarPage("Travel With Expedia", id="nav",
           
           tabPanel("Interactive map",
                    div(class="outer",
                        
                        tags$head(
                          # Include our custom CSS
                          includeCSS("styles.css"),
                          includeScript("gomap.js")
                        ),
                        
                        leafletOutput("map", width="100%", height="100%"),
                        
                        
                        # Shiny versions prior to 0.11 should use class="modal" instead.
                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                      draggable = TRUE, top = 100, left = "20", right = "auto", bottom = "auto",
                                      width = 200, height = "auto",
                                      
                                      h2("Where do Americans want to go?"),
                                      h5("presented by Pinren Chen"),
                                      h5("data from Expedia"),
                                      
                                      selectInput("states", "States", c("All states"="", structure(state.abb, names=state.name), "Washington, DC"="DC"),multiple = TRUE),   #color and size here specifies input's id
                                      
                                      conditionalPanel("input.states",
                                                       selectInput("cities", "Cities",choices = c("All cities"=""), multiple=TRUE)),
                                                       
                                      selectInput("booking","Booking or just clicking?",c("booking"=1,"clicking"=0)),
                                      sliderInput("month",label="range of month",
                                                  min = 1, max = 12, value = c(1,12)),
                                  
                                      sliderInput("children","How many children",
                                                  min = 0, max = 9, value = c(0,9)),
                                      sliderInput("adults","How many adults",
                                                  min = 0, max = 9, value = c(0,9))
                                      
                                      
                                      ),
                        
                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                      draggable = TRUE, top = "auto", left = "auto", right = "20", bottom = 20,
                                      width = 300, height = "auto",
                                      
                                      h3("current rank"),
                                      verbatimTextOutput("rank")
                        )
                                     
                                      
                        ),
                        
                        tags$div(id="cite",
                                 'Data compiled for ', tags$em('Coming Apart: The State of White America, 1960-2010'), ' by Charles Murray (Crown Forum, 2012).'
                        )
                    )
           )
           
       
           
