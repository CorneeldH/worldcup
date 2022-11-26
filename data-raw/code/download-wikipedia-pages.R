# Joshua C. Fjelstul, Ph.D.
# worldcup R package

# Packages
library(downloadr)
library(tidyverse)

# Tournament pages -------------------------------------------------------------

# world

start_year_world <- 1930
end_year_world <- 2022
years_world <- list()

while (start_year_world <= end_year_world) {
    ## Do not add years without world cup to list
    if (!(start_year_world %in% c(1942, 1946))) {
        years_world <- append(years_world, start_year_world)   
    }
    start_year_world = start_year_world + 4
}

base_url_start_world <- "https://en.wikipedia.org/wiki/"
base_url_end_world <- "_FIFA_World_Cup"
urls_world <- map_chr(years_world, ~paste0(base_url_start_world, 
                                           .x, 
                                           base_url_end_world))

files_world <- urls_world %>%
    str_extract("[0-9]{4}.*") %>%
    str_replace("_FIFA_World_Cup", "_world") %>%
    str_c(".html")

# euro

start_year_euro <- 1960
end_year_euro <- 2020
years_euro <- list()

while (start_year_euro <= end_year_euro) {
    years_euro <- append(years_euro, start_year_euro)
    start_year_euro = start_year_euro + 4
}

base_url_euro <- "https://en.wikipedia.org/wiki/UEFA_Euro_"
urls_euro <- map_chr(years_euro, ~paste0(base_url_euro, .x))

files_euro <- urls_euro %>%
    str_extract("[0-9]{4}.*") %>%
    str_c("_euro.html")

# copa

## String from https://en.wikipedia.org/wiki/Copa_Am%C3%A9rica, tournaments section
## TODO: 1959 had two tournaments, the second one is excluded (less competitors and B-teams)
years_string_copa <- "1916191719191920192119221923192419251926192719291935193719391941194219451946194719491953195519561957195919631967197519791983198719891991199319951997199920012004200720112015201620192021"
years_copa <- strsplit(years_string_copa, "(?<=.{4})", perl = TRUE)[[1]]

base_url_start_copa <- "https://en.wikipedia.org/wiki/" 
base_url_end_old_copa <- "_South_American_Championship"
base_url_end_new_copa <- "_Copa_Am%C3%A9rica"

urls_copa <- map_chr(years_copa, ~case_when(
    . == 1959 ~ paste0(base_url_start_copa, ., base_url_end_old_copa, "_(Argentina)"),
    . < 1975 ~ paste0(base_url_start_copa, ., base_url_end_old_copa),
    TRUE ~ paste0(base_url_start_copa, ., base_url_end_new_copa)))


files_copa <- urls_copa %>%
    str_extract("[0-9]{4}.*") %>%
    str_replace("_Copa_Am%C3%A9rica", "-copa") %>%
    str_replace("_(Argentina)", "") %>%
    str_replace("_South_American_Championship", "_copa") %>%
    str_c(".html")

## complete

urls_tournament <- c(urls_euro, urls_copa, urls_world)
files_tournament <- c(files_euro, files_copa, files_world)

# Squad pages ------------------------------------------------------------------

urls_squads <- map_chr(urls_tournament, ~paste0(., "_squads"))

files_squads <- files_tournament %>%
    str_replace(".html", "_squads.html")

# Match pages ------------------------------------------------------------------

## Transform tournament list into dataframe in order to match
dfUrls <- urls_tournament %>% 
    ## Extract year / tournament
    map(~list(str_extract(.,  "[0-9]{4}"), str_extract(., "[Ww]orld|[Ee]uro|[Cc]opa"), .)) %>%
    map_dfr(~set_names(., c("year", "tournament", "url"))) %>%
    mutate(tournament = tolower(tournament)) %>%
    ## Add empty values (South American Championship) with coopa
    mutate(tournament = replace_na(tournament, "copa"))

dfMatches <- read_csv("data-raw/tournament-pages-table/tournament_match_pages.csv") %>%
    mutate(year = as.character(year)) %>%
    ## Add urls
    left_join(dfUrls,
              by = c("tournament", "year")) %>%
    ## Add url for every match
    mutate(match_pages = map2(
        match_pages, 
        url,
        ~ifelse(is.na(.x),
                list(NA),
                str_split(.x, ";") %>% map(., function(x2) paste(.y, x2, sep = "_") %>% as.list)
        )
    )) %>% 
    ## Double unnest because match_pages are vectors (with diverfuncse lengths) within lists
    unnest_longer(col = match_pages) %>% 
    unnest_longer(col = match_pages)

dfMatches <- dfMatches %>%
    mutate(match_pages = case_when(
        (year == "1960" & tournament == "euro") ~ str_replace(match_pages, "UEFA_Euro_1960", "1960_European_Nations%27_Cup"),
        (year == "1964" & tournament == "euro") ~ str_replace(match_pages, "UEFA_Euro_1964", "1964_European_Nations%27_Cup"),
        (year == "2016" & tournament == "copa") ~ str_replace(match_pages, "2016_Copa_Am%C3%A9rica", "Copa_Am%C3%A9rica_Centenario"),
        TRUE ~ match_pages
    )) %>%
    ## Remove two copa's, they have links on wikipedia but are currently unavailable
    filter(!(year %in% c("2001", "2004") & tournament %in% c("copa"))) %>%
    ## Remove another copa because the data for matches is formatted differently
    filter(!(year == "1999" & tournament %in% c("copa")))


urls_matches <- dfMatches %>% pull(match_pages)

files_matches <- dfMatches %>% 
    ## TODO: Code is dangerous: it only works if match_pages consist of two elements 
    ## It ignores changes in urls of matches
    mutate(file = map(match_pages, ~str_split(., "_")[[1]] %>% tail(2) %>% paste(., collapse = "_")),
           file = paste(year, tournament, file, sep = "-"),
           file = str_replace(file, "_", "-"),
           file = tolower(file),
           file = str_c(file, ".html")
    ) %>% pull(file)



## download all files

download_files(
    urls = urls_tournament,
    files = files_tournament,
    delay_min = 0.5,
    delay_max = 1,
    folder_path = "data-raw/Wikipedia-tournament-pages"
)

download_files(
    urls = urls_squads,
    files = files_squads,
    delay_min = 0.5,
    delay_max = 1,
    folder_path = "data-raw/Wikipedia-squad-pages"
)

download_files(
    urls = urls_matches,
    files = files_matches,
    delay_min = 0.5,
    delay_max = 1,
    folder_path = "data-raw/Wikipedia-match-pages"
)

##
## ruim op ##
##

rm(
    base_url_end_new_copa,
    base_url_end_old_copa,
    base_url_end_world,
    base_url_euro,
    base_url_start_copa,
    base_url_start_world,
    end_year_euro,
    end_year_world,
    files_copa,
    files_euro,
    files_matches,
    files_squads,
    files_tournament,
    files_world,
    start_year_euro,
    start_year_world,
    urls_copa,
    urls_euro,
    urls_matches,
    urls_squads,
    urls_tournament,
    urls_world,
    dfMatches,
    dfUrls,
    years_copa,
    years_string_copa,
    years_euro,
    years_world
)

