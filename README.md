## Descriptive analysis and prediction of avocado prices in the United States (2015-2018)

Authors: Group 6 - Chuanjie Deng, Mingchen Ye, Nazleen Khan

### Data
- Avocado prices dataset: `avocado.csv` downloaded from https://www.kaggle.com/neuromusic/avocado-prices
- Food Environment Atlas datasets are in the `FoodAtlasData` folder, downloaded from https://www.ers.usda.gov/data-products/food-environment-atlas/data-access-and-documentation-downloads/
- City to county mapping data: `Cities-Counties-States.xlsx`

### RMarkdown and HTML files 
1. `DataWrangling.Rmd` and `DataWrangling.html` is for data wrangling process. 

We first cleaned the `avocado.csv` with unclear region descriptions and restricted the data only at city level. Since avocado prices data is mainly at city level and the Food Environment Atlas datasets are at county level, we created a new dataset `Cities-Counties-States.xlsx` mannualy for linking the cities to counties. After that, we merged prices data and food environment data together by the same county in the same state. Finally, a cleaned version of data is outputed as `avocado_clean.csv`.
