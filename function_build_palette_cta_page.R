# call to action page

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


build_palette_cta_page <- function(pkmn_file,output_folder){
  
  # read in images
  img <- readPNG(paste0('pokemon_icons/',pkmn_file), native = TRUE)
  
  p2 <- ggplot() + inset_element(p = img,left = 0, bottom = 0,right = 1,top = 1)
  p5 <- ggplot() + 
    annotate("rect", xmin = 0, xmax = 1, ymin = 0, ymax = 1,fill = 'white') +
    annotate("text", x = 0.5, y = 0.9, label = 'Thank You!', family = myFont1,size = 32) +
    annotate("text", x = 0.5, y = 0.75, label = 'Follow me for future posts', family = myFont1,size = 16) +
    annotate("text", x = 0.67, y = 0, label = 'Save this palette', hjust = 0, family = myFont1,size = 12) +
    #annotate("text", x = 0.96, y = 0.005, label = ' ↓', hjust = 0, family = myFont1,size = 22) +
    annotate("text", x = 0.96, y = 0.005, label = ' \u2193', hjust = 0, family = myFont1,size = 22) +
    xlim(0,1) +
    ylim(0,1) +
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
  
  output <- (p2 / p5)
  output_file <- paste0(substr(pkmn_file,1,nchar(pkmn_file)-4),'_p8.png')

  ggsave(paste0(output_folder,"/",output_file)
        ,plot = output
        ,width = 5, height = 5, dpi = 300, units = "in") 
  
}
