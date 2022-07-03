#(1)
getwd()
setwd("c:/users/ashwin.madhusudan/onedrive - spreetail/Desktop/Personal/Files/Personal/McDaniel College/ANA 515/Week 6")

library(tidyverse)
library(stringr)
library(ggplot2)

stormevents <- read_csv("StormEvents_details-ftp_v1.0_d1995_c20220425.csv")

#(2)
subsetcolumns <- c("BEGIN_DATE_TIME","END_DATE_TIME","EPISODE_ID","EVENT_ID","STATE","STATE_FIPS","CZ_NAME","CZ_TYPE","CZ_FIPS","EVENT_TYPE","SOURCE","BEGIN_LAT","BEGIN_LON","END_LAT","END_LON")
stormeventssubset <- stormevents[subsetcolumns]
head(stormeventssubset)

#(3)
arrange(stormeventssubset, STATE)

#(4)
str_to_title(stormeventssubset$STATE, locale = "en")
str_to_title(stormeventssubset$CZ_NAME, locale = "en")

#(5)
stormeventssubset <- select(filter(stormeventssubset, CZ_TYPE == "C"), -CZ_TYPE)

#(6)
stormeventssubset$STATE_FIPS <- str_pad(stormeventssubset$STATE_FIPS, width=3, side="left", pad="0")
stormeventssubset$CZ_FIPS <- str_pad(stormeventssubset$CZ_FIPS, width=3, side="left", pad="0")
stormeventssubset <- unite(stormeventssubset, col='FIPS', c('STATE_FIPS','CZ_FIPS'))

#(7)
stormeventssubset <- rename_all(stormeventssubset, tolower)

#(8)
data("state")
us_state_info <- data.frame(state = state.name, region = state.region, area = state.area)

#(9)
stormeventsfrequency <- data.frame(table(stormeventssubset$state))
us_state_info_upper <- mutate_all(us_state_info, toupper)
stormeventsfrequency1 <- rename(stormeventsfrequency, c("state"="Var1"))
mergedstateinfo <- merge(x=stormeventsfrequency1, y=us_state_info_upper, by.x="state", by.y="state")

#(10)
storm_plot <- ggplot(mergedstateinfo, aes(x=area, y=Freq)) +
  geom_point(aes(color=region)) +
  labs(x="Land Area (square miles)",
       y="# of storm events in 1995")
