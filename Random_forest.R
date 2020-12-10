# ---
#   title: "Random forest"
# author: "Nazleen Khan"
# date: "12/7/2020"
# output: html_document
# ---
  
  ## Loading necessary packages
library(tidyverse)
library(gamlr)
library(Matrix)
library(lubridate)
library(randomForest)
library(MASS)
library(knitr)
library(caTools)

## Extending inference to whole United States in 2017

## Pulling in the wrangled data and creating the training and testing datasets
avocado_clean <- read.csv("avocado_clean.csv") # 10,140 observations of 306 variables
avocado_2017 <- avocado_clean %>%
  filter(year == 2017 & County != "roanoke" & County != "stlouis") %>% 
  dplyr::select(c("AveragePrice", "Total.Volume", "Total.Bags", "type",
                  "County", "Population_Estimate_2016", "PCT_LACCESS_POP15",
                  "GROCPTH16", "SUPERCPTH16", "CONVSPTH16", "SPECSPTH16",
                  "SNAPSPTH12", "WICSPTH16", "FFRPTH16", "FSRPTH16", 
                  "PC_FFRSALES12", "PC_FSRSALES12",
                  "SODATAX_STORES14", "SODATAX_VENDM14", "CHIPSTAX_STORES14",
                  "CHIPSTAX_VENDM14", "PCH_FDPIR_12_15", "FOOD_TAX14", "METRO13",
                  "DIRSALES_FARMS12", "VEG_FARMS12", "ORCHARD_FARMS12",
                  "BERRY_FARMS12", "SLHOUSE12", "GHVEG_FARMS12", "CSA12",
                  "AGRITRSM_OPS12","FARM_TO_SCHOOL15", "PCT_DIABETES_ADULTS13",
                  "RECFACPTH16", "PCT_NHWHITE10", "PCT_NHBLACK10", "PCT_HISP10",
                  "PCT_NHASIAN10", "PCT_NHNA10", "PCT_NHPI10", "PCT_65OLDER10",
                  "PCT_18YOUNGER10", "MEDHHINC15", "POVRATE15", "POPLOSS10"))
# Exclude Roanoke county and St. Louis because they have missing values across several important predictors
# Train and test prediction model using 2017 observations 
# 2,968 observations of 46 variables 
# Pre-selected variables without substantial missingness or correlation from subject matter knowledge
set.seed(610)
sample = sample.split(avocado_2017, SplitRatio = 0.70)
train = subset(avocado_2017, sample == TRUE)
test = subset(avocado_2017, sample == FALSE) 
# Randomly split 2017 data into 70:30 training and testing datasets

## Asessing missing data
## TRAINING DATASET 
sapply(train, function(x) sum(is.na(x))) # Number missing by column
sum(is.na(train)) 
# 0 missing observations in training dataset

## TESTING DATASET 
sum(is.na(test)) 
# 0 missing observations in testing dataset
xTest <- test %>% dplyr::select(-AveragePrice) 
# Retain all predictors and exclude outcome variable

## Running random forest in training dataset
set.seed(1500)  
train.model.us <- randomForest(AveragePrice ~ ., data = train, mtry = 15, nodesize = 100) 
# p/3 = 46 predictors/3 = 15 variables tried at each split
# mtry reduces correlation between trees and improves accuracy
# nodesize refers to the minimum number of observations at each split
train.model.us

## Evaluating random forest performance in training and testing datasets
pred.train = predict(train.model.us, newdata = train)
head(pred.train)
train %>% ggplot() +
  geom_point(aes(x = pred.train, y = AveragePrice), color = "green") +
  geom_abline(slope = 1, intercept = 0) + 
  scale_x_continuous(breaks = seq(0, 2.50, 0.25)) + 
  scale_y_continuous(breaks = seq(0, 3.25, 0.25)) + 
  xlab("Predicted avocado price in the US 2017 training data (US dollars)") + 
  ylab("Observed avocado price in the US 2017 training data (US dollars)") + 
  ggtitle("Observed versus predicted avocado prices in the US 2017 training data")
# Observed vs. predicted values in 2017 US training dataset 

mean((pred.train - train$AveragePrice)^2) 
# MSE = 0.066 in 2017 training dataset
cor.test(as.numeric(pred.train), train$AveragePrice, method = "pearson", conf.level = 0.95)
# Pearson correlation coefficient = 0.834

pred.test = predict(train.model.us, newdata = xTest)
head(pred.test)
xTest %>% ggplot() +
  geom_point(aes(x = pred.test, y = test$AveragePrice), color = "orange") +
  geom_abline(slope = 1, intercept = 0) + 
  scale_x_continuous(breaks = seq(0, 2.50, 0.25)) + 
  scale_y_continuous(breaks = seq(0, 3.25, 0.25)) + 
  xlab("Predicted avocado price in the US 2017 testing data (US dollars)") + 
  ylab("Observed avocado price in the US 2017 testing data (US dollars)") + 
  ggtitle("Observed versus predicted avocado prices in the US 2017 testing data")
# Observed vs. predicted values in 2017 testing dataset 

mean((pred.test - test$AveragePrice)^2) 
# MSE = 0.072 in 2017 testing dataset
cor.test(as.numeric(pred.test), test$AveragePrice, method = "pearson", conf.level = 0.95)
# Pearson correlation coefficient = 0.818

## Identifying important predictors
variable_importance <- importance(train.model.us) 
tmp <- tibble(feature = rownames(variable_importance),
              Gini = variable_importance[,1]) %>%
  arrange(desc(Gini))
kable(tmp[1:10,])

tmp %>% filter(Gini > 4.68) %>%
  ggplot(aes(x = reorder(feature, Gini), y = Gini)) +
  geom_bar(stat = 'identity') +
  coord_flip() + xlab("Predictor") +
  theme(axis.text = element_text(size = 8))

## Range of avocado price predictions in US in 2017 by county
avocado_2017_full <- avocado_clean %>%
  filter(year == 2017 & County != "roanoke" & County != "stlouis") %>% 
  dplyr::select(-"AveragePrice")
pred.2017 = predict(train.model.us, newdata = avocado_2017_full)
avocado_2017_full %>% ggplot(aes(x = factor(County), y = pred.2017)) + 
  scale_y_continuous(breaks = seq(0, 2.50, 0.25)) + 
  xlab("US county") + 
  ylab("Predicted avocado price (US dollars)") + 
  ggtitle("Distribution of predicted avocado price across US counties") + 
  geom_boxplot(fill = "lightblue", alpha = 0.8) + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1, size = 12),
        axis.title.y = element_text(size = 12), plot.title =  element_text(size = 12))