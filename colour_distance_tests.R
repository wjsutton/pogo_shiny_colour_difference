


colours <- read.csv("data/jpeg_main_colours.csv",stringsAsFactors = F)

# Arbok colours test
not_shiny <- colours[94,]
shiny <- colours[95,]

shiny_primary_rgb <- col2rgb(shiny$colour_2)
not_shiny_primary_rgb <- col2rgb(not_shiny$colour_2)

# calculate eucludian distance

distance <- sqrt(
  (shiny_primary_rgb[1,] - not_shiny_primary_rgb[1,])^2
  + (shiny_primary_rgb[2,] - not_shiny_primary_rgb[2,])^2
  + (shiny_primary_rgb[3,] - not_shiny_primary_rgb[3,])^2
)

white_to_black_distance <- sqrt((255)^2 + (255)^2 + (255)^2)

distance/white_to_black_distance

# Pikachu colour test

not_shiny_pika <- filter(colours,jpeg_img=="pokemon_icon_025_00.jpeg")
shiny_pika <- filter(colours,jpeg_img=="pokemon_icon_025_00_shiny.jpeg")

shiny_pika_primary_rgb <- col2rgb(shiny_pika$colour_2)
not_shiny_pika_primary_rgb <- col2rgb(not_shiny_pika$colour_2)

# calculate eucludian distance

distance_pika <- sqrt(
  (shiny_pika_primary_rgb[1,] - not_shiny_pika_primary_rgb[1,])^2
  + (shiny_pika_primary_rgb[2,] - not_shiny_pika_primary_rgb[2,])^2
  + (shiny_pika_primary_rgb[3,] - not_shiny_pika_primary_rgb[3,])^2
)
distance_pika/white_to_black_distance

shiny_pika_secondary_rgb <- col2rgb(shiny_pika$colour_3)
not_shiny_pika_secondary_rgb <- col2rgb(not_shiny_pika$colour_3)

# calculate eucludian distance

distance_pika_secondary <- sqrt(
  (shiny_pika_secondary_rgb[1,] - not_shiny_pika_secondary_rgb[1,])^2
  + (shiny_pika_secondary_rgb[2,] - not_shiny_pika_secondary_rgb[2,])^2
  + (shiny_pika_secondary_rgb[3,] - not_shiny_pika_secondary_rgb[3,])^2
)
distance_pika_secondary/white_to_black_distance

primary_col_count <- (shiny_pika$colour_2_count + not_shiny_pika$colour_2_count)
secondary_col_count <- (shiny_pika$colour_3_count + not_shiny_pika$colour_3_count)

primary_col_pc <- primary_col_count / (primary_col_count+secondary_col_count)
secondary_col_pc <- secondary_col_count / (primary_col_count+secondary_col_count)

total_distance_pika <- distance_pika*primary_col_pc + distance_pika_secondary*secondary_col_pc
total_distance_pika_relative <- total_distance_pika/white_to_black_distance

