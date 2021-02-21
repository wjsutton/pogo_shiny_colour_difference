
library(dplyr)
library(ggplot2)
library(patchwork)
library(png)
library(grid)
library(ggimage)
library(showtext)

# https://fonts.google.com/featured/Superfamilies
font_add_google("Montserrat", "Montserrat")
font_add_google("Roboto", "Roboto")
myFont1 <- "Montserrat"
myFont2 <- "Roboto"
font_families()
showtext_auto()

pkmn_df <- read.csv("data/pkmn_colour_clusters.csv",stringsAsFactors = F)
pkmn_df <- filter(pkmn_df,number_of_clusters == 7)
#unique(filter(pkmn_df,nchar(name_with_shiny_stat)==18)$file)
#example_file <- 'pokemon_icon_001_00.png'
#example_file <- 'pokemon_icon_047_00_shiny.png'
example_file <- 'pokemon_icon_004_00_shiny.png'
example <- filter(pkmn_df,file == example_file)
max(nchar(pkmn_df$name_with_shiny_stat))

treemap_file <- paste0(substr(example_file,14,17),unique(example$name_with_shiny_stat),'.png')

treemap <- readPNG(paste0('7_cluster/',treemap_file), native = TRUE)
img <- readPNG(paste0('pokemon_icons/',example_file), native = TRUE)

hex <- example$group_hex

p1 <- ggplot() + inset_element(p = treemap,left = 0, bottom = 0,right = 1,top = 1)
p2 <- ggplot() + inset_element(p = img,left = 0, bottom = 0,right = 1,top = 1)
p3 <- ggplot() + annotate("rect", xmin = 0, xmax = 0.5, ymin = 0, ymax = 0.5,fill = 'white') +
  annotate("text", x = 0.01, y = 0.5, label = unique(example$name_with_shiny_stat), hjust = 0, family = myFont1,size = 16) +
  annotate("text", x = 0.01, y = 0.45, label = "Grass/Poison | Gen 1", hjust = 0, family = myFont1,size = 11) +
#  annotate("text", x = 0.05, y = 0.3, label = "Palette", hjust = 0, family = myFont1,size = 8) +
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

output <- p1 + (p2 / p3)
#output


ggsave("poke_pallets/example_palette.png" # filename
       ,plot = output # variable for file
       ,width = 5, height = 5, dpi = 300, units = "in") # dimensions and image quality



#all_images <- list.files(path = '7_cluster')

#for(i in 1:length(all_images)){
#for(i in 1:18){
#  pkmn <- all_images[i]
#  
#  id <- substr(pkmn,1,3)
#  shiny <- grepl('(shiny)',pkmn)
#  icon <- paste0('pokemon_icon_',id,'_00',ifelse(shiny==TRUE,'_shiny',''),'.png')
#  
#  images <- c(
#    paste0('7_cluster/',pkmn),
#    paste0('pokemon_icons/',icon)
#  )
#  
#  plots <- lapply(ll <- images,function(x){
#    img <- as.raster(readPNG(x))
#    rasterGrob(img, interpolate = FALSE)
#  })
#  
#  ggsave(paste0('poke_pallets/',substr(pkmn,1,nchar(pkmn)-4),'_pallet.png')
#         ,width=8, height=8, 
#         marrangeGrob(grobs = plots, nrow=1, ncol=length(images),top=NULL))
#  
#}

































# install.packages('showtext', dependencies = TRUE)





#example <- arrange(example,desc(red*255 + green*255 + blue*255))

#d=data.frame(x1=c(0,12,12,12,12,8,4,0),
#             x2=c(12,18,18,18,18,12,8,4),
#             y1=c(6,18,14,10,0,0,0,0),
#             y2=c(18,14,10,6,6,6,6,6),
#             colour = c('#FFFFFF',example$group_hex),
#             t=c('img','a','a','a','squ','a','a','a'),
#             r=c(1:8))


#ggp <- ggplot() +
#  annotate("rect", xmin = d$x1[1], xmax = d$x2[1], ymin = d$y1[1], ymax = d$y2[1],fill = d$colour[1]) +
#  annotate("rect", xmin = d$x1[2], xmax = d$x2[2], ymin = d$y1[2], ymax = d$y2[2],fill = d$colour[2]) +
#  annotate("rect", xmin = d$x1[3], xmax = d$x2[3], ymin = d$y1[3], ymax = d$y2[3],fill = d$colour[3]) +
#  annotate("rect", xmin = d$x1[4], xmax = d$x2[4], ymin = d$y1[4], ymax = d$y2[4],fill = d$colour[4]) +
#  annotate("rect", xmin = d$x1[5], xmax = d$x2[5], ymin = d$y1[5], ymax = d$y2[5],fill = d$colour[5]) +
#  annotate("rect", xmin = d$x1[6], xmax = d$x2[6], ymin = d$y1[6], ymax = d$y2[6],fill = d$colour[6]) +
#  annotate("rect", xmin = d$x1[7], xmax = d$x2[7], ymin = d$y1[7], ymax = d$y2[7],fill = d$colour[7]) +
#  annotate("rect", xmin = d$x1[8], xmax = d$x2[8], ymin = d$y1[8], ymax = d$y2[8],fill = d$colour[8]) 



#treemap <- readPNG("7_cluster/002_Ivysaur.png", native = TRUE)
#img <- readPNG('pokemon_icons/pokemon_icon_002_00.png', native = TRUE)


#ggp_image <- ggp +                  
#  inset_element(p = img,
#                left = 0,
#                bottom = 2/3,
#                right = 2/3,
#                top = 1)
#ggp_image 


#library(grid)
#library(png)
#library(ggplot2)
#library(gridExtra)



#img <- readPNG('poke_pallets/006_Charizard_pallet.png', native = TRUE)
#
#ggp <- ggplot() +
#  annotate("rect", xmin = 0, xmax = 0.5, ymin = 0, ymax = 0.5,fill = 'blue')

#ggp_image <- ggp +                  
#  inset_element(p = img,
#                left = 0,
#                bottom = 0,
#                right = 1,
#                top = 1) +
#  annotate("text", x = 0.3, y = 0.45, label = "Some text") +
#  annotate("text", x = 2, y = 3, label = "Some text")
#ggp_image 

#library(magick)

#char <- image_read("poke_pallets/006_Charizard_pallet.png")
#pallet <- image_read("7_cluster/006_Charizard.png")
#icon <- image_read("pokemon_icons/pokemon_icon_006_00.png")

#qplot(speed, dist, data = cars, geom = c("point", "smooth"))
#grid.raster(pallet)
#grid.arrange(p1, p2, nrow = 1)

#grid.arrange(pallet, icon, nrow = 1)

#library(patchwork)


#layout <- "
#AB
#AC
#"

#p1 + p2 + p3 + 
#  plot_layout(design = layout, widths = c(5,3,3))

#ggplot() + 
#  scale_x_continuous(name="x") + 
#  scale_y_continuous(name="y") +
#  geom_rect(data=d, mapping=aes(xmin=x1, xmax=x2, ymin=y1, ymax=y2, fill='blue'), color="black") +
#  geom_text(data=d, aes(x=x1+(x2-x1)/2, y=y1+(y2-y1)/2, label=r), size=4) +
#  scale_fill_manual(values = d$colour)

#ggplot(df, aes(x, y)) +
#  geom_tile(aes(fill = z), colour = "grey50")