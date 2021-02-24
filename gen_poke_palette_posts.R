source('function_build_treemap.R')
source('function_build_palette_front_page.R')
source('function_build_palette_interval_page.R')
source('function_build_palette_cta_page.R')
source('function_build_palette_text.R')

df <- read.csv("data/pkmn_colour_clusters.csv",stringsAsFactors = F)
all_pkmn <- unique(df$file)
for(i in 1:length(all_pkmn)){
  
  file <- all_pkmn[i]
  chosen_df <- filter(df,file == all_pkmn[i])
  
  pkmn_path <- gsub(' \\(','_',unique(chosen_df$name_with_shiny_stat))
  pkmn_path <- gsub('\\)','',pkmn_path)
  folder_name <- paste0(substr(file,14,17),tolower(pkmn_path))
  
  dir.create(file.path('poke_palettes', folder_name))
  save_to <- paste0('poke_palettes/',folder_name)
  
  build_treemap(pkmn_file = file, pkmn_clusters = 7, output_folder = 'palette_clusters' ,output_height = 950,output_width = 500)
  build_palette_front_page(pkmn_file = file, treemap_folder = 'palette_clusters', output_folder = save_to)
  build_palette_interval_page(pkmn_file = file, pkmn_clusters = 7, output_folder = save_to)
  build_palette_cta_page(pkmn_file = file, output_folder = save_to)
  build_palette_text(pkmn_file = file, output_folder = save_to)
  
  if(i %% 25 == 0){
    print(paste0(i," done."))
  }
}


