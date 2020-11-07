library(grid)
library(png)
library(ggplot2)
library(gridExtra)

all_images <- list.files(path = '1_cluster')

for(i in 64:length(all_images)){
  pkmn <- all_images[i]
  
  id <- substr(pkmn,1,3)
  shiny <- grepl('(shiny)',pkmn)
  icon <- paste0('pokemon_icon_',id,'_00',ifelse(shiny==TRUE,'_shiny',''),'.png')
  
  images <- c(
    paste0('1_cluster/',pkmn),
    paste0('2_cluster/',pkmn),
    paste0('3_cluster/',pkmn),
    paste0('4_cluster/',pkmn),
    paste0('5_cluster/',pkmn),
    paste0('6_cluster/',pkmn),
    paste0('7_cluster/',pkmn),
    paste0('pokemon_icons/',icon)
  )
  
  plots <- lapply(ll <- images,function(x){
    img <- as.raster(readPNG(x))
    rasterGrob(img, interpolate = FALSE)
  })
  
  ggsave(paste0('cluster_comparison_rails/',substr(pkmn,1,nchar(pkmn)-4),'_clusters.png')
         ,width=40, height=8, 
         marrangeGrob(grobs = plots, nrow=1, ncol=length(images),top=NULL))
  
}


all_rails <- list.files(path = 'cluster_comparison_rails')
rails <- seq(1, length(all_rails)-1, by = 2)

for(i in rails){
  
  images <- c(
    paste0('cluster_comparison_rails/',all_rails[i+1]),
    paste0('cluster_comparison_rails/',all_rails[i])
  )
  plots <- lapply(ll <- images,function(x){
    img <- as.raster(readPNG(x))
    rasterGrob(img, interpolate = FALSE)
  })
  
  name <- substr(all_rails[i+1],1,nchar(all_rails[i+1])-4)
  ggsave(paste0('shiny_comparison_rails/',name,'_shiny_comparison.png')
         ,width=40, height=4, 
         marrangeGrob(grobs = plots, nrow=1, ncol=length(images),top=NULL))
  
}

all_comparison_rails <- list.files(path = 'shiny_comparison_rails')
all_images <- paste0('shiny_comparison_rails/',all_comparison_rails)

plots <- lapply(ll <- all_images,function(x){
  img <- as.raster(readPNG(x))
  rasterGrob(img, interpolate = FALSE)
})

ggsave(paste0('gen1_shiny_comparison.png')
       ,width=4, height=4*length(all_images), 
       marrangeGrob(grobs = plots, nrow=length(all_images), ncol=1,top=NULL))

