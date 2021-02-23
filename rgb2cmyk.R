
rgb2cmyk <- function(r,g,b) {
  #RGB to CMYK conversion formula
  
  # The R,G,B values are divided by 255 to change the range from 0..255 to 0..1:
    
  R <- r/255
  G <- g/255
  B <- b/255
  
  # The black key (K) color is calculated from the red (R'), green (G') and blue (B') colors:
  
  k <- 1-max(R, G, B)

  # The cyan color (C) is calculated from the red (R) and black (K) colors:
    
  c <- (1-R-k) / (1-k)

  # The magenta color (M) is calculated from the green (G) and black (K) colors:
      
  m <- (1-G-k) / (1-k)

  # The yellow color (Y) is calculated from the blue (B) and black (K) colors:
        
  y <- (1-B-k) / (1-k)
  
  output <- c(c,m,y,k)
  names(output) <- c('c','m','y','k')
  
  return(output)
}