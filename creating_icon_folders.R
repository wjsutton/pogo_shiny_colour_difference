# create seperate pkmn icon folders for ease of building in Tableau
library(stringr)

pkmn <- read.csv("data/pokemon_colour_distance_for_tableau.csv",stringsAsFactors = F)
pkmn$pokedex_number_text <- str_sub(paste0('000',pkmn$pokedex_number),-3,-1)

# clear existing files
non_shiny_files <- list.files('non_shiny_pkmn_icons')
shiny_files <- list.files('shiny_pkmn_icons')
file.remove(paste0('non_shiny_pkmn_icons/',non_shiny_files))
file.remove(paste0('shiny_pkmn_icons/',shiny_files))

# Non-shiny pkmn folder
file.copy(from = paste0('pokemon_icons/',pkmn$non_shiny_file)
          ,to = paste0('non_shiny_pkmn_icons/',pkmn$pokedex_number_text,".png"))


# Shiny pkmn folder
file.copy(from = paste0('pokemon_icons/',substr(pkmn$non_shiny_file,1,19),"_shiny.png")
          ,to = paste0('shiny_pkmn_icons/',pkmn$pokedex_number_text,".png"))

