library(tidyverse)
library(imager) 
library(treemap) 
library(ggvoronoi)

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

i <- 157
  
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

## Pick k value to run kMean althorithm.
## But to extract colours, I'd pick k as number I want back! 
for(k in 1:7){
  my_k <- k
  
  ## Running kmeans algorithm on red, green and blue value to gather similar colour together
  kmean_rgb <- kmeans(im_df %>% select(red,green,blue), centers=my_k)
  
  ## append cluster id to im_df datasets.
  im_df$cluster_num <- kmean_rgb$cluster
  
  ## center values can be used as cluster colour! 
  kmean_center <- kmean_rgb$centers %>% as.data.frame() %>% 
    mutate(group_hex = rgb(red,green,blue), cluster_num = row_number()) %>%
    inner_join(im_df %>% count(cluster_num), by = c("cluster_num" = "cluster_num"))
  
  # reorder clusters
  kmean_center <- arrange(kmean_center,-n)
  kmean_center$number_of_clusters <- my_k
  kmean_center$total_ss <- kmean_rgb$tot.withinss
  
  output <- cbind(pkmn_df[i,],kmean_center)
  
  #if(paste0(i,"-",k) == '1-1'){
  #  output_df <- output
  #}
  #if(paste0(i,"-",k) != '1-1'){
  #  output_df <- rbind(output_df,output)
  #}
  if(k == 1){
    output_df <- output
  }
  if(k != 1){
    output_df <- rbind(output_df,output)
  }
}

library(ggplot2)
chart_df <- unique(output_df[,16:17])

lineplot <- ggplot(chart_df, aes(x=number_of_clusters, y=total_ss)) +
  geom_area(fill=output_df$group_hex[1], alpha = 0.4) +
  geom_line(color=output_df$group_hex[1], size=1) +
  geom_point(color=output_df$group_hex[1], size=3) +
  theme(
    panel.grid.major = element_blank() # Remove gridlines (major)
    ,panel.grid.minor = element_blank() # Remove gridlines (minor)
    ,panel.background = element_blank() # Remove grey background
    ,plot.title = element_text(hjust = 0, size = 20, colour = "#323232") # Title size and colour
    ,plot.subtitle = element_text(hjust = 0, size = 12, colour = "#323232") # Subtitle size and colour
    ,plot.caption = element_text(vjust = 0.3, size = 12, colour = "#323232") # Caption size and colour
    ,axis.ticks.y = element_blank() # Remove tick marks (Y-Axis)
    ,axis.text.y = element_text(hjust = 1, colour = "#323232", size = 12) # Axis size and colour (Y-Axis)
    ,axis.title.y = element_text(size = 12, colour = "#323232") # Axis label size and colour (Y-Axis)
    ,axis.ticks.x = element_blank() # Remove tick marks (X-Axis)
    ,axis.text.x  = element_text(hjust = 1, colour = "#323232", size = 12) # Axis size and colour (X-Axis)
    ,axis.title.x = element_text(size = 12, colour = "#323232") # Axis label size and colour (X-Axis)
  ) +
  labs(title = paste0(unique(output_df$name_with_shiny_stat),' Clusters') # Title text
       ,x = 'Number of clusters K' # X-Axis text 
       ,y = 'Total within-clusters sum of squares' # Y-Axis text 
       )

lineplot
chart_df



library(mclust)
# Run the function to see how many clusters
# it finds to be optimal, set it to search for
# at least 1 model and up 20.
d_clust <- Mclust(as.matrix(im_df %>% select(red,green,blue)), G=1:7)
m.best <- dim(d_clust$z)[2]
cat("model-based optimal number of clusters:", m.best, "\n")


#library(mclust)
#d_clust <- Mclust(as.matrix(im_df %>% select(red,green,blue)), G=1:7, 
#                  modelNames = mclust.options("emModelNames"))
#d_clust$BIC
#plot(d_clust)

#install.packages("NbClust",dependencies = TRUE)
library(NbClust)
nb <- NbClust(im_df %>% select(red,green,blue), diss=NULL, distance = "euclidean", 
              min.nc=4, max.nc=7, method = "kmeans", 
              index = "all", alphaBeale = 0.1)
hist(nb$Best.nc[1,], breaks = max(na.omit(nb$Best.nc[1,])))

df <- as.data.frame(ftable(nb$Best.nc[1,]))
best_cluster <- df[df$Freq == max(table(nb$Best.nc[1,])),]$Var1
# prefer smaller cluster
best_cluster <- as.integer(as.character(best_cluster))
best_cluster <- min(best_cluster)
best_cluster_pc <- best_cluster/sum(df$Freq)

print(paste0("best cluster for ",unique(output_df$name_with_shiny_stat)," is ",best_cluster))
end_time <- Sys.time()
print(paste0("Start time: ",start_time))
print(paste0("End time: ",end_time))
print(end_time - start_time)

