# Title: Simulating Data for Testing Different Methods for RWE project using EHR data 

# Goal is to try and simulate data that could potentially be provided from 
# EHR data. Additionally, using this data to emulate how the effect estimate 
# will differ based upon different stats methods (i.e., logistic regression, 
# marginal structural models, parametric gformula, etc.)

# Simulating Data ----

#... Setup ----

library(simstudy)
library(tidyverse)
library(WeightIt)
library(ipw)

#... Formulas for Variables ----

set.seed(123)

# First creating the cross-sectional data 

# Demographic Variables 

def <- simstudy::defData(varname = "age", dist = "normal", formula = 18, variance = 20)
def <- simstudy::defData(def, varname = "sex", dist = "binary", formula = 0.5)
def <- simstudy::defData(def, varname = "marital_status", dist = "categorical", formula = 0.5)
def <- simstudy::defData(def, varname = "")

# Comorbidities 

def <- simstudy::defData(def, varname = "diabetes", dist = "binary", formula = 0.5)
def <- simstudy::defData(def, varname = "hypertension", dist = "binary", formula = 0.5)
def <- simstudy::defData(def, varname = "stroke", dist = "binary", formula = 0.5)
def <- simstudy::defData(def, varname = "coronary_heart_disease", dist = "binary", formula = 0.5)
def <- simstudy::defData(def, varname = "cognition_medicines", dist = "binary", formula = 0.5)
def <- simstudy::defData(def, varname = "insomnia", dist = "binary", formula = 0.5)

# Variables needed later for making data longitudinal 

# nCount defines the number of measurements for an individual
# mInterval specifies the average time between intervals for a subject
# vInterval specifies the variance of those interval times 

def <- simstudy::defData(def, varname = "nCount", dist = "noZeroPoisson", formula = 6)
def <- simstudy::defData(def, varname = "mInterval", dist = "gamma", formula = 30, variance = 0.01)
def <- simstudy::defData(def, varname = "vInterval", dist = "nonrandom", formula = 0.07)

#... Generating Data ----

dt <- simstudy::genData(200, def) 

#... Making Longitudinal ----

df <- simstudy::addPeriods(dt)

#... Adding Treatments ----

trt.formula <- c("-2 + 2*sex + .5*age", "-1 + 2*sex + .5*age", "1 - 2*sex + 3*age")

dd <- simstudy::trtObserve(
  df, 
  formulas = trt.formula, 
  logit.link = TRUE,
  grpName = "rx"
)



# Weighting ----

?weightit


?ipw::ipwtm() # can be used to calculate weights for censoring


# Miscellaneous Data Simulating Code ----

#... Adding Columns ----

# Formula for column/variable to be added 

d.income <- simstudy::defData(varname = "income", dist = "categorical", formula = "0.15;0.15;0.20;0.20;0.15;0.15")

# Adding column to dataset

dt <- simstudy::addColumns(dtDefs = d.income, dtOld = dt)

#... Assigning treatment ----

dd <- trtAssign(
  df, 
  formulas = trt.formula,
  nTrt = 2, 
  balanced = FALSE,
  grpName = "rx"
)




