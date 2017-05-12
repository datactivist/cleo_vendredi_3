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

urls_journals <- getPageUrls(idSite = 3, date = paste0(ymd("20170101"), ",", ymd("20170101") + days(60)))


urls_books <- getPageUrls(idSite = 5, date = paste0(ymd("20170101"), ",", ymd("20170101") + days(30)))

save(urls_journals, file = "../data/frequentation/journals20170101-20170302.Rdata")
write_csv(urls_journals, path = "../data/frequentation/journals20170101-20170302.csv")

save(urls_books, file = "../data/frequentation/books20170101-20170131.Rdata")
write_csv(urls_books, path = "../data/frequentation/books20170101-20170131.csv")
# ensuite éventuellement utiliser visitsSegmented pour récupérer url par url
