library(treemap)
library(dplyr)

treemap_df <- read.csv("data/pkmn_colour_clusters.csv",stringsAsFactors = F)
treemap_df$pokedex_id <- ifelse(treemap_df$id<10,paste0('00',treemap_df$id)
                                ,(ifelse(treemap_df$id<100,paste0('0',treemap_df$id)
                                ,treemap_df$id)))

# Delete old files
existing_images <- c(
  paste0('1_cluster/',list.files(path='1_cluster')),
  paste0('2_cluster/',list.files(path='2_cluster')),
  paste0('3_cluster/',list.files(path='3_cluster')),
  paste0('4_cluster/',list.files(path='4_cluster')),
  paste0('5_cluster/',list.files(path='5_cluster')),
  paste0('6_cluster/',list.files(path='6_cluster')),
  paste0('7_cluster/',list.files(path='7_cluster'))
)
file.remove(existing_images)

# List of all pkmn (shniy and not)
all_pkmn <- unique(treemap_df$file)

for(i in 1:length(all_pkmn)){
  
  # filter to 1 pkmn
  pkmn <- filter(treemap_df,file == all_pkmn[i])
  
  for(k in 1:7){
    
    pkmn_clust <- filter(pkmn,number_of_clusters == k)
    
    # Create data
    name <- unique(pkmn_clust$name_with_shiny_stat)
    pokedex <- unique(pkmn_clust$pokedex_id)
    group <- pkmn_clust$group_hex
    value <- pkmn_clust$n
    data <- data.frame(group,value)
    
    # treemap
    png(filename=paste0(k,"_cluster/",pokedex,"_",name,".png"),width=500, height=800)
    t1 <- treemap(data,
                  index="group",
                  vColor = "group",
                  vSize="value",
                  type="color",
                  fontsize.labels=0,
                  title=name)
    dev.off()
    
    png(filename=paste0(k,"_cluster/",pokedex,"_",name,"_no_titles.png"),width=500, height=800)
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
  
  if(i %% 25 == 0){
    print(paste0(i," done."))
  }
  
}



