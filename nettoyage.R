library(tidyverse)


load("../data/frequentation/booksAgrege20170101-20170420.Rdata")
load("../data/frequentation/calendaAgrege20170101-20170420.Rdata")
load("../data/frequentation/hypoAgrege20170101-20170420.Rdata")
load("../data/frequentation/journalsAgrege20170101-20170420.Rdata")

urls_books_clean <- urls_booksAgrege %>% 
  filter(!is.na(livre),
         !livre %in% "") %>% 
  mutate(ID = paste0("http://books.openedition.org/", collection, "/", livre)) %>% 
  group_by(ID) %>% 
  summarise_at(vars(contains("visits")), funs(sum(.))) %>% 
  ungroup %>% 
  arrange(desc(nb_visits))

save(urls_books_clean, file = "../data/frequentation/urls_books_clean.Rdata")
write_csv(urls_books_clean, path = "../data/frequentation/urls_books_clean.csv")


urls_journals_clean <- urls_journalsAgrege %>% 
  filter(!is.na(article),
         !article %in% "") %>% 
  mutate(ID = paste0("http://", revue, ".revues.org/", article)) %>% 
  group_by(ID) %>% 
  summarise_at(vars(contains("visits")), funs(sum(.))) %>% 
  ungroup %>% 
  arrange(desc(nb_visits))

save(urls_journals_clean, file = "../data/frequentation/urls_journals_clean.Rdata")
write_csv(urls_journals_clean, path = "../data/frequentation/urls_journals_clean.csv")

urls_hypo_clean <- urls_hypoAgrege %>% 
  filter(!is.na(billet),
         !billet %in% "") %>% 
  mutate(ID = paste0("http://", carnet, ".hypotheses.org/", billet)) %>% 
  group_by(ID) %>% 
  summarise_at(vars(contains("visits")), funs(sum(.))) %>% 
  ungroup %>% 
  arrange(desc(nb_visits))

save(urls_hypo_clean, file = "../data/frequentation/urls_hypo_clean.Rdata")
write_csv(urls_hypo_clean, path = "../data/frequentation/urls_hypo_clean.csv")

urls_calenda_clean <- urls_calendaAgrege %>% 
  filter(!is.na(evenement),
         !evenement %in% "") %>% 
  mutate(ID = paste0("http://calenda.org/", evenement)) %>% 
  group_by(ID) %>% 
  summarise_at(vars(contains("visits")), funs(sum(.))) %>% 
  ungroup %>% 
  arrange(desc(nb_visits))

save(urls_calenda_clean, file = "../data/frequentation/urls_calenda_clean.Rdata")
write_csv(urls_calenda_clean, path = "../data/frequentation/urls_calenda_clean.csv")

