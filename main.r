# Main ----
# Research the Data & Problem (Regression) ----

# Set WD ----
setwd("C:/Users/wongs/Desktop/crypto-energy-final-project")

# Load Libraries ----
source("R functions/libraries.r")
libraries()

# Import the Data
# -- Crypto API
source('scripts/crypto_scraping.py')
source('scripts/import_data.r')
source('scripts/data.r')

# Exploration of the Original ----
source("scripts/explore_O.r")

# - Preprocess the Data ----
source('scripts/preprocess.r')

# Exploration of the Prep ----
source("scripts/explore_P.r")

# Classification Modeling ----
source('modeling/modeling.r')
