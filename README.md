# Fall24-STAT628-Module2-Group5: Body Fat Prediction Project

## Authors 
- Chenghao Lou 
- RuiYuan Ming 
- Minliang Yu 
- Shixin Zhang

(in alphabetical order) 


## Overview
This project aims to build a simple, robust, and accurate model using various physical measurements to predict body fat percentages. Estimating body fat predictions can give valuable insight into a person’s fitness level and health risks. We aim to use statistical methods to build a model that predicts body fat while ensuring that the data used is clean and abnormalities-free. 


## Repository Structure
- `data/`: Contains the raw and cleaned datasets used in the analysis.
- `code/`: Includes all R scripts used for data cleaning, analysis, and model building.
- `images/`: Stores plots and visualizations generated during the analysis.
- `shiny_app/`: The code and resources for the Shiny app, allowing real-time body fat predictions.
  
## Files
- **data_cleaning.R**: Code for cleaning the dataset, particularly correcting abnormalities in the `bodyfat` and `height` columns.
- **model_building.R**: Code for model selection, statistical analysis, and cross-validation.
- **app.R**: Shiny app code for interactive body fat prediction based on the final model.

## Statistical Analysis
The goal of this analysis was to identify the most relevant predictor variables for estimating body fat percentage. After data preprocessing, we employed an all-subset regression approach to evaluate all possible predictor combinations, with a focus on balancing the trade-off between simplicity (fewer predictors) and accuracy (higher Adjusted R-squared).
The final model selected was the two-variable model:  
`BODYFAT ~ WEIGHT + ABDOMEN`  
This model was chosen due to its optimal balance of accuracy, robustness, and simplicity.

## Shiny App
The repository includes a Shiny web app that allows users to input their abdomen and weight measurements and receive real-time predictions of their body fat percentage. The app uses the final selected model (`BODYFAT ~ WEIGHT + ABDOMEN`) for predictions. The app also allows users to choose their age group to see what category their body fat percentage fall into as adult men. The Shiny app is also deployed to an online platform and can be accessed here:
https://628nodie.shinyapps.io/Bodayfat/



## How to Run
1. Clone the repository:
   ```bash
   git clone https://github.com/2023-06-17/628-Module2
2. Install necessary R packages: Install the required R libraries by running the following in R:
   ```bash
   install.packages(c("shiny", "ggplot2", "dplyr"))
3. Open the shiny_app/app.R file and run it in your RStudio environment.

## Contact
If you have any questions or issues regarding the analysis or the app, feel free to contact us:

  Email: clou25@wisc.edu, rming@wisc.edu, myu259@wisc.edu, szhang655@wisc.edu

 
**Special Thanks to Professor Kang**

