
# get list of pokemon and matching shiny versions
all_icons <- list.files(path='pokemon_icons')

### Building Data Frame
shiny <- substr(all_icons,nchar(all_icons)-8,nchar(all_icons)-4)=='shiny'
pkmn_id <- substr(all_icons,14,16)
pkmn_variation <- substr(all_icons,17,nchar(all_icons)-4)
pkmn_variation <- ifelse(substr(pkmn_variation,nchar(pkmn_variation),nchar(pkmn_variation))=='y'
                         ,substr(pkmn_variation,0,nchar(pkmn_variation)-6)
                         ,pkmn_variation)

pkmn_df <- data.frame(file=all_icons,shiny_or_not=shiny,id=pkmn_id,variation=pkmn_variation,stringsAsFactors = F)
write.csv(pkmn_df,"data/pkmn_image_index.csv",row.names = F)
