# - Main Script ----

# - [1] - Setting Working Directory ----
setwd("C:\\Users\\wongs\\Desktop\\cu-coding//project1.cl")

# - [2] - Load the Libraries ----
source("functions/libs.r")
libraries()

# - [3] - Import the Data ----
print("Importing the Data...")
source("scripts/import_data.R")

# - [4] - Explore the Original ----
source("scripts/explore_O.r")

# - [5] - Preprocess the Data ----
source("scripts/prep.r")

# - [6] - Explore the Prep ----
source("scripts/explore_P.r")

# - [7] - Classification Modeling ----
source("modeling/modeling.R")