library(dplyr)
library(ggplot2)
library(showtext)
library(tools)

source("coloratio.R")
source("callierr.R")
source("colourname.R")
source("rgb2cmyk.R")

# https://fonts.google.com/featured/Superfamilies
font_add_google("Montserrat", "Montserrat")
myFont1 <- "Montserrat"
font_families()
showtext_auto()
print("fonts loaded.")


build_palette_interval_page <- function(pkmn_file,pkmn_clusters,output_folder){
  
  treemap_df <- read.csv("data/pkmn_colour_clusters.csv",stringsAsFactors = F)
  treemap_df$pokedex_id <- ifelse(treemap_df$id<10,paste0('00',treemap_df$id)
                                  ,(ifelse(treemap_df$id<100,paste0('0',treemap_df$id)
                                           ,treemap_df$id)))
  
  pkmn <- filter(treemap_df,file == pkmn_file & number_of_clusters == pkmn_clusters)
  
  for(i in 1:nrow(pkmn)){
    
    hex <- pkmn$group_hex[i]
    rgb <- as.rgb(hex)
    rgb_text <- paste0(rgb[1],', ',rgb[2],', ',rgb[3])
    hsl <- as.hsl(hex)
    hsl_text <- paste0(hsl[1],', ',hsl[2]*100,'%, ',hsl[3]*100,'%')
    cmyk <- rgb2cmyk(r = rgb[1],g = rgb[2], b = rgb[3])
    cmyk <- round(cmyk*100,0)
    cmyk_text <- paste0(cmyk[1],'%, ',cmyk[2],'%, ',cmyk[3],'%, ',cmyk[4],'%')
    colour_name <- tools::toTitleCase(names(rgb2col(r = rgb[1],g = rgb[2], b = rgb[3]))[1])
    text_colour <- cr_choose_bw(hex)
    alt_text_colour <- ifelse(text_colour=='black','white','black')
    
    p4 <- ggplot() + 
      annotate("rect", xmin = 0, xmax = 1, ymin = 0, ymax = 1,fill = hex) +
      annotate("rect", xmin = 0.1, xmax = 0.9, ymin = 0.1, ymax = 0.9,fill = text_colour) +
      annotate("rect", xmin = 0.11, xmax = 0.89, ymin = 0.3, ymax = 0.89,fill = hex) +
      annotate("text", x = 0.15, y = 0.2, label = colour_name, hjust = 0, family = myFont1, size = 32,color = alt_text_colour) +
      annotate("text", x = 0.20, y = 0.75, label = 'HEX', hjust = 0, family = myFont1, size = 11,color = text_colour) +
      annotate("text", x = 0.20, y = 0.70, label = hex, hjust = 0, family = myFont1, size = 11,color = text_colour) +
      annotate("text", x = 0.20, y = 0.5, label = 'HSL', hjust = 0, family = myFont1, size = 11,color = text_colour) +
      annotate("text", x = 0.20, y = 0.45, label = hsl_text, hjust = 0, family = myFont1, size = 11,color = text_colour) +
      annotate("text", x = 0.55, y = 0.75, label = 'RGB', hjust = 0, family = myFont1, size = 11,color = text_colour) +
      annotate("text", x = 0.55, y = 0.70, label = rgb_text, hjust = 0, family = myFont1, size = 11,color = text_colour) +
      annotate("text", x = 0.55, y = 0.5, label = 'CMYK', hjust = 0, family = myFont1, size = 11,color = text_colour) +
      annotate("text", x = 0.55, y = 0.45, label = cmyk_text, hjust = 0, family = myFont1, size = 11,color = text_colour) +
      #  xlim(0,1) +
      #  ylim(0,1) +
      scale_x_continuous(limits = c(0,1), expand = c(0, 0)) +
      scale_y_continuous(limits = c(0,1), expand = c(0, 0)) +
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
    
    file_name <- paste0(substr(pkmn_file,1,nchar(pkmn_file)-4),'_p',i,'.png')
    
    ggsave(paste0(output_folder,"/",file_name)
           ,plot = p4
           ,width = 5, height = 5, dpi = 300, units = "in") 
    
  }
  
}
