## Descriptive analysis and prediction of avocado prices in the United States (2015-2018)

Authors: Group 6 - Chuanjie Deng, Mingchen Ye, Nazleen Khan

Our website can be found [here]().

Our screencast can be found [here]().

### Goal of this project

1. To describe avocado prices and volumes across different counties of the US and the changes over time.
2. To predict avocado prices using predictors such as race percentage, income level, access and proximity to grocery store, and food purchasing assistance at the county level in California.


### Instructions
1. `Project.Rmd` and `Project.html` are our project files. It contains the full descriptions for this project and the codes for data wrangling and price prediciton.

In the data wrangling part,

we first cleaned the `avocado.csv` with unclear region descriptions and restricted the data only at city level. Since avocado prices data is mainly at city level and the Food Environment Atlas datasets are at county level, we created a new dataset `Cities-Counties-States.xlsx` mannually for linking the cities to counties. After that, we merged prices data and food environment data together by the same county in the same state. Finally, a cleaned version of data is outputed as `avocado_clean.csv`.

In the price pridiction part,

we used the `avocado_clean.csv` as input and conducted Random Forest algorithm to predict avocado prices in 2017 across the US counties. Model performance is evaluated by comparisons of mean squared error, Pearson correlation coefficients and the plots of observed price against predicted price in the training and testing datasets. The ten most important predictors were identified by the highest Gini scores.

Full details can be seen inside these documents.

2. `app.R` is our Shiny app.

The Shiny app includes the visualization of exploratory analyses, performance of the prediction model, information of important predictors, results of the prediction, and overall information of the project. Moreover, the app is made to be interactive so that the users can set the variables to the values they want and check the results that they are interested in. For example, users can input the values of the top 10 most important predictors (other predictors were set to median values in the code) and press the button "Predict Now", which outputs the predicted price for one avocado in the blue box.


### Data
- Avocado prices dataset: `avocado.csv` downloaded from [here](https://www.kaggle.com/neuromusic/avocado-prices)
- Food Environment Atlas datasets are in the `FoodAtlasData` folder, downloaded from [here](https://www.ers.usda.gov/data-products/food-environment-atlas/data-access-and-documentation-downloads/)
- City to county mapping data: `Cities-Counties-States.xlsx`
- `codebook.xlxs` is the code book for the predictors we used in the model.


