# Main ----
# Research the Data & Problem ----
# Set WD ----
setwd("C://Users//wongs//Desktop//cu-coding//project-in_class.re")# Load Libraries ----
source('functions/libraries.r')
libraries()
# Import the Data
data <- read_excel("data/FinalData.xlsx")
# Inspect the Data ----
str(data)
# Subset Ignoble Variables ----
sub = data[, !colnames(data) %in% c('...1','doc.id','location','population','text')]
str(sub)
# Exploration of the Original ----
source("scripts/explore_O.r")
# - Preprocess the Data ----
source('functions/prepdata.r.r')
preprocess(sub,'infectioncount')
# Exploration of the Prep ----
source("scripts/explore_P.r")
# Modeling ----
source("scripts/modeling.r")