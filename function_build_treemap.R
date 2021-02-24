library(treemap)
library(dplyr)

build_treemap <- function(pkmn_file,pkmn_clusters,output_folder,output_height,output_width){
  
  treemap_df <- read.csv("data/pkmn_colour_clusters.csv",stringsAsFactors = F)
  treemap_df$pokedex_id <- ifelse(treemap_df$id<10,paste0('00',treemap_df$id)
                                  ,(ifelse(treemap_df$id<100,paste0('0',treemap_df$id)
                                           ,treemap_df$id)))
  
  pkmn <- filter(treemap_df,file == pkmn_file & number_of_clusters == pkmn_clusters)
  
  # Create data
  name <- unique(pkmn$name_with_shiny_stat)
  pokedex <- unique(pkmn$pokedex_id)
  group <- pkmn$group_hex
  value <- pkmn$n
  data <- data.frame(group,value)
  
  
  ## treemap without name
  png(filename=paste0(output_folder,"/",pkmn_file),width=output_width, height=output_height)
  t2 <- treemap(data,
                index="group",
                vColor = "group",
                vSize="value",
                type="color",
                fontsize.labels=0,
                fontsize.title=0,
                title=name)
  dev.off()
  
}