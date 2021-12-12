library(tidyverse)
library(ggplot2)
library(ggthemes)
library(waffle)


httpgd::hgd()
httpgd::hgd_browse()

dat <- read_csv("https://github.com/fivethirtyeight/guns-data/raw/master/full_data.csv") %>%
        select(-...1)
head(dat)

#create new column
dat <- dat %>% 
        mutate(age_group = case_when(
            age < 18 ~ "Young",
            age>=18 & age < 30 ~ "Young Adult",
            age >=30 & age < 60 ~ "Adult",
            age>= 60 ~ "Senior",
            TRUE ~ "NA"
        ))

##from class##
dat_pop <- tibble(
    race = c("Asian/Pacific Islander",  
        "Black",  "Hispanic",  
        "Native American/Native Alaskan",  "White"), 
    N =  331449281 *c(.061, .134, .185, .013, .763))
dat_counts <- dat %>% count(race, year)
#joining last two datasets
dat_counts %>% 
    left_join(dat_pop, by = "race") -> dat_counts_2
######################################################


#DOT/LINE CHART ~ Summary chart for 538 article summary
dat2 <- dat %>% filter(intent!="NA", intent!="Undetermined") %>% count(intent,race, age_group)
dat2$age_group <- factor(dat2$age_group, levels = c("Young", "Young Adult", "Adult", "Senior"))

dat2 %>% filter(intent!="NA", age_group!="NA") %>%
    ggplot(aes(x=intent, y=n,color=age_group, group=age_group)) + 
    ggtitle("Figure 1: Gun Deaths in the U.S.") + 
    geom_point() + facet_wrap(~race,nrow=1) + geom_line() +
    scale_y_continuous(trans = "sqrt") + xlab("Intent") +
    ylab("Count of Deaths") + labs(color="Age Group") +
    theme_fivethirtyeight()

######################################################

##exploring data
dat_months <- dat %>% count(year,month)
    #notice adults make up the largest percentage
dat %>% ggplot(aes(x=month, fill=intent)) + geom_bar()

    #suicides are mostly white adult males
dat %>% filter(age_group == "Adult") %>% ggplot(aes(x=intent, fill=race)) + geom_bar()
dat %>% filter(age_group == "Adult", race=="White") %>% ggplot(aes(x=intent, fill=sex)) + geom_bar()
dat %>% filter(intent == "Suicide") %>% ggplot(aes(x=month, fill=race)) + geom_bar()
    #rise in Homicides in July (mostly black victims)

dat %>% filter(intent == "Homicide", race == "Black") %>% ggplot(aes(x=month, fill=race)) + geom_bar()
dat %>% filter(intent=="Homicide", race=="Black", month==("03")| month==("04")| month==("05")| month==("06")| month==("07")) %>% ggplot(aes(x=month, fill=race)) + geom_bar()

######################################################

#CHART 1#
##line chart of white male suicides##
datasian <- (dat %>% filter(race=="Asian/Pacific Islander",intent=="Homicide", age_group!="NA", sex=="M") %>% count(year,month,age_group))
datasian$age_group <- factor(datws$age_group, levels = c("Young", "Young Adult", "Adult", "Senior"))

datasian<- datasian %>% mutate(month = factor(month, labels = c("Jan","Feb","Mar","Apr",
            "May","June","July","Aug","Sept","Oct","Nov","Dec")))
chart1 <-datasian %>% ggplot(aes(x=month,y=n, color=age_group, group=age_group)) + geom_point() + geom_line() + 
            xlab("Month") + ylab("Count of Deaths") + labs(color="Age Group") + theme_fivethirtyeight() +
            labs(title = "Asian Homicide Time Series by Age Group", subtitle = "Source: 538") +
            facet_wrap(~year,nrow=1)

ggsave("chart1.png", width = 15, units = "in")
    
######################################################
#CHART 2#
##rise in homicides of balck males march to july##
datsuicide <- dat %>% filter(intent=="Suicide", race=="White",sex=="M",age_group=="Adult") %>% count(month,age_group)
datsuicide$n <- datsuicide$n/2
datsuicide <- datsuicide %>% mutate(month = factor(month, labels = c("Jan","Feb","Mar","Apr",
            "May","June","July","Aug","Sept","Oct","Nov","Dec")))
chart2 <- ggplot(datsuicide, aes(fill = age_group, values = n)) +
            geom_waffle(color = "black", size = .25, n_rows = 30, flip = TRUE) +
            facet_wrap(~month, nrow = 1, strip.position = "bottom")+
            scale_x_discrete() + 
            #scale_y_continuous(labels = function(x) x * 10, expand = c(0, 0)) +
            ggthemes::scale_fill_tableau(name = NULL) +
            coord_equal() +
            labs(
                title = "Suicides of Adult White Males",
                subtitle = "Source: 538",
                x = "Month",
                y = "Count"
            ) + guides(fill = guide_legend(reverse = TRUE))+ theme_fivethirtyeight()
ggsave("chart2.png")