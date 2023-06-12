library(data.table)
library(plater)
library(dplyr)
setwd("../../DMSC_LSHTM/plate_maps/")
#Get file list for the plate layouts in 96 well csv format
file_list <- list.files(pattern = "*.csv")

#read each plate and linearise - some rows are dropped due to missing data
for (i in 1:length(file_list)) assign(file_list[i], read_plate(file_list[i], well_ids_column = "Location", sep = ","))

#make list with the platemaps in it
all_platemaps <- mget(file_list)

#move to luminex data directory
setwd("../IgG/")

file_list <- list.files(pattern = "*.csv")
for (i in 1:length(file_list)) assign(file_list[i], fread(file_list[i],skip = '"DataType:","Count"', nrows = 97, showProgress = FALSE, stringsAsFactors=FALSE, check.names=T))

#put all dataframes in to one object
all_luminex <- mget(file_list)

#cleans the plate coordinate data from the xponent software
all_luminex_temp <- lapply(all_luminex, function(x){
  x$Location <- gsub('[0-9]+\\([0-9],','', x$Location);
  x$Location <-  gsub('\\)','', x$Location);
  x
})

#function to add the leading zeroes to the luminex plate coordinate data
all_luminex <- lapply(all_luminex_temp, function(y){
  y$Location <- sapply(y$Location, function(y) ifelse(nchar(y) == 3, y, sprintf('%.1s%02s', y, substring(y, 2))));
  y
})

# Make a list will all of the dataframes in it. This will be used to iterate through the files, appending the locations with the plate
file_list_all <- names(which(unlist(eapply(.GlobalEnv,is.data.frame))))
all_dfs <- mget(file_list_all)

#adds the name of the DF to a column on the end called 'plate'
all_luminex_temp <- Map(cbind, all_luminex, plate = names(all_luminex))

#cleans the plate colum (SPECIFIC for IgG)
all_luminex <- lapply(all_luminex_temp, function(x){
  x$plate <- gsub('G.*','', x$plate);
  x
})

#concatenates the plate and location columns with a '_' deliminator
all_luminex_temp <- lapply(all_luminex, function(x){
  x$uid <- paste(x$plate, x$Location, sep = "")
  x
})

#adds the name of the DF to a column on the end of platemaps called 'plate'
all_platemaps_temp <- Map(cbind, all_platemaps, plate = names(all_platemaps))


#cleans the plate colum (specific for the .csv extension on the plate column of platemap)
all_platemaps <- lapply(all_platemaps_temp, function(x){
  x$plate <- gsub('.csv','', x$plate);
  x
})

#concatenates the plate and location columns for the platemaps with a '_' deliminator
####IMPORTANT CHANGE FOR ISOTYPE
all_platemaps_temp <- lapply(all_platemaps, function(x){
  x$uid <- paste(x$plate, x$Location, sep = "_")
  x
})

#loop to change the colum names on the platemap list
all_platemaps <- lapply(all_platemaps_temp, function(x){
  colnames(x) <- c("location","sample","plate","uid");
  x
})
#bind (concatenate) all of the platemaps
platemap_master <- rbindlist(l = all_platemaps)

#bind (concatenate) all of the luminex data
luminex_master <- rbindlist(l = all_luminex_temp)

#final merge
merged_master_count <- merge(x = platemap_master,luminex_master,by.x = "uid", by.y = "uid", all.x = T, all.y = T )

#append each column name with the isotype
colnames(merged_master_count) <- paste("g_count", colnames(merged_master_g), sep = "_")

