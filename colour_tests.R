install.packages("colortools")
library(colortools)

# analagous scheme for color "#3D6DCC"
analogous(hex[3])

# complementary scheme for color "#3D6DCC"
complementary(hex[3])

# split complementary scheme for color "#3D6DCC"
splitComp(hex[3])

# triadic scheme for color "#3D6DCC"
triadic(hex[3])

# tetradic scheme for color "#3D6DCC"
tetradic(hex[3])

# square scheme for color "#3D6DCC"
square(hex[3])

# sequential colors for "#3D6DCC"
sequential(hex[3])

#install.packages("coloratio")
#library(coloratio)
source("coloratio.R")
source("callierr.R")
source("colourname.R")
source("rgb2cmyk.R")

cr_choose_bw(hex[3])

cr_choose_color(
  col = hex[3],  # user-supplied color
  n = 1,              # number of colors to return
  ex_bw = TRUE        # exclude black, whites, grays?
)

as.rgb(hex[3])
as.hsl(hex[3])
rgb2col(as.rgb(hex[3]))

rgb2col(r = as.rgb(hex[1])[1],g = as.rgb(hex[1])[2], b = as.rgb(hex[1])[3])
rgb2col(r = as.rgb(hex[2])[1],g = as.rgb(hex[2])[2], b = as.rgb(hex[2])[3])
rgb2col(r = as.rgb(hex[3])[1],g = as.rgb(hex[3])[2], b = as.rgb(hex[3])[3])
rgb2col(r = as.rgb(hex[4])[1],g = as.rgb(hex[4])[2], b = as.rgb(hex[4])[3])
rgb2col(r = as.rgb(hex[5])[1],g = as.rgb(hex[5])[2], b = as.rgb(hex[5])[3])
rgb2col(r = as.rgb(hex[6])[1],g = as.rgb(hex[6])[2], b = as.rgb(hex[6])[3])
rgb2col(r = as.rgb(hex[7])[1],g = as.rgb(hex[7])[2], b = as.rgb(hex[7])[3])

names(rgb2col(r = as.rgb(hex[7])[1],g = as.rgb(hex[7])[2], b = as.rgb(hex[7])[3]))
rgb2cmyk(r = as.rgb(hex[7])[1],g = as.rgb(hex[7])[2], b = as.rgb(hex[7])[3])

rgb2cmyk(r = 228, g = 208, b = 255)

hex <- hex[1]
rgb <- as.rgb(hex)
hsl <- as.hsl(hex)
cmyk <- rgb2cmyk(r = rgb[1],g = rgb[2], b = rgb[3])
colour_name <- tools::toTitleCase(names(rgb2col(r = rgb[1],g = rgb[2], b = rgb[3]))[1])
text_colour <- cr_choose_bw(hex)
alt_text_colour <- ifelse(text_colour=='black','white','black')

p4 <- ggplot() + 
  annotate("rect", xmin = 0, xmax = 1, ymin = 0, ymax = 1,fill = hex) +
  annotate("rect", xmin = 0.1, xmax = 0.9, ymin = 0.1, ymax = 0.9,fill = text_colour) +
  annotate("rect", xmin = 0.11, xmax = 0.89, ymin = 0.3, ymax = 0.89,fill = hex) +
  annotate("text", x = 0.13, y = 0.2, label = colour_name, hjust = 0, family = myFont1, size = 11,color = alt_text_colour) +
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

  annotate("text", x = 0.01, y = 0.5, label = unique(example$name_with_shiny_stat), hjust = 0, family = myFont1,size = 16) +
  annotate("text", x = 0.01, y = 0.45, label = subtitle, hjust = 0, family = myFont1,size = 11) +
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



























