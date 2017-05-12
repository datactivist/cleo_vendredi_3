## Récupération de données

# données de fréquentation 

library(httr)
library(purrr)
library(lubridate)
library(tidyverse)


source("./fonctions.R")
source("auth.R", local = TRUE)

# récupérer données par URL (pour revues.org) par période de 10 jours consécutif (pour ne pas surcharger l'API)
# urls_journals <- map_df(seq(0, 30, 10), ~ safely(getPageUrls)(idSite = 3, date = paste0(ymd("20170101") + days(.), ",", ymd("20170101") + days(. + 9))))

# urls_journals <- getPageUrls(idSite = 3, date = paste0(ymd("20170101"), ",", ymd("20170101") + days(60)))
# 
# 
# urls_books <- getPageUrls(idSite = 5, date = paste0(ymd("20170101"), ",", ymd("20170101") + days(30)))
# 
# save(urls_journals, file = "../data/frequentation/journals20170101-20170302.Rdata")
# write_csv(urls_journals, path = "../data/frequentation/journals20170101-20170302.csv")
# 
# save(urls_books, file = "../data/frequentation/books20170101-20170131.Rdata")
# write_csv(urls_books, path = "../data/frequentation/books20170101-20170131.csv")
# # ensuite éventuellement utiliser visitsSegmented pour récupérer url par url


urls_journalsAgrege <- getPageUrls(idSite = 3, date = paste0(ymd("20170101"), ",", ymd("20170420")), period = "range")

urls_booksAgrege <- getPageUrls(idSite = 5, date = paste0(ymd("20170101"), ",", ymd("20170420")), period = "range")


## parser les urls ?

library(rex)

rex_mode()

valid_chars <- rex(except_some_of(".", "/", " ", "-"))


regex_journal <- rex(
  group("http", maybe("s"), "://"),
  capture(name = "revue",
          zero_or_more(valid_chars, zero_or_more("-"))
          ),
  maybe("."),
  "revues.org",
  maybe("/",
  capture(
    name = "article",
    one_or_more(numbers))
  )
)

urls_journalsAgrege <- bind_cols(urls_journalsAgrege, re_matches(urls_journalsAgrege$url, regex_journal))

save(urls_journalsAgrege, file = "../data/frequentation/journalsAgrege20170101-20170420.Rdata")
write_csv(urls_journalsAgrege, path = "../data/frequentation/journalsAgrege20170101-20170420.csv")

regex_books <- rex(
  group("http", maybe("s"), "://"),
  "books.openedition.org",
  maybe(
    "/",
    capture(name = "collection",
            zero_or_more(valid_chars, zero_or_more("-"))
    )),
    maybe("/",    
    capture(name = "livre",
            numbers
    )
    )
)

urls_booksAgrege <- bind_cols(urls_booksAgrege, re_matches(urls_booksAgrege$url, regex_books))
save(urls_booksAgrege, file = "../data/frequentation/booksAgrege20170101-20170420.Rdata")
write_csv(urls_booksAgrege, path = "../data/frequentation/booksAgrege20170101-20170420.csv")

## hypothèses

urls_hypoAgrege <- getPageUrls(idSite = 4, date = paste0(ymd("20170101"), ",", ymd("20170420")), period = "range")

regex_hypo <- rex(
  group("http", maybe("s"), "://"),
  capture(name = "carnet",
          zero_or_more(valid_chars, zero_or_more("-"))
  ),
  maybe("."),
  "hypotheses.org",
  maybe("/",
        capture(
          name = "billet",
          one_or_more(numbers))
  )
)

urls_hypoAgrege <- bind_cols(urls_hypoAgrege, re_matches(urls_hypoAgrege$url, regex_hypo))
save(urls_hypoAgrege, file = "../data/frequentation/hypoAgrege20170101-20170420.Rdata")
write_csv(urls_hypoAgrege, path = "../data/frequentation/hypoAgrege20170101-20170420.csv")

## Calenda

urls_calendaAgrege <- getPageUrls(idSite = 6, date = paste0(ymd("20170101"), ",", ymd("20170420")), period = "range")

regex_calenda <- rex(
  group("http", maybe("s"), "://"),
  "calenda.org",
  maybe("/",
        capture(
          name = "evenement",
          one_or_more(numbers))
  )
)

urls_calendaAgrege <- bind_cols(urls_calendaAgrege, re_matches(urls_calendaAgrege$url, regex_calenda))
save(urls_calendaAgrege, file = "../data/frequentation/calendaAgrege20170101-20170420.Rdata")
write_csv(urls_calendaAgrege, path = "../data/frequentation/calendaAgrege20170101-20170420.csv")
