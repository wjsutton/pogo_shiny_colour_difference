library(dplyr)

# loading files
pkmn_index <- read.csv("data/pkmn_image_index.csv",stringsAsFactors = F)
png2jpeg <- read.csv("data/png_to_jpeg.csv",stringsAsFactors = F)
colours <- read.csv("data/jpeg_main_colours.csv",stringsAsFactors = F)

# cleaning and joining files
colours <- colours %>% select(-c(colour_1,colour_1_count))
names(colours) <- c("jpeg_img","primary_colour","second_colour","primary_colour_count","second_colour_count")

pkmn_df <- inner_join(pkmn_index,png2jpeg, by = c("file" = "png"))
pkmn_df <- inner_join(pkmn_df,colours, by = c("jpeg" = "jpeg_img"))

# Convert hexcodes to rgb components
pkmn_df$primary_red <- t(col2rgb(pkmn_df$primary_colour))[,1]
pkmn_df$primary_green <- t(col2rgb(pkmn_df$primary_colour))[,2]
pkmn_df$primary_blue <- t(col2rgb(pkmn_df$primary_colour))[,3]

pkmn_df$second_red <- t(col2rgb(pkmn_df$second_colour))[,1]
pkmn_df$second_green <- t(col2rgb(pkmn_df$second_colour))[,2]
pkmn_df$second_blue <- t(col2rgb(pkmn_df$second_colour))[,3]

# Split file into shiny & non-shiny then join together
shiny_pkmn <- pkmn_df %>% filter(shiny_or_not==TRUE) %>% select(-shiny_or_not)
non_shiny_pkmn <- pkmn_df %>% filter(shiny_or_not==FALSE) %>% select(-shiny_or_not)

names(shiny_pkmn) <- c("shiny_file","id","variation",paste0("shiny_",names(pkmn_df[,5:15])))
names(non_shiny_pkmn) <- c("non_shiny_file","id","variation",paste0("non_shiny_",names(pkmn_df[,5:15])))

comparison_df <- inner_join(shiny_pkmn,non_shiny_pkmn, by = c("id" = "id", "variation" = "variation"))

# calculate colour distance
comparison_df$distance_primary <- sqrt(
  (comparison_df$shiny_primary_red - comparison_df$non_shiny_primary_red)^2
  + (comparison_df$shiny_primary_green - comparison_df$non_shiny_primary_green)^2
  + (comparison_df$shiny_primary_blue - comparison_df$non_shiny_primary_blue)^2
)

comparison_df$distance_second <- sqrt(
  (comparison_df$shiny_second_red - comparison_df$non_shiny_second_red)^2
  + (comparison_df$shiny_second_green - comparison_df$non_shiny_second_green)^2
  + (comparison_df$shiny_second_blue - comparison_df$non_shiny_second_blue)^2
)

comparison_df$primary_col_count <- (comparison_df$shiny_primary_colour_count + comparison_df$non_shiny_primary_colour_count)
comparison_df$secondary_col_count <- (comparison_df$shiny_second_colour_count + comparison_df$non_shiny_second_colour_count)

comparison_df$primary_col_pc <- comparison_df$primary_col_count / (comparison_df$primary_col_count+comparison_df$secondary_col_count)
comparison_df$secondary_col_pc <- comparison_df$secondary_col_count / (comparison_df$primary_col_count+comparison_df$secondary_col_count)

comparison_df$distance_overall <- comparison_df$distance_second*comparison_df$primary_col_pc + comparison_df$distance_primary*comparison_df$secondary_col_pc

write.csv(comparison_df,"data/pkmn_shiny_colour_distance.csv",row.names = F)
