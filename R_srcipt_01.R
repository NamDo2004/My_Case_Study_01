#In order conduct an efficient analysis, I want to answer the following questions:
#On which day do people ride bikes most? X
#At what hour do people ride the bikes most? X
#What similarities do member and casual riders share?



#Load the neccessary library
library(tidyverse)
library(dplyr)
library(scales)

#Use conflited package to manage conflicts
library(conflicted)


#STEP 1: Collect the data
#I use read.csv to read Divvy files about trip data
Jan_2023 <- read.csv("202301-divvy-tripdata.csv")
Feb_2023 <- read.csv("202302-divvy-tripdata.csv")
Mar_2023 <- read.csv("202303-divvy-tripdata.csv")
Apr_2023 <- read.csv("202304-divvy-tripdata.csv")
May_2023 <- read.csv("202305-divvy-tripdata.csv")
Jun_2023 <- read.csv("202306-divvy-tripdata.csv")
Jul_2023 <- read.csv("202307-divvy-tripdata.csv")
Aug_2023 <- read.csv("202308-divvy-tripdata.csv")
Sep_2023 <- read.csv("202309-divvy-tripdata.csv")
Oct_2023 <- read.csv("202310-divvy-tripdata.csv")
Nov_2023 <- read.csv("202311-divvy-tripdata.csv")
Dec_2023 <- read.csv("202312-divvy-tripdata.csv")

#STEP 2: Wrangle data and combine into a single file
#Compare column names in each file
colnames(Jan_2023)
colnames(Feb_2023)

colnames(Mar_2023)
colnames(Apr_2023)

colnames(May_2023)
colnames(Jun_2023)

colnames(Jul_2023)
colnames(Aug_2023)

colnames(Sep_2023)
colnames(Oct_2023)

colnames(Nov_2023)
colnames(Dec_2023)

#Since the column names in all data frames i've stacked are the same,there's no need to rename them
#Inspect the data frame and look for incongruencies
str(Jan_2023)
str(Feb_2023)
str(Mar_2023)
str(Apr_2023)
str(May_2023)
str(Jun_2023)
str(Jul_2023)
str(Aug_2023)
str(Sep_2023)
str(Oct_2023)
str(Nov_2023)
str(Dec_2023)

#Stack individual data frames into one big data frame
all_trips <- bind_rows(Jan_2023, Feb_2023, Mar_2023, Apr_2023, May_2023, Jun_2023, Jul_2023, Aug_2023, Sep_2023, Oct_2023, Nov_2023, Dec_2023)

#Remove start_lat, end_lat, start_lng, end_lng as this fields were dropped beginning in 2020
all_trips <- all_trips %>%
  select(-c(start_lat, end_lat, start_lng, end_lng))

#STEP 3: Clean the data and prepare for analysis
#Inspect the new table that has been created
colnames(all_trips) #List all column names
nrow(all_trips) #Count all rows in the table
dim(all_trips) #Dimensions of the data frame
head(all_trips) #See the first 6 rows of the data frame
str(all_trips) #See list of column and data type of the data frame
summary(all_trips) #Statistical summary of data

table(all_trips$member_casual)

#Extract the date, time from start_at column
all_trips$date <- as.Date(all_trips$started_at)
all_trips$month <- format(as.Date(all_trips$started_at), "%m")
all_trips$day <- format(as.Date(all_trips$started_at), "%d")
all_trips$year <- format(as.Date(all_trips$started_at), "%Y")
all_trips$day_of_week <- format(as.Date(all_trips$started_at), "%A")

#Add ride_length column in seconds
all_trips$ride_length <- difftime(all_trips$ended_at, all_trips$started_at)

#Convert ride length column frome Factor to numeric values for calculation
is.factor(all_trips$ride_length)
all_trips$ride_length <- as.numeric(as.character(all_trips$ride_length))
is.numeric(all_trips$ride_length)


#Remove bad data
#Remove typo column name
all_trips_v1 <- subset(all_trips, select = -c(ride_lenth))
#Check the start station name if it has abbreviation name
abbr_start_station_name <- all_trips_v1[grep("^.{1,3}$", all_trips_v1$start_station_name), "start_station_name"]
print(abbr_start_station_name)
empty_start_station_name <- dplyr::filter(all_trips_v1, start_station_name == "")

#Check the end station name if it has abbreviation name
abbr_end_station_name <- all_trips_v1[grep("^.{1,3}$", all_trips_v1$end_station_name), "end_station_name"]
print(abbr_end_station_name)
empty_end_station_name <- dplyr::filter(all_trips_v1, end_station_name == "")

#Check any rows have ride_length <= 0
ride_length_lessOrEqual_0 <- dplyr::filter(all_trips_v1, ride_length == 0)

#Clean any rows that don't have start/end station name or name 410 or ride_length <= 0
all_trips_v2 <- all_trips_v1[!(all_trips_v1$start_station_name == "" | all_trips_v1$end_station_name =="" | all_trips_v1$start_station_name == 410 | all_trips_v1$end_station_name == 410 |all_trips_v1$ride_length <= 0),]

#Step 4: CONDUCT DESCRIPTIVE ANALYSIS
#Descriptive analysis on ride_length
mean(all_trips_v2$ride_length) #Average ride_length
median(all_trips_v2$ride_length) #Mid point number in ascending array of ride_length
max(all_trips_v2$ride_length) #Max ride_length
min(all_trips_v2$ride_length) #Min ride_length

summary(all_trips_v2)
#Compare members and causual riders
aggregate(all_trips_v2, all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = mean)
aggregate(all_trips_v2, all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = median)
aggregate(all_trips_v2, all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = max)
aggregate(all_trips_v2, all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = min)

#Average ride time by each day for each type of member
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = mean)
#Days of week are out of order so I'll fix it
all_trips_v2$day_of_week <- ordered(all_trips_v2$day_of_week, levels=c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))

#Analyze ridership by type of weekday
all_trips_v2 %>%
  mutate(weekday = wday(started_at, label = TRUE)) %>% #Create weekday field using wday()
  group_by(member_casual, weekday) %>% #Group by user type and weekday
  summarise(number_of_rides = n(), average_duration = mean(ride_length)) %>% #Calculate number of rides and average duration
  arrange(member_casual, weekday) #Sort

#Visualize number of riders by rider type
all_trips_v2 %>%
  mutate(weekday = wday(started_at, label = TRUE)) %>%
  group_by(member_casual, weekday) %>%
  summarise(number_of_rides = n(), average_duration = mean(ride_length)) %>%
  arrange(member_casual, weekday) %>%
  ggplot(aes(x = weekday, y = number_of_rides, fill = member_casual)) + geom_col(position = "dodge")

#Add hour column to all_trips_v2 data frame
all_trips_v2$hour <- hour(ymd_hms(all_trips_v2$started_at))

#Visualize number of riders by hour
all_trips_v2 %>%
  group_by(member_casual, hour) %>%
  summarise(number_of_rides = n()) %>%
  ggplot(aes(x = hour, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge")

#Visualize the change in number of riders throughout each month
all_trips_v2 %>%
  group_by(member_casual, month) %>%
  summarise(number_of_rides = n()) %>%
  ggplot(aes(x = month, y = number_of_rides, color = member_casual)) +
  geom_point(size = 4) +
  scale_y_continuous(labels = comma) +
  labs(title = "Changes in number of riders by month",
       x = "Month",
       y = "Number of riders")

#STEP 5: EXPORT SUMMARY FILE FOR FURTHER ANALYSIS
counts <- aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = mean)
write.csv(counts, "D:\\GOOGLE DATA ANALYTICS\\Bike data\\avg_ride_length.csv")