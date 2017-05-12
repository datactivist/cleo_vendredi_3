library(solrium)
library(tidyverse)
library(httr)

load("../data/frequentation/urls_journals_clean.Rdata")
load("../data/frequentation/urls_books_clean.Rdata")

solr_connect('http://147.94.102.65:8983/')

test <- solr_search(name = "documents", 
                    q = URLencode(paste0(paste0('id:"', paste0(urls_books_clean$ID[1:10]), '"'), collapse = " OR "), reserved = TRUE),
                    fl = URLencode(paste0(c("id", 
                        "url",
                        "autodetect_lang",
                        "isbnhtml",
                        "naked_resume",
                        "resume_en",
                        "dateacceslibre",
                        "naked_titre",
                        "contributeur_auteur",
                        "siteOptions_editeur",
                        "openaireright"), collapse = ","), reserved = TRUE),
                    raw = TRUE)
library(jsonlite)

requete_solr <- function(IDs) {
  requete <- GET(url = "http://147.94.102.65:8983/solr/documents/select",
               query = list(
                q = paste0(paste0('id:"', paste0(IDs), '"'), collapse = " OR "),
                fl = paste0(c("id", 
                     "url",
                     "autodetect_lang",
                     "isbnhtml",
                     "naked_resume",
                     "resume_en",
                     "dateacceslibre",
                     "naked_titre",
                     "contributeur_auteur",
                     "siteOptions_editeur",
                     "openaireright"), collapse = ","),
                wt = "json"))
  fromJSON(content(requete, as = "text", type = "application/json"))$response$docs
}

solr_books <- map_df(seq(1, nrow(urls_books_clean)-19, 20), ~ requete_solr(urls_books_clean$ID[. : min(. + 19, nrow(urls_books_clean))])) %>% as_tibble()

solr_books <- solr_books %>% 
  rowwise() %>% 
  mutate(nb_auteurs = length(contributeur_auteur)) %>% 
  select(-contributeur_auteur)
  

save(solr_books, file = "../data/frequentation/solr_books.Rdata")
write_csv(solr_books, path = "../data/frequentation/solr_books.csv")


