# script to try to map RBG colours values to simple colour names
# e.g. red, green, yellow, etc.

# After testing output isn't correctly mapping colours
# e.g. Azumarill mapped to lightsalmon3 when it should be yellow

# To Do
# check script working correctly

#from https://stackoverflow.com/questions/41209395/from-hex-color-code-or-rgb-to-color-name-using-r
library(scales) #for function show_col

DF = read.table(text="Color Count red green blue
 ED1B24 16774 237    27   36
 000000 11600   0     0    0
 23B14D  5427  35   177   77
 FFFFFF  5206 255   255  255
 FEF200  3216 254   242    0
 ED1B26   344 237    27   38",header=TRUE,stringsAsFactors=FALSE)


#from https://gist.github.com/mbannert/e9fcfa86de3b06068c83

rgb2hex <- function(r,g,b) rgb(r, g, b, maxColorValue = 255)

rgb2col = function(r,g,b) {
  
  #create colour name vs. rgb mapping table 
  colourMap = data.frame(colourNames = colours(),t(col2rgb(colours())))
  
  #input test colours
  testDF = data.frame(colourNames="testCol",red = r,green = g,blue = b)
  
  #combine both tables
  combDF = rbind(testDF,colourMap)
  
  #convert in matrix representation 
  combMat= (as.matrix(combDF[,-1]))
  
  #add row labels as colour names
  rownames(combMat) = combDF[,1]
  
  #compute euclidean distance between test rgb vector and all the colours
  #from mapping table 
  #using dist function compute distance matrix,retain only upper matrix
  #find minimum distance point from test vector
  
  #find closest matching colour name
  approxMatchCol = which.min(as.matrix(dist(combMat,upper=TRUE))[1,][-1])
  
  #compare test colour with approximate matching colour
  #scales::show_col(c(rgb2hex(r,g,b),rgb2hex(colourMap[approxMatchCol,2:4])))
  
  #return colour name
  return(approxMatchCol)
  
}

#sapply(1:nrow(DF),function(x) rgb2col(DF[x,"red"],DF[x,"green"],DF[x,"blue"]))

tab <- read.csv("data/pokemon_colour_distance_for_tableau.csv",stringsAsFactors = F)

tab$red_shiny <- tab$red_shiny*255
tab$green_shiny <- tab$green_shiny*255
tab$blue_shiny <- tab$blue_shiny*255
output <- sapply(1:nrow(tab),function(x) rgb2col(tab[x,"red_shiny"],tab[x,"green_shiny"],tab[x,"blue_shiny"]))
shiny_colour_list <- names(output)
tab$shiny_colour_name <- shiny_colour_list

write.csv(tab,"data/shiny_colours_test_file.csv",row.names = F)
