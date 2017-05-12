library(solrium)
library(tidyverse)
library(httr)

load("../data/frequentation/urls_journals_clean.Rdata")
load("../data/frequentation/urls_books_clean.Rdata")
load("../data/frequentation/urls_hypo_clean.Rdata")
load("../data/frequentation/urls_calenda_clean.Rdata")

library(jsonlite)

requete_solr <- function(IDs) {
  requete <- GET(url = "http://147.94.102.65:8983/solr/documents/select",
               query = list(
                q = paste0(paste0('id:"', paste0(IDs), '"'), collapse = " OR "),
                fl = paste0(c("id", 
                     "url",
                     "autodetect_lang",
                     "entity_isbnhtml",
                     "entity_isbn",
                     "naked_resume",
                     "resume_en",
                     "dateacceslibre",
                     "naked_titre",
                     "contributeur_auteur",
                     "siteOptions_editeur",
                     "openaireright",
                     "type"), collapse = ","),
                rows = 500,
                wt = "json"))
  fromJSON(content(requete, as = "text", type = "application/json"))$response$docs
}

solr_books <- map_df(seq(1, nrow(urls_books_clean)-49, 50), ~ requete_solr(urls_books_clean$ID[. : min(. + 49, nrow(urls_books_clean))])) %>% as_tibble()

solr_books <- solr_books %>% 
  rowwise() %>% 
  mutate(nb_auteurs = length(contributeur_auteur)) %>% 
  select(-contributeur_auteur)
  

save(solr_books, file = "../data/frequentation/solr_books.Rdata")
write_csv(solr_books, path = "../data/frequentation/solr_books.csv")


## journals

requete_solr <- function(IDs) {
  requete <- GET(url = "http://147.94.102.65:8983/solr/documents/select",
                 query = list(
                   q = paste0(paste0('id:"', paste0(IDs), '"'), collapse = " OR "),
                   fl = paste0(c("id", 
                                 "url",
                                 "autodetect_lang",
                                 "naked_resume",
                                 "resume_en",
                                 "dateacceslibre",
                                 "naked_titre",
                                 "contributeur_auteur",
                                 "siteOptions_editeur",
                                 "openaireright",
                                 "type",
                                 "site_name"), collapse = ","),
                   rows = 500,
                   wt = "json"))
  fromJSON(content(requete, as = "text", type = "application/json"))$response$docs
}

solr_journals <- map_df(seq(1, nrow(urls_journals_clean)-49, 50), ~ requete_solr(urls_journals_clean$ID[. : min(. + 49, nrow(urls_journals_clean))])) %>% as_tibble()

solr_journals <- solr_journals %>% 
  rowwise() %>% 
  mutate(nb_auteurs = length(contributeur_auteur)) %>% 
  select(-contributeur_auteur)

save(solr_journals, file = "../data/frequentation/solr_journals.csv")
write_csv(solr_journals, path = "../data/frequentation/solr_journals.csv")

## hypotheses

requete_solr <- function(IDs) {
  requete <- GET(url = "http://147.94.102.65:8983/solr/documents/select",
                 query = list(
                   q = paste0(paste0('id:"', paste0(IDs), '"'), collapse = " OR "),
                   fl = paste0(c("id", 
                                 "url",
                                 "naked_texte",
                                 "autodetect_lang",
                                 "dateacceslibre",
                                 "naked_titre",
                                 "contributeur_auteur",
                                 "site_name"), collapse = ","),
                   rows = 500,
                   wt = "json"))
  fromJSON(content(requete, as = "text", type = "application/json"))$response$docs
}

solr_hypo <- map_df(seq(1, nrow(urls_hypo_clean)-49, 50), ~ requete_solr(urls_hypo_clean$ID[. : min(. + 49, nrow(urls_hypo_clean))])) %>% as_tibble()

solr_hypo <- solr_hypo %>% 
  rowwise() %>% 
  mutate(auteur = unlist(contributeur_auteur)) %>% 
  select(-contributeur_auteur) %>% 
  mutate(longueur_txt = nchar(naked_texte))

save(solr_hypo, file = "../data/frequentation/solr_hypo.csv")
write_csv(solr_hypo, path = "../data/frequentation/solr_hypo.csv")


## Calenda

requete_solr <- function(IDs) {
  requete <- GET(url = "http://147.94.102.65:8983/solr/documents/select",
                 query = list(
                   q = paste0(paste0('id:"', paste0(IDs), '"'), collapse = " OR "),
                   fl = paste0(c("id", 
                                 "url",
                                 "autodetect_lang",
                                 "naked_resume",
                                 "resume_en",
                                 "naked_texte",
                                 "dateacceslibre",
                                 "naked_titre",
                                 "type",
                                 "site_name"), collapse = ","),
                   rows = 500,
                   wt = "json"))
  fromJSON(content(requete, as = "text", type = "application/json"))$response$docs
}

solr_calenda <- map_df(seq(1, nrow(urls_calenda_clean)-49, 50), ~ requete_solr(urls_calenda_clean$ID[. : min(. + 49, nrow(urls_calenda_clean))])) %>% as_tibble()

solr_calenda <- solr_calenda %>% 
  mutate(longueur_txt = nchar(naked_texte))

save(solr_calenda, file = "../data/frequentation/solr_calenda.csv")
write_csv(solr_calenda, path = "../data/frequentation/solr_calenda.csv")
