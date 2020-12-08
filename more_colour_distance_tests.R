library(dplyr)

pkmn_colour_clusters <- read.csv("data/pkmn_colour_clusters.csv",stringsAsFactors = F)
single_cluster <- pkmn_colour_clusters %>% filter(number_of_clusters==1)

shiny_pkmn <- filter(single_cluster,shiny_or_not==TRUE)
non_shiny_pkmn <- filter(single_cluster,shiny_or_not==FALSE)

comparison <- inner_join(non_shiny_pkmn,shiny_pkmn, by = c("id" = "id"))

# .x = non_shiny
# .y = shiny

comparison$distance <- sqrt(
  (comparison$red.x - comparison$red.y)^2
  + (comparison$green.x - comparison$green.y)^2
  + (comparison$blue.x - comparison$blue.y)^2
)

gen_1 <- filter(comparison,generation.x == 1)

head(arrange(gen_1[,c(7,32)],-distance),25)

output_df <- comparison[,c(1,3,6,7,8,10:12,25:27,32)]
names(output_df) <- c('non_shiny_file','id','pokedex_number','name','generation',
                      'red_non_shiny','green_non_shiny','blue_non_shiny',
                      'red_shiny','green_shiny','blue_shiny','colour_distance')

pkmn_metadata <- read.csv("data/pokemon.csv",stringsAsFactors = F)
pkmn_metadata <- pkmn_metadata[,c('pokedex_number','type1','type2')]

output_df <- inner_join(output_df,pkmn_metadata,by = c( 'pokedex_number'= 'pokedex_number'))

write.csv(output_df,"pokemon_colour_distance_for_tableau.csv",row.names = F)
