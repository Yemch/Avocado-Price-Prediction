# Descriptive analysis and prediction of avocado prices in the United States (2015-2018)

Authors: Group 6 - Chuanjie Deng, Mingchen Ye, Nazleen Khan

### Background and Motivation 

The US demand for avocados has increased substantially since the 1980s (Carman HF, 2018). Over the past 40 years, per capita avocado consumption more than quadrupled from 1.7 pounds to 8.0 pounds in 2018, surpassing all other fresh fruit sales in the US over this period (Carman HF, 2018). The US primarily imports avocados from international suppliers to meet elevated demand, which has benefited domestic producers through more competitive pricing (US Department of Agriculture, 2020). However, it is unclear whether avocado prices are commensurate with area-level indicators of food environment and diet quality.   

As a healthy superfood, avocados can be easily incorporated into several meals to meet requirements for daily intake of fiber, potassium, and monounsaturated fatty acids (Carman HF, 2018). If high demand for avocados leads to more competitive pricing, individuals in certain areas may not be able to incorporate avocados into their diets. We propose a US county-level descriptive analysis of avocado prices in comparison with food environment characteristics, such as median household income, proximity to grocery store, and grocery store availability. We will also use these and related variables to predict avocado prices in California, a large US state with a diverse range of food environments. Our goal is to use this algorithm to predict avocado prices in other regions of the US to (1) provide context for area-specific food choices and (2) offer information on locations where avocados may be more reasonably priced.


## Project Objectives 

- To describe avocado prices and volumes across different metropolitan areas of the US.
- To explore the relationships between avocado prices and factors such as income level, access and proximity to grocery store, and food purchasing assistance using county-level data.
- To predict avocado prices at the county level in California and, if possible, across different regions of the US.
 
## What Data? 

The avocado volumes and prices data are collected from two sources. The first one is found on Kaggle, which is compiled from the Hass Avocado Board website and includes these variables across various metropolitan areas of the US. We can download the data in .csv format directly. Another dataset is from the California Avocado Commission, which will be scraped from their website. We will combine a Food Environment Atlas dataset that includes up to 280 variables related to the food environment and socioeconomic characteristics of all US counties, which comes from the US Department of Agriculture website. The data can be downloaded in .xls format. The following links are the sources of data:
- https://www.kaggle.com/neuromusic/avocado-prices
- https://www.californiaavocadogrowers.com/industry/industry-statistical-data
- https://www.ers.usda.gov/data-products/food-environment-atlas/data-access-and-documentation-downloads/

## Design Overview 

1. Collect the avocado data in California from the California Avocado Commission website by web scraping.
2. Download avocado price data for various US metropolitan areas from Kaggle.
3. Clean and merge the datasets by data wrangling.
4. Conduct descriptive analyses for avocado prices, volumes, and median household income from 2015-2018 across US metropolitan areas using data visualization.
5. Predict avocado prices in specific regions (i.e., California and potentially across different US regions) with county-level data on food environments using prediction models. 
6. Display the results by Shiny app.

## References

Carman HF. (2018). The story behind avocados’ rise to prominence in the United States. Giannini Foundation of Agricultural Economics, University of California. Accessed 11/01/2020 at https://s.giannini.ucop.edu/uploads/giannini_public/5c/1f/5c1fa9d0-c5c9-45ce-8606-149ddf4f7397/v22n5_3.pdf.

US Department of Agriculture. (2020). US avocado demand is climbing steadily. Accessed 11/01/2020 at https://www.ers.usda.gov/data-products/chart-gallery/gallery/chart-detail/?chartId=98071.

