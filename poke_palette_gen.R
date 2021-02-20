
library(dplyr)
library(ggplot2)
library(patchwork)
library(png)
library(grid)
library(ggimage)

pkmn_df <- read.csv("data/pkmn_colour_clusters.csv",stringsAsFactors = F)
pkmn_df <- filter(pkmn_df,number_of_clusters == 7)

example_file <- 'pokemon_icon_001_00.png'
example <- filter(pkmn_df,file == example_file)

d=data.frame(x1=c(0,12,12,12,12,0,4,8), x2=c(12,18,18,18,18,4,8,12), y1=c(6,18,14,10,0,0,0,0), y2=c(18,14,10,6,6,6,6,6), t=c('img','a','a','a','squ','a','a','a'), r=c(1:8))
ggplot() + 
  scale_x_continuous(name="x") + 
  scale_y_continuous(name="y") +
  geom_rect(data=d, mapping=aes(xmin=x1, xmax=x2, ymin=y1, ymax=y2, fill=t), color="black", alpha=0.5) +
  geom_text(data=d, aes(x=x1+(x2-x1)/2, y=y1+(y2-y1)/2, label=r), size=4) 
