
### Convert pngs to jpegs

# Load Libraries
library(png)
library("jpeg")

# Read index
pkmn_index <- read.csv("data/pkmn_image_index.csv",stringsAsFactors = F)

file_and_path <- paste0("pokemon_icons/",pkmn_index$file) 
file_name <- substr(pkmn_index$file,1,nchar(pkmn_index$file)-4)
pkmn_index$jpeg_file <- paste0(file_name,".jpeg")
  
for(i in 1:length(file_and_path)){
  
  img <- readPNG(file_and_path[i])
  target_img <- paste0("jpegs/",file_name[i],".jpeg")
  writeJPEG(img, target = target_img, quality = 1)
  if(i %% 25 == 0){
    print(paste0(i," done."))
  }
}

png_to_jpeg <- data.frame(png=pkmn_index$file,jpeg=pkmn_index$jpeg_file,stringsAsFactors = F)
write.csv(png_to_jpeg,"data/png_to_jpeg.csv",row.names = F)
