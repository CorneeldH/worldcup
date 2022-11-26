# Fork!

This repository is a fork of https://github.com/jfjelstul/worldcup. Please read the full documentation there. 

Basically I changed code to include scraping and aprsing of the European Championship (UEFA EURO) and the Copa América (CONMBEBOL). I did this in the following files. For squad (including manager) data I included the full Copa (except the second tournament in 1959). For match pages (with line-ups etc) I included Copa from 2007, becauase earlier Copa's lack detailed information.

In the original repository there are also a lot of manual improvements and manually added data. It then combines the scraped and manual crafted data and creates a lot of tables in multiple formats.  Since I did not replicate the manual work for EURO and Copa tournaments, I saw no use in trying to adapt the code that combines it and builds all the tables.

Please see the [original repo](https://github.com/jfjelstul/worldcup) for this additional data and code.

I added [renv](https://rstudio.github.io/renv/) to the project. This makes it more easy to run this code in the future. 

Any mistakes are mine, be sure to check very complete readme of the orginal repo. I include here a few sections regarding background and license.


# The Fjelstul World Cup Database

The Fjelstul World Cup Database is a comprehensive database about the FIFA World Cup created by Joshua C. Fjelstul, Ph.D. that covers all `21` World Cup tournaments (1930-2018). The database includes `27` datasets (approximately 1.1 million data points) that cover all aspects of the World Cup. The data has been extensively cleaned and cross-validated. 

Users can use data from the Fjelstul World Cup Database to calculate statistics about teams, players, managers, and referees. Users can also use the data to predict match results. With many units of analysis and opportunities for merging and reshaping data, the database is also an excellent resource for teaching data science skills, especially in `R`.

## The license

The copyright for the original structure and organization of the Fjelstul World Cup Database and for all of the documentation and replication code for the database is owned by Joshua C. Fjelstul, Ph.D.

The Fjelstul World Cup Database and the `worldcup` package are both published under a [CC-BY-SA 4.0 license](https://creativecommons.org/licenses/by-sa/4.0/legalcode). This means that you can distribute, modify, and use all or part of the database for commercial or non-commercial purposes as long as (1) you provide proper attribution and (2) any new works you produce based on this database also carry the CC-BY-SA 4.0 license. 

To provide proper attribution, according to the CC-BY-SA 4.0 license, you must provide the name of the author ("Joshua C. Fjelstul, Ph.D."), a notice that the database is copyrighted ("© 2022 Joshua C. Fjelstul, Ph.D."), a link to the CC-BY-SA 4.0 license (https://creativecommons.org/licenses/by-sa/4.0/legalcode), and a link to this repository (https://www.github.com/jfjelstul/worldcup). You must also indicate any modifications you have made to the database.

Consistent with the CC-BY-SA 4.0 license, I provide this database as-is and as-available, and make no representations or warranties of any kind concerning the database, whether express, implied, statutory, or other. This includes, without limitation, warranties of title, merchantability, fitness for a particular purpose, non-infringement, absence of latent or other defects, accuracy, or the presence or absence of errors, whether or not known or discoverable. 

## Data sources and replication code

(Shortened, see original repo for full explanation).

The replication code for downloading the Wikipedia pages used to code the database is available in `data-raw/code/download-wikipedia-pages.R`. The replication code for extracting data from these pages is also available in `data-raw/code/`. The file `data-raw/code/parse-wikipedia-match-pages.R` extracts data from the match pages in `data-raw/Wikipedia-match-pages/` and the file `data-raw/code/parse-wikipedia-squad-pages.R` extracts data from the squad pages in `data-raw/Wikipedia-squad-pages/`. The working files produced by this code are stored in `data-raw/Wikipedia-data/`.

## Citating the database

If you use the database in a paper or project, please cite the database:

> Fjelstul, Joshua C. "The Fjelstul World Cup Database v.1.0." July 8, 2022. https://www.github.com/jfjelstul/worldcup.

The `BibTeX` entry for the database is:

```
@Manual{Fjelstul2022,
  author = {Fjelstul, Joshua C.},
  title = {The Fjelstul World Cup Database v.1.0},
  year = {2022}
}
```

If you access the database via the `worldcup` package, please also cite the package:

> Joshua C. Fjelstul (2022). worldcup: The Fjelstul World Cup Database. R package version 0.1.0.

The `BibTeX` entry for the `R` package is:

```
@Manual{,
  title = {worldcup: The Fjelstul World Cup Database},
  author = {Fjelstul, Joshua C.},
  year = {2022},
  note = {R package version 0.1.0},
}
```

