library(tidyverse)
library(lubridate)
library(ggplot2)
library(dplyr)
library(readr)
library(janitor)

#Importing 12 Months of Trip Data
apr_2020 <- read_csv("12 Months Data/202004-divvy-tripdata.csv")
may_2020 <- read_csv("12 Months Data/202005-divvy-tripdata.csv")
jun_2020 <- read_csv("12 Months Data/202006-divvy-tripdata.csv")
jul_2020 <- read_csv("12 Months Data/202007-divvy-tripdata.csv")
aug_2020 <- read_csv("12 Months Data/202008-divvy-tripdata.csv")
sep_2020 <- read_csv("12 Months Data/202009-divvy-tripdata.csv")
oct_2020 <- read_csv("12 Months Data/202010-divvy-tripdata.csv")
nov_2020 <- read_csv("12 Months Data/202011-divvy-tripdata.csv")
dec_2020 <- read_csv("12 Months Data/202012-divvy-tripdata.csv")
jan_2021 <- read_csv("12 Months Data/202101-divvy-tripdata.csv")
feb_2021 <- read_csv("12 Months Data/202102-divvy-tripdata.csv")
mar_2021 <- read_csv("12 Months Data/202103-divvy-tripdata.csv")

#Comparing columns before the merge
compare_df_cols_same(apr_2020,aug_2020,may_2020,jun_2020,jul_2020,sep_2020,oct_2020,nov_2020,dec_2020,jan_2021,feb_2021,mar_2021)

#changing end_station_id and start_station_id into character so the data can be merged
apr_2020 <- mutate(apr_2020,end_station_id = as.character(end_station_id),start_station_id = as.character(start_station_id))
may_2020 <- mutate(may_2020,end_station_id = as.character(end_station_id),start_station_id = as.character(start_station_id))
jun_2020 <- mutate(jun_2020,end_station_id = as.character(end_station_id),start_station_id = as.character(start_station_id))
jul_2020 <- mutate(jul_2020,end_station_id = as.character(end_station_id),start_station_id = as.character(start_station_id))
aug_2020 <- mutate(aug_2020,end_station_id = as.character(end_station_id),start_station_id = as.character(start_station_id))
sep_2020 <- mutate(sep_2020,end_station_id = as.character(end_station_id),start_station_id = as.character(start_station_id))
oct_2020 <- mutate(oct_2020,end_station_id = as.character(end_station_id),start_station_id = as.character(start_station_id))
nov_2020 <- mutate(nov_2020,end_station_id = as.character(end_station_id),start_station_id = as.character(start_station_id))
dec_2020 <- mutate(dec_2020,end_station_id = as.character(end_station_id),start_station_id = as.character(start_station_id))
jan_2021 <- mutate(jan_2021,end_station_id = as.character(end_station_id),start_station_id = as.character(start_station_id))
feb_2021 <- mutate(feb_2021,end_station_id = as.character(end_station_id),start_station_id = as.character(start_station_id))
mar_2021 <- mutate(mar_2021,end_station_id = as.character(end_station_id),start_station_id = as.character(start_station_id))

#Re-Check if the columns can be merged or not
compare_df_cols_same(apr_2020,aug_2020,may_2020,jun_2020,jul_2020,sep_2020,oct_2020,nov_2020,dec_2020,jan_2021,feb_2021,mar_2021)

# Merging all 12 months of data into 1 raw database
trip_data<-do.call("rbind", list(apr_2020,may_2020,jun_2020,jul_2020,aug_2020,sep_2020,oct_2020,nov_2020,dec_2020,jan_2021,feb_2021,mar_2021))

# Clean the environment except for the raw database
rm(list=setdiff(ls(),'trip_data'))

# removing unused columns
trip_data <- trip_data[,-c(1,9:12)]

#calculating ride length as hours
trip_data$ride_length <- round(difftime(trip_data$ended_at,trip_data$started_at,units='hours'),2)

#define trip days
trip_data$trip_days <- weekdays(trip_data$started_at)

#Checking bad ride length
sum(trip_data$ride_length < 0)

#Get rid of bad ride length data
trip_data <- trip_data[!(trip_data$ride_length < 0),]

# create breaks
breaks <- hour(hm("00:00", "6:00", "12:00", "18:00", "23:59"))

# labels for the breaks
labels <- c("Night", "Morning", "Afternoon", "Evening")

# Defining time of the day (morning, afternoon, evening, night)
trip_data$time_of_the_trip <- cut(x=hour(trip_data$started_at), breaks = breaks, labels = labels, include.lowest=TRUE)

#Write our cleaned and prepared data into csv
write_csv(trip_data, "./Your Export location")
