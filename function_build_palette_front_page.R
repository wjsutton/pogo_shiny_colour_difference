library(dplyr)
library(ggplot2)
library(patchwork)
library(png)
library(grid)
library(ggimage)
library(showtext)
library(tools)

# https://fonts.google.com/featured/Superfamilies
font_add_google("Montserrat", "Montserrat")
myFont1 <- "Montserrat"
font_families()
showtext_auto()
print("fonts loaded.")


build_palette_front_page <- function(pkmn_file,treemap_folder,output_folder){
  
  # read in datasets
  pkmn_df <- read.csv("data/pkmn_colour_clusters.csv",stringsAsFactors = F)
  meta_df <- read.csv("data/pokemon.csv",stringsAsFactors = F)
  
  # filter to cluster 7s and include type and gen
  pkmn_df <- filter(pkmn_df,number_of_clusters == 7)
  meta_df <- meta_df[c('pokedex_number','type1','type2','generation')]
  pkmn_df <- inner_join(pkmn_df,meta_df, by = c('id' = 'pokedex_number'))
  
  # reduce to single image
  example <- filter(pkmn_df,file == pkmn_file)
  
  # identify cluster treemap
  #treemap_file <- paste0(substr(pkmn_file,14,17),unique(example$name_with_shiny_stat),'.png')
  treemap_file <- pkmn_file
  
  # read in images
  treemap <- readPNG(paste0(treemap_folder,'/',treemap_file), native = TRUE)
  img <- readPNG(paste0('pokemon_icons/',pkmn_file), native = TRUE)
  
  
  # define variables for image text
  hex <- example$group_hex
  type <- unique(ifelse(example$type2 == ''
                        ,tools::toTitleCase(example$type1)
                        ,paste0(tools::toTitleCase(example$type1),'-',tools::toTitleCase(example$type2))))
  subtitle <- paste0(type,' Type | Gen ',unique(example$generation.x))
  
  p1 <- ggplot() + inset_element(p = treemap,left = 0, bottom = 0,right = 1,top = 1)
  p2 <- ggplot() + inset_element(p = img,left = 0, bottom = 0,right = 1,top = 1)
  p3 <- ggplot() + annotate("rect", xmin = 0, 
                            xmax = 0.5, ymin = 0, ymax = 0.5,fill = 'white') +
    annotate("text", x = 0.01, y = 0.5, label = unique(example$name_with_shiny_stat), hjust = 0, family = myFont1,size = 16) +
    annotate("text", x = 0.01, y = 0.45, label = subtitle, hjust = 0, family = myFont1,size = 11) +
    annotate("text", x = 0.08, y = 0.35, label = hex[1], hjust = 0, family = myFont1, size = 11) +
    annotate("rect", xmin = 0.01, xmax = 0.07, ymin = 0.32, ymax = 0.38,fill = hex[1], color ='black') +
    annotate("text", x = 0.08, y = 0.28, label = hex[2], hjust = 0, family = myFont1, size = 11) +
    annotate("rect", xmin = 0.01, xmax = 0.07, ymin = 0.25, ymax = 0.31,fill = hex[2], color ='black') +
    annotate("text", x = 0.08, y = 0.21, label = hex[3], hjust = 0, family = myFont1, size = 11) +
    annotate("rect", xmin = 0.01, xmax = 0.07, ymin = 0.18, ymax = 0.24,fill = hex[3], color ='black') +
    annotate("text", x = 0.08, y = 0.14, label = hex[4], hjust = 0, family = myFont1, size = 11) +
    annotate("rect", xmin = 0.01, xmax = 0.07, ymin = 0.11, ymax = 0.17,fill = hex[4], color ='black') +
    annotate("text", x = 0.34, y = 0.35, label = hex[5], hjust = 0, family = myFont1, size = 11) +
    annotate("rect", xmin = 0.27, xmax = 0.33, ymin = 0.32, ymax = 0.38,fill = hex[5], color ='black') +
    annotate("text", x = 0.34, y = 0.28, label = hex[6], hjust = 0, family = myFont1, size = 11) +
    annotate("rect", xmin = 0.27, xmax = 0.33, ymin = 0.25, ymax = 0.31,fill = hex[6], color ='black') +
    annotate("text", x = 0.34, y = 0.21, label = hex[7], hjust = 0, family = myFont1, size = 11) +
    annotate("rect", xmin = 0.27, xmax = 0.33, ymin = 0.18, ymax = 0.24,fill = hex[7], color ='black') +
    xlim(0,0.5) +
    ylim(0,0.5) +
    theme(
      panel.grid.major = element_blank() 
      ,panel.grid.minor = element_blank() 
      ,panel.background = element_blank() 
      ,axis.ticks.y = element_blank() 
      ,axis.text.y = element_blank() 
      ,axis.title.y = element_blank()
      ,axis.ticks.x = element_blank() 
      ,axis.text.x  = element_blank() 
      ,axis.title.x = element_blank() 
    ) 
  
  #output_file <- pkmn_file
  output_file <- paste0(substr(pkmn_file,1,nchar(pkmn_file)-4),'_p0.png')
  output <- p1 + (p2 / p3)
  
  ggsave(paste0(output_folder,"/",output_file)
         ,plot = output
         ,width = 5, height = 5, dpi = 300, units = "in") 
  
  
  
}
