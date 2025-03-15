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
