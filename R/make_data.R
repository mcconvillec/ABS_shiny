# Make data to be used in the Shiny app

library(tidyverse)

source("R/rename_abs.R")

quals <- c(
  "No qualification",
  "Cert III/IV",
  "Dip/Ad-dip",
  "Bachelor",
  "Postgrad"
)


# Whole population ------------------------------------------------
data <- read_csv("raw_data/education_occ_nostudy.csv", skip = 10) %>% 
  select(-X8)

names(data) <- rename_abs(data)

data <- data %>% 
  select(-person_place) %>% 
left_join(read_csv("raw_data/occ_list.csv")) %>% 
  group_by(occ, age, sex) %>% 
  mutate(total = sum(n),
         pc = 100 * n / total) %>% 
group_by(occ) %>% 
  mutate(occ_total = sum(n)) %>% 
# Drop low n nfd occupations
  mutate(is_nfd = grepl(", nfd", occ)) %>% 
  filter(!(is_nfd && occ_total < 500)) %>% 
# Create factors
  mutate(qual = factor(qual, levels = quals)) %>% 
# Create observation_weight for alpha in chart
  mutate(observation_weight = (n/occ_total) / max(n/occ_total))



write_rds(data, "raw_data/education_occ_nostudy.rds")




# Aus-citizens only; not studying ------------------------------------------------
data1 <- read_csv("raw_data/education_occ_aus_nostudy.csv", skip = 10) %>% 
  select(-X9)

names(data1) <- rename_abs(data1)

data1 <- data1 %>% 
  select(-person_place,
         -citizen,
         -student_status) %>% 
  left_join(read_csv("raw_data/occ_list.csv")) %>% 
  group_by(occ, age, sex) %>% 
  mutate(total = sum(n),
         pc = 100 * n / total) %>% 
  group_by(occ) %>% 
  mutate(occ_total = sum(n)) %>% 
  # Drop low n nfd occupations
  mutate(is_nfd = grepl(", nfd", occ)) %>% 
  filter(!(is_nfd && occ_total < 500)) %>% 
  # Create factors
  mutate(qual = factor(qual, levels = quals)) %>% 
  # Create observation_weight for alpha in chart
  mutate(observation_weight = (n/occ_total) / max(n/occ_total))



write_rds(data1, "raw_data/occ_education_aus.rds")





  
