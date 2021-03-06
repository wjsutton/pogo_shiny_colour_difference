library(tidyverse)
library(imager) 
library(treemap) 
library(ggvoronoi)

images <- read.csv("data/png_to_jpeg.csv",stringsAsFactors = F)
jpegs <- images$jpeg


for(i in 1:length(jpegs)){
#for(i in 1:100){
  test_img <- paste0("jpegs/",jpegs[i])
  im <- load.image(test_img)
  
  df_size <- dim(im)[1]*dim(im)[2]  ## numbers of row I'd get if i use it as it is...
  max_row_num <- 150000 ## number of maximum row I want (just to limit my size!)
  ## If df is too big, it's too slow to process on my computer, so shrink the image
  shrink_ratio  <- if(df_size > max_row_num) {max_row_num / df_size } else {1}
  im <- im %>% imresize(shrink_ratio)
  # plot(im) if you want to check how the image has been resized.
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
  
  ## Pick k value to run kMean althorithm.
  ## But to extract colours, I'd pick k as number I want back! 
  my_k <- 3
  
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
  
  ## I can also save the colour palette for future use as well.
  image_colours <- kmean_center$group_hex
  image_count <- kmean_center$n

  jpeg_and_colours <- data.frame(jpeg_img=jpegs[i]
                                 ,colour_1=image_colours[1]
                                 ,colour_2=image_colours[2]
                                 ,colour_3=image_colours[3]
                                 ,colour_1_count=image_count[1]
                                 ,colour_2_count=image_count[2]
                                 ,colour_3_count=image_count[3]
                                 ,stringsAsFactors = F)
  
  if(i == 1){
    output <- jpeg_and_colours
  }
  
  if(i != 1){
    output <- rbind(output,jpeg_and_colours)
  }
  
  if(i %% 25 == 0){
    print(paste0(i," done."))
  }
}

write.csv(output,"data/jpeg_main_colours.csv",row.names = F)

