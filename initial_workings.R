
### To Do
# Split up process:
# - make data frame of images
# - convert images from png to jpeg
# - build clusters & exclude white
# - build output dataset 

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

#install.packages("imager")
library(tidyverse)
library(imager) 
library(treemap) 
library(ggvoronoi)


test_img <- paste0("pokemon_icons/",pkmn_df$file[7])


im <- load.image(test_img)
#plot(im, main="Original Image I Want To Get Some Colours Out Of!")

# converting to 3 colour channels
im <-  rm.alpha(im)



### To fix. Now done.
plot(im)
# plot(im) shows colour lines extended rather than leaving image transparent 
# might be issues related to reading in png files


library(png)
test_img <- paste0("pokemon_icons/",pkmn_df$file[7])
img <- readPNG(test_img)
library("jpeg")
writeJPEG(img, target = "Converted.jpeg", quality = 1)

test_jpeg <- "Converted.jpeg"
im <- load.image(test_jpeg)
im2 <- load.image(test_img)
plot(im2)
plot(im)

## Workflow to retrieve 3 distinct colours from image

test_img <- paste0("pokemon_icons/",pkmn_df$file[7])
im <- load.image(test_img)
# converting to 3 colour channels
im <-  rm.alpha(im)

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
  inner_join(im_gray)


## Pick k value to run kMean althorithm.
## But to extract colours, I'd pick k as number I want back! 
my_k <- 4

## Running kmeans algorithm on red, green and blue value to gather similar colour together
kmean_rgb <- kmeans(im_df %>% select(red,green,blue), centers=my_k)

## append cluster id to im_df datasets.
im_df$cluster_num <- kmean_rgb$cluster

## center values can be used as cluster colour! 
kmean_center <- kmean_rgb$centers %>% as.data.frame() %>% 
  mutate(group_hex = rgb(red,green,blue), cluster_num = row_number()) %>%
  inner_join(im_df %>% count(cluster_num))

## I can also save the colour palette for future use as well.
my_colour <- kmean_center$group_hex
my_colour





