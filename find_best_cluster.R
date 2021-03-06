library(tidyverse)
library(imager) 
library(treemap) 
library(ggvoronoi)
library(mclust)

set.seed(1)
start_time <- Sys.time()

#colours <- read.csv("data/jpeg_main_colours.csv",stringsAsFactors = F)
pkmn_index <- read.csv("data/pkmn_image_index.csv",stringsAsFactors = F)
pkmn_meta <- read.csv("data/pokemon.csv",stringsAsFactors = F)
png2jpeg <- read.csv("data/png_to_jpeg.csv",stringsAsFactors = F)

pkmn_meta <- pkmn_meta %>% select(c(pokedex_number,name,generation))
pkmn_meta$id <- ifelse(pkmn_meta$pokedex_number<10,paste0('00',pkmn_meta$pokedex_number)
                       ,(ifelse(pkmn_meta$pokedex_number<100,paste0('0',pkmn_meta$pokedex_number)
                                ,pkmn_meta$pokedex_number)))

# just original pkmn
pkmn_index <- pkmn_index %>% filter(variation == '_00')

pkmn_df <- inner_join(pkmn_index,png2jpeg, by = c("file" = "png"))
pkmn_df <- inner_join(pkmn_df,pkmn_meta, by = c("id" = "id"))

pkmn_df$name_with_shiny_stat <- ifelse(pkmn_df$shiny_or_not==TRUE
                                       ,paste0(pkmn_df$name," (shiny)")
                                       ,pkmn_df$name)


for(i in 1:length(pkmn_df$jpeg)){
  test_img <- paste0("jpegs/",pkmn_df$jpeg[i])
  im <- load.image(test_img)
  
  df_size <- dim(im)[1]*dim(im)[2]  ## numbers of row I'd get if i use it as it is...
  max_row_num <- 150000 ## number of maximum row I want (just to limit my size!)
  
  ## If df is too big, it's too slow to process on my computer, so shrink the image
  shrink_ratio  <- if(df_size > max_row_num) {max_row_num / df_size } else {1}
  im <- im %>% imresize(shrink_ratio)
  
  ## get RGB value at each pixel
  im_rgb <- im %>% 
    as.data.frame(wide="c") %>%
    rename(red=c.1,green=c.2,blue=c.3) %>%
    mutate(hexvalue = rgb(red,green,blue)) ## you can create hexvalue using red, green blue value!
  
  ## turn image into Grayscale and get luminance "value" too. 
  im_gray <- im %>%
    grayscale() %>%
    as.data.frame() 
  
  ## combine RGB info and Luminance Value Dataset together.
  im_df <- im_rgb %>% 
    inner_join(im_gray, by = c("x", "y"))
  
  # Remove white shades
  im_df <- subset(im_df,!(substr(hexvalue,1,2) %in% c('#F','#E')))
  
  # library(NbClust)
  d_clust <- Mclust(as.matrix(im_df %>% select(red,green,blue)), G=1:7)
  m.best <- dim(d_clust$z)[2]
  cat("model-based optimal number of clusters:", m.best, "\n")
  best_cluster <- m.best
  
  output <- pkmn_df[i,]
  output$best_cluster <- best_cluster
  #output$best_cluster_pc <- best_cluster_pc
  
  if(i == 1){
    output_df <- output
  }
  
  if(i != 1){
    output_df <- rbind(output_df,output)
  }
}

write.csv(output_df,"data/pkmn_best_cluster.csv",row.names = F)
