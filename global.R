# --------- LOAD LIBRARIES
options(scipen = 99) # me-non-aktifkan scientific notation
library(tidyverse) # koleksi beberapa package R
library(dplyr) # grammar of data manipulation
library(readr) # membaca data
library(ggplot2) # plot statis
library(plotly) # plot interaktif
library(glue) # setting tooltip
library(scales) # mengatur skala pada plot
# dashboarding
library(shiny)
library(shinydashboard)
library(DT) # datatable
# --------- DATA PREPARATION
vids <- read_csv("youtubetrends.csv", 
                 #mengubah beberapa karakter menjadi karakter latin
                 locale = locale(encoding = "latin1"))
vids_clean <- vids %>% 
  mutate(
    channel_title = as.factor(channel_title),
    category_id = as.factor(category_id),
    publish_when = as.factor(publish_when),
    publish_wday = as.factor(publish_wday),
    timetotrend = as.factor(timetotrend),
    likesp = likes / views,
    dislikesp = dislikes / views,
    commentp = comment_count / views
  ) %>% 
  select(-c(comments_disabled, ratings_disabled, video_error_or_removed))
# --------- HALAMAN PERTAMA: OVERVIEW (BAR PLOT)
vids_count <- vids_clean %>% 
  group_by(category_id) %>% 
  summarise(count = n()) %>% 
  arrange(desc(count))
# penambahan tooltip
vids_count <- vids_count %>% 
  mutate(label = glue("Category: {category_id}
                      Video Count: {count} Videos"))