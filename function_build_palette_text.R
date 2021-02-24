
library(dplyr)

build_palette_text <- function(pkmn_file,output_folder){
  
  pkmn_df <- read.csv("data/pkmn_colour_clusters.csv",stringsAsFactors = F)
  meta_df <- read.csv("data/pokemon.csv",stringsAsFactors = F)
  
  # filter to cluster 7s and include type and gen
  pkmn_df <- filter(pkmn_df,number_of_clusters == 7)
  meta_df <- meta_df[c('pokedex_number','type1','type2','generation','classfication')]
  pkmn_df <- inner_join(pkmn_df,meta_df, by = c('id' = 'pokedex_number'))
  
  # reduce to single image
  example <- filter(pkmn_df,file == pkmn_file)
  
  hex <- example$group_hex
  type <- unique(ifelse(example$type2 == ''
                        ,tools::toTitleCase(example$type1)
                        ,paste0(tools::toTitleCase(example$type1),'-',tools::toTitleCase(example$type2))))
  subtitle <- paste0(type,' Type | Gen ',unique(example$generation.x))
  name <- unique(example$name_with_shiny_stat)
  classification <- gsub('Ã©','e',unique(example$classfication))
  
  hex <- gsub('#','',hex)
  hex_string <- paste(hex,collapse = ' - ')
  
  block <- 'Taking #colorinspiration from #pokemon, follow @poke_palettes for more #colorpalettes'
  
  text <- paste0(name,", the ",classification,"\n",subtitle,"\n","\n",'Colors:',"\n",hex_string,"\n","\n",block)
  
  file_name <- paste0(substr(pkmn_file,1,nchar(pkmn_file)-4),'_text.txt')
  
  fileConn <- file(paste0(output_folder,"/",file_name))
  writeLines(text, fileConn)
  close(fileConn)
  
}