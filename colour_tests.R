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

ggsave(paste0("poke_palettes/test_colour_v3.png")
       ,plot = p4
       ,width = 5, height = 5, dpi = 300, units = "in") 


























