# modélisation 

load("../data/frequentation/urls_journals_clean.Rdata")
load("../data/frequentation/solr_journals.Rdata")

library(lubridate)
library(tidyverse)

df_journals <- left_join(solr_journals,
          urls_journals_clean,
          by = c("url" = "ID"))

df_journals <- df_journals %>% 
  ungroup() %>% 
  mutate(ancienneté = ymd_hms(Sys.time()) - ymd_hms(dateacceslibre)) %>% 
  mutate(resume_en_lgl = !is.na(resume_en))

library(lme4)

modele1 <- glmer(nb_visits ~ 1  + (1  | site_name), data = df_journals, family = poisson(link = "log"))
modele2 <- glmer(nb_visits ~ 1  + (1 | site_name) + (1 | autodetect_lang), data = df_journals, family = poisson(link = "log"))
modele3 <- glmer(nb_visits ~ 1  + (1 | site_name) + (1 | autodetect_lang) + (1 | resume_en_lgl), data = df_journals, family = poisson(link = "log"))
modele4 <- glmer(nb_visits ~ 1  + nb_auteurs + (1 | site_name) + (1 | autodetect_lang) + (1 | resume_en_lgl), data = df_journals, family = poisson(link = "log"))
modele5 <- glmer(nb_visits ~ 1  + nb_auteurs + ancienneté + (1 | site_name) + (1 | autodetect_lang) + (1 | resume_en_lgl), data = df_journals, family = poisson(link = "log"))

modele1bis <- glmer.nb(nb_visits ~ 1  + (1  | site_name), data = df_journals)
modele2bis <- glmer.nb(nb_visits ~ 1  + (1 | site_name) + (1 | autodetect_lang), data = df_journals)
modele3bis <- glmer.nb(nb_visits ~ 1  + (1 | site_name) + (1 | autodetect_lang) + (1 | resume_en_lgl), data = df_journals)
modele4bis <- glmer.nb(nb_visits ~ 1  + nb_auteurs + (1 | site_name) + (1 | autodetect_lang) + (1 | resume_en_lgl), data = df_journals)
modele5bis <- glmer.nb(nb_visits ~ 1  + nb_auteurs + ancienneté + (1 | site_name) + (1 | autodetect_lang) + (1 | resume_en_lgl), data = df_journals)

library(texreg)

screenreg(list(modele1, modele2, modele3, modele4, modele5))
screenreg(list(modele1bis, modele2bis, modele3bis, modele4bis))
