library(treemap)
library(dplyr)

treemap_df <- read.csv("data/pkmn_colour_clusters.csv",stringsAsFactors = F)
treemap_df$pokedex_id <- ifelse(treemap_df$id<10,paste0('00',treemap_df$id)
                                ,(ifelse(treemap_df$id<100,paste0('0',treemap_df$id)
                                ,treemap_df$id)))

# Delete old files
existing_images <- c(
  paste0('palette_clusters/',list.files(path='palette_clusters'))
)
file.remove(existing_images)

# List of all pkmn (shiny and not)
gen_1 <- filter(treemap_df,generation == 1)
all_pkmn <- unique(gen_1$file)

#for(i in 1:length(all_pkmn)){
for(i in 1:20){
  
  # filter to 1 pkmn
  pkmn <- filter(gen_1,file == all_pkmn[i])
  
    
  pkmn_clust <- filter(pkmn,number_of_clusters == 7)
    
  # Create data
  name <- unique(pkmn_clust$name_with_shiny_stat)
  pokedex <- unique(pkmn_clust$pokedex_id)
  group <- pkmn_clust$group_hex
  value <- pkmn_clust$n
  data <- data.frame(group,value)
  
  ## treemap without name
  png(filename=paste0("palette_clusters/",pokedex,"_",name,".png"),width=500, height=950)
  t2 <- treemap(data,
                index="group",
                vColor = "group",
                vSize="value",
                type="color",
                fontsize.labels=0,
                fontsize.title=0,
                title=name)
  dev.off()

  
  if(i %% 25 == 0){
    print(paste0(i," done."))
  }
  
}



