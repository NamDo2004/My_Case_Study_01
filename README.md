# Divvy Bike Trip Data Analysis

This project analyzes bike-sharing trip data from Divvy (Chicago) to uncover usage patterns. Using R, it explores key questions:

- On which day do people ride bikes the most?
- At what hour do people ride bikes the most?
- What similarities do member and casual riders share?

## Dataset
The analysis uses 12 months of Divvy trip data (January 2023 – December 2023), sourced from Divvy Bikes. Each CSV file contains trip details like start/end times, stations, and rider types.

## Project Overview
1. **Data Collection**: Loaded 12 monthly CSV files into R.
2. **Data Wrangling**: Combined files into a single dataset, removed irrelevant columns (e.g., latitude/longitude), and cleaned inconsistencies (e.g., missing station names, negative ride lengths).
3. **Data Preparation**: Added columns for date, day of week, hour, and ride length (in seconds) for analysis.
4. **Descriptive Analysis**: Calculated ride statistics (mean, median, max, min) and compared member vs. casual riders by day, hour, and month.
5. **Visualization**: Created plots to show:
- Number of rides by rider type and weekday.
- Number of rides by hour.
- Monthly ride trends.
6. **Output**: Exported a summary CSV of average ride lengths by rider type and weekday.

## Repository Structure
- **data/:** Contains the 12 CSV files (e.g., 202301-divvy-tripdata.csv).
- **scripts/:** Contains the R script (bike_analysis.R) with all code.
- **output/:** Contains the exported CSV (avg_ride_length.csv).
- **visualizations/:** Contains generated plots (if saved separately).

##Tools Used
- **R**: Core analysis and visualization.
- **Libraries:** tidyverse, dplyr, scales, conflicted for data manipulation and plotting.

## Key Findings
- Identified peak riding days and hours.
- Compared ride duration and frequency between member and casual riders.
- Visualized seasonal trends in bike usage.

## How to Run
1. Clone this repository.
2. Install R and required libraries:
- ```install.packages(c("tidyverse", "dplyr", "scales", "conflicted"))```
3. Place the Divvy CSV files in the data/ folder.
4. Run the R script (scripts/bike_analysis.R) in RStudio or an R environment.
5. Check the output/ folder for the summary CSV and visualizations/ for plots (if saved).
## Next Steps
- Add statistical tests to validate findings.
- Explore station-level patterns.
- Integrate additional years for trend analysis.
