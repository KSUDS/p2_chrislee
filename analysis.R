library(tidyverse)
library(ggplot2)
library(waffle)
library(dplyr)

httpgd::hgd()
httpgd::hgd_browse()

dat <- read_csv("full_data.csv") %>%
    select(-...1)

dat

dat_pop <- tibble(
    race = c("Asian/Pacific Islander",
        "Black",  "Hispanic",
        "Native American/Native Alaskan",  "White"),
    N =  331449281 * c(.061, .134, .185, .013, .763))

dat_pop

dat <- dat %>%
    group_by(race, year) %>%
    summarise(n = n()) %>%
    ungroup()

dat_merge <- merge(dat, dat_pop)

glimpse(dat_merge)



glimpse(dat)

datrace <- dat %>% group_by(race, education)

dat_merge %>%
    ggplot(aes(x = race, y = year, fill = n / N)) +
    geom_tile() +
    geom_fit_text(aes(label = n / N), color = "white", size = 4, contrast = TRUE) +
    scale_fill_viridis_c() +
    coord_fixed()


datrace


testdata <- read_csv("full_data.csv")
glimpse(testdata)

dat_plot <- testdata %>% 
    group_by(race, education) %>%
    summarise(n = n()) %>%
    ungroup()

glimpse(dat_plot)

dat_testsum <- testdata %>%
    group_by(race) %>%
    summarise(N = n()) %>%
    ungroup()

glimpse(dat_testsum)

dat_pop <- tibble(
    race = c("Asian/Pacific Islander",
        "Black",  "Hispanic",
        "Native American/Native Alaskan",  "White"),
    N =  331449281 * c(.061, .134, .185, .013, .763))

dat_merge <- merge(dat_plot, dat_testsum)

dat_prop <- dat_merge %>%
    mutate(proppop = n / N)

glimpse(dat_prop)

dat_prop %>%
    ggplot(aes(x = race, y = education, fill = proppop)) +
    geom_tile() +
    geom_fit_text(aes(label = round(proppop, 2)), color = "white", size = 10, contrast = TRUE) +
    scale_fill_viridis_c() +
    coord_fixed()
