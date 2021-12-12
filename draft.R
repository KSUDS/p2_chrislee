library(tidyverse)
library(ggplot2)
library(waffle)
library(dplyr)

httpgd::hgd()
httpgd::hgd_browse()

dat <- read_csv("https://github.com/fivethirtyeight/guns-data/raw/master/full_data.csv") %>%
    select(-...1)

dat <- dat %>%
    mutate(age_group = case_when(
        age < 18 ~ "Young",
        TRUE ~ "old"
   ))

glimpse(dat)

dat_pop <- tibble(
    race = c("Asian/Pacific Islander",
        "Black",  "Hispanic",
        "Native American/Native Alaskan",  "White"),
    N =  331449281 * c(.061, .134, .185, .013, .763))

dat_pop

dat_merge <- merge(dat, dat_pop)

glimpse(dat_merge)

dat_counts <- dat %>%
    count(race, year)

dat_counts %>%
    left_join(dat_pop, by = "race")

datrace <- dat %>% group_by(race, education)

dat_merge %>%
    drop_na() %>%
    group_by(race) %>%
    summarize(nn = n()) %>%
    ungroup()
    mutate(perc = nn / N * 100) %>%
    ggplot(aes(values = round(perc), fill = race)) +
    geom_waffle()

datrace