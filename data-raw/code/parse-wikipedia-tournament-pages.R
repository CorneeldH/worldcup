
# Packages

library(rvest)
library(tidyverse)

# Function to extract host countries -------------------------------------------

extract_host <- function(file) {
    host <- read_html(file) %>%
        html_element(xpath = '//*[@class="infobox-data"]')  %>%
        html_text() %>%
        str_squish() %>%
        # Tournaments with no specific host get NA
        ifelse(str_detect(., "[0-9]{2}"), NA_character_, .) %>%
        # Separate the names if there is more than one host
        str_replace_all("((?<=[a-z])[A-Z])", ", \\1") 
    
    return(host)
}


# Get a list of files
files <- list.files("data-raw/Wikipedia-tournament-pages", full.names = TRUE) 

wikipedia_hosts <- files %>% 
    # Put files in a dataframe
    enframe(., name = NULL, value = "file") %>%
    # Add variables
    mutate(host = map_chr(file, extract_host), 
           year = str_extract(file, "[0-9]{4}"),
           tournament = str_extract(file, "(copa|euro|world)")
    )

# Save data
write_rds(wikipedia_hosts, file = "data-raw/Wikipedia-data/wikipedia_hosts.rds")
