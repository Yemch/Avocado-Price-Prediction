library(ggplot2)
library(dplyr)
library(viridis)
library(maps)
library(shiny)
library(shinydashboard)

avocado = read.csv("./avocado_clean.csv")
avocado$Date = as.Date(avocado$Date)
avocado$year = format(as.Date(avocado$Date, format="%d/%m/%Y"),"%Y")
avocado = avocado %>% filter(County != "roanoke") # This county is removed because there are different values of predictors in food atlas data
source("./Random_forest.R") # get our random forest prediction model
avocado$price_pred = predict(train.model.us, newdata = avocado) 
avocado_2017_full$pred.2017 = pred.2017 # add the predicted value to the dataset 

codebook = readxl::read_excel("codebook.xlsx")

top10_predictor = avocado[c("Total.Bags", "Total.Volume", 
                                 "type","PCT_NHASIAN10",
                                 "PCT_NHPI10","PC_FFRSALES12",
                                 "SPECSPTH16","GROCPTH16",
                                 "MEDHHINC15","PC_FSRSALES12")]

# Define UI for application that draws a histogram
ui <- dashboardPage(
    
    skin = "black",
    title = "Avocado Price Prediction",
    
    # HEADER ------------------------------------------------------------------
    
    dashboardHeader(
        title = "Avocado Price",
        dropdownMenu()  # dropdownMenu
        
        
        ), # dashboardHeader
    
    # Sidebar ------------------------------------------------------------------
    
    dashboardSidebar(
        sidebarMenu(
            menuItem("Basic", tabName = "basic", icon = icon("star")), # menuItem1
            menuItem("Model Performance", tabName = "predictors", icon = icon("bar-chart-o")),
            menuItem("Price Prediction", tabName = "prediction", icon = icon("dollar-sign")),
            menuItem("About", tabName = "about", icon = icon("address-card") )
            
        ) #sidebarMenu
    ), # dashboardSidebar
    
    # BODY ------------------------------------------------------------------
    
    dashboardBody(
        tabItems(
            # ----- The first page-------
            tabItem(tabName = "basic",
                    h2("Avocado Prices and Volumns by County Level"),
                    fluidRow(
                        box(title = "Choose a county",  status = "warning", solidHeader = F,
                            selectInput(inputId = "county", label = "County", choices = avocado$County,  selected = "los angeles"),   
                            uiOutput("select")
                            ), # box 
                        
                        box(title = "Choose price or volumn", status = "warning", solidHeader = F,
                            radioButtons(inputId = "pricevolumn", label = NULL, choices = c("Price"="AveragePrice","Volume"="Total.Volume")), 
                            selectInput(inputId = "date", label = "Date", choices = avocado$Date, selected = "2015-01-04")
                            ) # box
                        
                    ), # fluidRow
                    
                    fluidRow(
                        box(plotOutput(outputId = "line_org"),
                            plotOutput(outputId = "line_con")), # box
                        
                        box(plotOutput(outputId = "bar_org"),
                            plotOutput(outputId = "bar_con")
                            )
                        
                    ) # fluidRow
                    
                    ), # tabItem1
            
            
            
            # ----- The second page-------
            tabItem(tabName = "predictors",
                    h2("Model performance"),
                    
                    fluidRow(
                      box( title = "Model performance statistics", status = "warning", solidHeader = T, width = 6,
                      p("MSE in 2017 training dataset: 0.066"),
                      p("MSE in 2017 testing dataset: 0.072"),
                      p("Pearson correlation coefficient in 2017 training dataset: 0.834"),
                      p("Pearson correlation coefficient in 2017 testing dataset: 0.818")
                      ), # box
                      
                      box( title = "Top 10 important predictors identified by Random Forest", status = "warning", width = 6,
                           plotOutput("gini")
                      ) # box
                      
                    ), # fluidRow
                    
                    fluidRow(
                      box(width = 6, plotOutput("train")), # box
                      box(width = 6, plotOutput("test") )  # box
                    ), # fluidRow
                    
                    fluidRow(
                      box(title = "Distribution of the top 10 predictors",
                        selectInput("vars", "Select a predictor", choices = colnames(top10_predictor)),
                        br(),br(),br(),
                        tableOutput("description")
                        ), # box
                      
                      box(title = "Distribution of the predictor",
                          plotOutput("hist")
                          ) # box
                      
                    ) # fluidRow
                    
                    ), # tabItem2
            
            
            
            
            # ----- The third page-------
            tabItem(tabName = "prediction",
                    h2("Avocado Price Prediction"),
                    
                    fluidRow(
                        box(title = "Input the values of predictors:", status = "warning", solidHeader = T, width = 5,
                            selectInput("county2",         "County", choices = avocado$County,  selected = "los angeles"),
                            selectInput("type",            "Type of avocado, conventional or organic:", choices = avocado$type),
                            # The initial values are chosen as median
                            numericInput("totalbags",      "Total number of bags of avocados sold:", value = 21270),
                            numericInput("totalvolumn",    "Total number of avocados sold:", value = 61554),
                            numericInput("asian",          "% Asian in the county:", value = 4.330),
                            numericInput("Hawaiian",       "% Hawaiian or Pacific Islander:", value = 0.056),
                            numericInput("PC_FFRSALES12",  "Expenditures per capita, fast food, (dollar):",value = 610.0),
                            numericInput("SPECSPTH16",     "Specialized food stores/1,000 pop:",value = 0.0726),
                            numericInput("GROCPTH16",      "Grocery stores/1,000 pop:", value = 0.1905),
                            numericInput("MEDHHINC15",     "Median household income:", value = 56600),
                            numericInput("PC_FSRSALES12",  "Expenditures per capita, restaurants, (dollar):", value = 722.6)
                        ), # box 
                        

                        box(title = "Output", status = "warning", solidHeader = T,
                            actionButton("button", "Predict Now"),
                            br(), br(), br(), br(),
                            valueBoxOutput("predvalue", width = 6)
                            
                        ), # box 
                        
                        box(title = "Distribution of predicted avocado price", 
                            
                            textOutput("state"),
                            selectizeInput("county3","Select up to 6 counties:",
                                           choices = avocado_2017_full$County, options = list(maxItems = 6) ),
                            
                            
                            plotOutput("box")
                        )
                    ) # fluidRow
 
                    ), # tabItem3
            
            
            
            
            # ----- The fourth page-------
            tabItem(tabName = "about",
                    
                    h2("About"), 
                    h4("Authors: Group 6 - Chuanjie Deng, Mingchen Ye, Nazleen Khan"),
                    br(),
                    
                    h3("Background and Motivation"),
                    
                    p("The US demand for avocados has increased substantially since the 1980s (Carman HF, 2018). 
                      Over the past 40 years, per capita avocado consumption more than quadrupled from 1.7 pounds to 8.0 pounds in 2018, 
                      surpassing all other fresh fruit sales in the US over this period (Carman HF, 2018). 
                      The US primarily imports avocados from international suppliers to meet elevated demand, 
                      which has benefited domestic producers through more competitive pricing (US Department of Agriculture, 2020). 
                      However, it is unclear whether avocado prices are commensurate with area-level indicators of food environment and diet quality."),
                    
                    p("As a healthy superfood, avocados can be easily incorporated into several meals to meet requirements for daily intake of 
                    fiber, potassium, and monounsaturated fatty acids (Carman HF, 2018). If high demand for avocados leads to more competitive pricing, 
                    individuals in certain areas may not be able to incorporate avocados into their diets. 
                    We propose a US county-level descriptive analysis of avocado prices in comparison with food environment characteristics, 
                    such as median household income, proximity to grocery store, and grocery store availability. 
                    We also use these and related variables to predict avocado prices in California, 
                    a large US state with a diverse range of food environments. Our goal is to use this algorithm to predict avocado prices in other regions of the US to 
                    (1) provide context for area-specific food choices and (2) offer information on locations where avocados may be more reasonably priced."),
                    
                    br(),
                    
                    h3("Data Source"),
                    
                    p("The avocado volumes and prices data are collected from Kaggle, 
                    which is compiled from the Hass Avocado Board website and includes these variables across various metropolitan areas of the US. 
                    We can download the data in .csv format directly. 
                    We combine a Food Environment Atlas dataset that includes up to 280 variables related to the food environment and socioeconomic characteristics of all US counties, 
                    which comes from the US Department of Agriculture website. 
                    The data can be downloaded in .xls format. The following links are the sources of data:"),
                    p("https://www.kaggle.com/neuromusic/avocado-prices"),
                    p("https://www.ers.usda.gov/data-products/food-environment-atlas/data-access-and-documentation-downloads/"),

                    br(),
                    
                    h3("References"),
                   
                    p("Carman HF. (2018). The story behind avocados’ rise to prominence in the United States. 
                      Giannini Foundation of Agricultural Economics, University of California. 
                      Accessed 11/01/2020 at https://s.giannini.ucop.edu/uploads/giannini_public/5c/1f/5c1fa9d0-c5c9-45ce-8606-149ddf4f7397/v22n5_3.pdf."),
                    p("US Department of Agriculture. (2020). US avocado demand is climbing steadily. 
                      Accessed 11/01/2020 at https://www.ers.usda.gov/data-products/chart-gallery/gallery/chart-detail/?chartId=98071.")
                    
                    ) # tabItem4
            
        ) # tabItems

    ) # dashboardBody
    
) # dashboardPage Close


# --- server ---- 

server <- function(input, output) {
    
    ### Tab 1 - basic statistics descriptions
    # reactive
    plot_y <- reactive({
        if(input$pricevolumn=="AveragePrice"){ plot_y="Avocado Price (Dollar)"}
        else{plot_y="Total Volume of Avocado"}
    })
    
    title = reactive({
        if(input$pricevolumn=="AveragePrice"){title ="The Average Price of a Single Avocado"}
        else{title ="Total Number of Avocados Sold"}
    })
    
    ylimit_org = reactive({
        if(input$pricevolumn=="AveragePrice"){ylimit_org = 3.25}
        else{ylimit_org = 230000 }
    })
    
    ylimit_con = reactive({
        if(input$pricevolumn=="AveragePrice"){ylimit_con = 3.25}
        else{ylimit_con = 5500000}
    })
    
    ##price/volume over time group by county  (line plot)
    output$line_org <- renderPlot({
        
    avocado %>% filter( County %in% input$county & type == "organic") %>%  
        ggplot() +
        geom_line(aes_string(x="Date", y=input$pricevolumn, group="County"), color = "darkolivegreen4")+
        ylim(0,ylimit_org()) +
        theme_light() +
        scale_x_date(date_breaks = "3 month", date_labels = "%Y (%b)") +
        theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
        labs(title = paste(title(),"(Organic) Over Time"), y=plot_y())
    }) 
    
    output$line_con <- renderPlot({
        
        avocado %>% filter( County %in% input$county & type == "conventional") %>%  
            ggplot() +
            geom_line(aes_string(x="Date", y=input$pricevolumn, group="County"), color = "darkolivegreen4")+ 
            ylim(0,ylimit_con()) +
            theme_light() +
            scale_x_date(date_breaks = "3 month", date_labels = "%Y (%b)") +
            theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
            labs(title = paste(title(),"(Conventional) Over Time"), y=plot_y())
    }) 
  
    #volume/price in different counties at a certain time point (barplot)
    output$bar_org <- renderPlot({
    
    avocado = avocado %>% filter(Date %in% as.Date(input$date)) %>% filter(type == "organic")
    avocado$County = reorder(avocado$County, avocado[,input$pricevolumn]) 
    
    avocado %>%
        ggplot(aes_string(x= "County", y=input$pricevolumn, fill = input$pricevolumn) )+
        geom_bar(stat="identity") +
        coord_flip()+
        ylim(0,ylimit_org()) +
        scale_fill_gradient(low = "lightgoldenrod", high = "darkolivegreen3") + 
        theme(legend.position = "none", panel.background = element_blank(), axis.line = element_line()) +
        labs(title=paste(title(),"(Organic) on", input$date), y=plot_y())
    }) # renderPlot
    
    output$bar_con <- renderPlot({
        
        avocado = avocado %>% filter(Date %in% as.Date(input$date)) %>% filter(type == "conventional")
        avocado$County = reorder(avocado$County, avocado[,input$pricevolumn]) 
        
        avocado %>%
            ggplot(aes_string(x= "County", y=input$pricevolumn, fill = input$pricevolumn) )+
            geom_bar(stat="identity") +
            coord_flip() +
            ylim(0,ylimit_con()) +
            scale_fill_gradient(low = "lightgoldenrod", high = "darkolivegreen3") + 
            theme(legend.position = "none", panel.background = element_blank(), axis.line = element_line()) +
            labs(title=paste(title(),"(Conventional) on", input$date), y=plot_y())
    })
    
    ### Tab 2 - predictors characteristics
    
    output$gini = renderPlot({
      tmp %>% filter(Gini > 4.68) %>%
        ggplot(aes(x = reorder(feature, Gini), y = Gini, fill=Gini)) +
        geom_bar(stat = 'identity') +
        coord_flip() + 
        xlab("") +
        theme(legend.position = "none") +
        scale_fill_gradient(low = "lightgoldenrod", high = "darkolivegreen3") +
        labs(title = "10 Predictors with the highest Gini scores ") +
        scale_x_discrete(labels = c("Predictor", "Total.Bags" = "Total Bags",
                                           "Total.Volume" = "Total Volume", 
                                           "type" = "Type",
                                           "PCT_NHASIAN10" = "%Asian(2010)",
                                           "PCT_NHPI10" = "%Hawaiian/Pacific Islander(2010)",
                                           "PC_FFRSALES12"="Fast Food Expenditures per capita(2012)",
                                           "SPECSPTH16"="Specialized Food Stores/1,000 pop(2016)",
                                           "GROCPTH16"="Grocery Stores/1,000 pop(2016)",
                                           "MEDHHINC15"="Median Household Income(2015)",
                                            "PC_FSRSALES12"="restaurants Expenditures per capita(2012)"))+
        theme_light()
    })
      
    output$train = renderPlot({
      train %>% ggplot() +
        geom_point(aes(x = pred.train, y = AveragePrice), color = "darkolivegreen3") +
        geom_abline(slope = 1, intercept = 0, linetype = "dashed") + 
        scale_x_continuous(breaks = seq(0, 2.50, 0.25)) + 
        scale_y_continuous(breaks = seq(0, 3.25, 0.25)) + 
        xlab("Predicted Avocado Price($)") + 
        ylab("Observed Avocado Price($)") + 
        ggtitle("Observed Versus Predicted Avocado Prices in the US 2017 Training Data")
    })
    
    output$test = renderPlot({
      xTest %>% ggplot() +
        geom_point(aes(x = pred.test, y = test$AveragePrice), color = "goldenrod1") +
        geom_abline(slope = 1, intercept = 0, linetype = "dashed") + 
        scale_x_continuous(breaks = seq(0, 2.50, 0.25)) + 
        scale_y_continuous(breaks = seq(0, 3.25, 0.25)) + 
        xlab("Predicted Avocado Price($)") + 
        ylab("Observed Avocado Price($)") + 
        ggtitle("Observed Versus Predicted Avocado Prices in the US 2017 Testing Data")
    })
    
    output$description = renderTable({
      codebook %>% filter(Variable %in% input$vars)
    })
    

    output$hist = renderPlot({
      top10_predictor %>%
        ggplot(aes_string(x=input$vars)) + 
        geom_density(color="darkolivegreen3", fill="lightgoldenrod")+
        xlab("")+
        ggtitle(paste("The Density Plot of", input$vars))
    })
    
    ### Tab 3 - Prediction using users input values
    
    # Make a dataframe for users input 

    users.input = eventReactive(
        input$button, { data.frame(
                             type = input$type,
                             Total.Bags = input$totalbags,        Total.Volume =  input$totalvolumn,
                             PCT_NHASIAN10 = input$asian,         PCT_NHPI10 =    input$Hawaiian,
                             PC_FFRSALES12 = input$PC_FFRSALES12, County =        input$county2,
                             SPECSPTH16 = input$SPECSPTH16,       GROCPTH16 =     input$GROCPTH16,
                             MEDHHINC15 = input$MEDHHINC15,       PC_FSRSALES12 = input$PC_FSRSALES12,

                             Population_Estimate_2016 = 1625744,  PCT_LACCESS_POP15 = 17.6311, SUPERCPTH16 = 0.0165,
                             CONVSPTH16 = 0.3583,                 SNAPSPTH12 = 0.7144,         WICSPTH16 = 0.1076,     FFRPTH16 = 0.8482,
                             FSRPTH16 = 0.7814,                   SODATAX_STORES14 = 6.00,     SODATAX_VENDM14 = 6,    CHIPSTAX_STORES14 = 0,
                             CHIPSTAX_VENDM14 = 5.150,            PCH_FDPIR_12_15 = 0,         FOOD_TAX14 = 0.5,       METRO13 = 1,
                             DIRSALES_FARMS12 = 55,               VEG_FARMS12 = 28,            ORCHARD_FARMS12 = 23,   BERRY_FARMS12 = 12,
                             SLHOUSE12 = 2,                       GHVEG_FARMS12 = 6,           CSA12= 7,               AGRITRSM_OPS12 = 10,
                             AGRITRSM_OPS12 = 1,                  PCT_DIABETES_ADULTS13 = 9.15,RECFACPTH16 = 0.1169,   PCT_NHWHITE10 = 55.15,
                             PCT_NHBLACK10 = 14.319,              PCT_HISP10 = 9.725,          PCT_NHNA10 = 0.2303,    PCT_65OLDER10 = 11.155,
                             PCT_18YOUNGER10 = 23.47,             POVRATE15 = 15.7,            POPLOSS10 = 0,          FARM_TO_SCHOOL15 = 1
                             
                             ) }) # eventReactive
    
    output$predvalue = renderValueBox({ valueBox(subtitle = "dollar for one avocado", icon = icon("dollar-sign"),
                                                 value = round(  predict(train.model.us, newdata = users.input())[[1]] , 4 ) ) # valueBox 
      }) # renderValueBox
    
    output$state = renderText({
      avo_state = avocado %>% filter(County %in% input$county3)
      return(unique(avo_state$State) )
    })
    
    output$box = renderPlot({
      avocado_2017_full %>% 
        filter(County %in% input$county3) %>%
        ggplot(aes(x = factor(County), y = pred.2017)) + 
        scale_y_continuous(breaks = seq(0, 2.50, 0.25)) + 
        xlab("US county") + 
        ylab("Predicted avocado price (US dollars)") + 
        ggtitle("Distribution of predicted avocado price across US counties") + 
        geom_boxplot(fill = "lightblue", alpha = 0.8) + 
        theme(axis.text.x = element_text(angle = 90, hjust = 1, size = 12),
              axis.title.y = element_text(size = 12), plot.title =  element_text(size = 12))
    })
    
} # server

# Run the application 
shinyApp(ui = ui, server = server)
