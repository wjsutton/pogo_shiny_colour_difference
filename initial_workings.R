
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

### Testing packages

#install.packages("colorfindr")
library(colorfindr)

test_img <- paste0("pokemon_icons/",pkmn_df$file[2])
colorfindr::get_colors(test_img)
# returns a list of 2000+ colours, most of them very similar hex codes
# need to find a list of distinct colours

# try:
# https://www.r-bloggers.com/2018/11/utilizing-k-means-to-extract-colours-from-your-favourite-images/