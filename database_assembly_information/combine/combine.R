library(tidyverse)

gf<-read_csv("database_assembly_information/data_with_sources/consensus_species_growthform.csv")
wood<-read_csv("database_assembly_information/data_with_sources/GlobalWoodinessDatabase.csv")
nfix<-read_csv("database_assembly_information/data_with_sources/Werner_NFix.csv")


wood<-rename(wood,sp=gs)
nfix<-rename(nfix,sp=Species)

left_join(gf,wood) %>%
  left_join(nfix) %>%
  select(sp,support,woodiness,Data_fixing) %>%
  rename(nfixing=Data_fixing) %>%
  write_csv("growth_form.csv") 


