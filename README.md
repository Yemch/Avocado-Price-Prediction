## Descriptive Analysis (2015-2018) and Prediction of Avocado Prices in the United States in 2017

Authors: Group 6 - Mingchen Ye, Monica Deng, Nazleen Khan

Our website can be found [here](https://sites.google.com/view/avocadopriceprediction/home).

Our screencast can be found [here](https://youtu.be/6C_0NpOehkU).

### Goals of this project

1. To describe avocado prices and volumes across 29 different counties of the US and the changes in these variables over time from 2015 to 2018.
2. To predict county-level avocado prices using variables such as race percentage, median household income, access and proximity to the grocery store, and food purchasing assistance in 2017.

### Instructions
1. `Project.Rmd` and `Project.html` are our project files. They contain the full descriptions for this project and codes for data wrangling and price prediction. **In the data wrangling section**, we first cleaned the `avocado.csv` with unclear region descriptions and restricted the data to the city level. Since the avocado price data was mainly at the city level and the Food Environment Atlas was at the county level, we created a new dataset `Cities-Counties-States.xlsx` manually for linking the cities to counties. After that, we merged avocado price and food environment data together by county. Finally, a cleaned version of the data was output as `avocado_clean.csv`. **In the price prediction section**, we used the `avocado_clean.csv` to randomly split the data in a 70:30 ratio to training and test datasets and conduct the Random Forest algorithm to predict avocado prices across 28 US counties. We restricted to 2017 data to (1) predict avocado prices for a single year since we were not able to adequately capture yearly variation in avocado prices and (2) maintain temporality between predictor variables and the outcome of interest. We also pre-selected 45 potential predictors based on subject matter knowledge for variable importance, expected low correlation, and little missing data. We excluded Roanoke and St. Louis counties due to substantial missingness across several of the remaining predictor variables. Model performance was quantified with mean squared error (MSE), Pearson correlation coefficients, and plots of observed against predicted avocado price in the training and testing datasets. The ten most important predictors were identified by the highest Gini scores. Full details can be seen inside these documents.

2. `app.R` is our Shiny app. The Shiny app includes the visualization of exploratory analyses, performance of the prediction model, information on important predictors, results of the prediction, and overall information on the project. The app is made to be interactive so that the users can set the variables to the values they want and output the results of interest. For example, users can input values for the top 10 most important predictors (other predictors were set to median values in the code) and press the button "Predict Now", which outputs the predicted price for one avocado in the blue box.


### Data
- `avocado.csv` is the avocado prices dataset, downloaded from [here](https://www.kaggle.com/neuromusic/avocado-prices)
- `FoodAtlasData` folder contains Food Environment Atlas datasets, downloaded from [here](https://www.ers.usda.gov/data-products/food-environment-atlas/data-access-and-documentation-downloads/)
- `avocado_clean.csv` is the cleaned and county-level merged version of the avocado prices dataset.
- `Cities-Counties-States.xlsx` is the city to county mapping data.
- `codebook.xlsx` is the code book for the predictors we used in the model.
- `Random_Forest.R` is the R file version of the Random Forest procedure in the `Project.Rmd`. It is made to get the prediction model used in the Shiny app.

