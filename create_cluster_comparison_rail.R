library(grid)
library(png)

images <- c(
  '1_cluster/050_Diglett (shiny).png',
  '2_cluster/050_Diglett (shiny).png',
  '3_cluster/050_Diglett (shiny).png',
  '4_cluster/050_Diglett (shiny).png',
  '5_cluster/050_Diglett (shiny).png',
  '6_cluster/050_Diglett (shiny).png',
  '7_cluster/050_Diglett (shiny).png',
  'pokemon_icons/pokemon_icon_050_00_shiny.png'
)
plots <- lapply(ll <- images,function(x){
  img <- as.raster(readPNG(x))
  rasterGrob(img, interpolate = FALSE)
})

#plots <- lapply(ll <- list.files(patt='.*[.]png'),function(x){
#  img <- as.raster(readPNG(x))
#  rasterGrob(img, interpolate = FALSE)
#})

library(ggplot2)
library(gridExtra)


ggsave("cluster_comparison_rails/050_Diglett (shiny)_clusters.pdf",width=40, height=8, 
       marrangeGrob(grobs = plots, nrow=1, ncol=length(images),top=NULL))

ggsave("cluster_comparison_rails/050_Diglett (shiny)_clusters.png",width=40, height=8, 
       marrangeGrob(grobs = plots, nrow=1, ncol=length(images),top=NULL))


images <- c(
  'cluster_comparison_rails/143_Snorlax_clusters.png',
  'cluster_comparison_rails/143_Snorlax (shiny)_clusters.png'
)
plots <- lapply(ll <- images,function(x){
  img <- as.raster(readPNG(x))
  rasterGrob(img, interpolate = FALSE)
})

#plots <- lapply(ll <- list.files(patt='.*[.]png'),function(x){
#  img <- as.raster(readPNG(x))
#  rasterGrob(img, interpolate = FALSE)
#})

library(ggplot2)
library(gridExtra)


ggsave("143_Snorlax_shiny_comparison.pdf",width=40, height=16, 
       marrangeGrob(grobs = plots, nrow=length(images), ncol=1,top=NULL))

ggsave("143_Snorlax_shiny_comparison.png",width=40, height=16, 
       marrangeGrob(grobs = plots, nrow=length(images), ncol=1,top=NULL))