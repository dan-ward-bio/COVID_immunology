library(data.table)
library(dplyr)
setwd("/Users/dan_macbook/OneDrive/LSHTM/DMSC_LSHTM_sero_assay/merged_data")

###make list of the EC50 and DF files
file_list <- list.files(pattern = "*.csv")

#read in the EC50 and the main premerge dataframes
for (i in 1:length(file_list)) assign(file_list[i], fread(file_list[i],  header = TRUE))

#Merge the dataframes
IgG_pre_EC50_merge <- merge(x = IgG_EC50.csv, y =IgG_premerge.csv, all.y = T, all.x = T, by.x = "rn", by.y = "g_plate.x" )
IgM_pre_EC50_merge <- merge(x = IgM_EC50.csv, y =IgM_premerge.csv, all.y = T, all.x = T, by.x = "rn", by.y = "m_plate.x" )
IgA_pre_EC50_merge <- merge(x = IgA_EC50.csv, y =IgA_premerge.csv, all.y = T, all.x = T, by.x = "rn", by.y = "a_plate.x" )
IgV_pre_EC50_merge <- merge(x = IgV_EC50.csv, y =IgV_premerge.csv, all.y = T, all.x = T, by.x = "rn", by.y = "v_plate.x" )

rm(list = file_list)

column_list_a <- c("a_Analyte.45","a_Analyte.46","a_Analyte.47","a_Analyte.48","a_Analyte.51","a_Analyte.52","a_Analyte.53","a_Analyte.54","a_Analyte.55","a_Analyte.56","a_Analyte.57","a_Analyte.61","a_Analyte.62","a_Analyte.63","a_Analyte.64","a_Analyte.65","a_Analyte.66")
column_list_m <- c("m_Analyte.45","m_Analyte.46","m_Analyte.47","m_Analyte.48","m_Analyte.51","m_Analyte.52","m_Analyte.53","m_Analyte.54","m_Analyte.55","m_Analyte.56","m_Analyte.57","m_Analyte.61","m_Analyte.62","m_Analyte.63","m_Analyte.64","m_Analyte.65","m_Analyte.66")
column_list_v <- c("v_Analyte.45","v_Analyte.46","v_Analyte.47","v_Analyte.48","v_Analyte.51","v_Analyte.52","v_Analyte.53","v_Analyte.54","v_Analyte.55","v_Analyte.56","v_Analyte.57","v_Analyte.61","v_Analyte.62","v_Analyte.63","v_Analyte.64","v_Analyte.65","v_Analyte.66")
column_list_g <- c("g_Analyte.45","g_Analyte.46","g_Analyte.47","g_Analyte.48","g_Analyte.51","g_Analyte.52","g_Analyte.53","g_Analyte.54","g_Analyte.55","g_Analyte.56","g_Analyte.57","g_Analyte.61","g_Analyte.62","g_Analyte.63","g_Analyte.64","g_Analyte.65","g_Analyte.66")



#Loop to apply normalisation for the EC50 and each analyte

for (i in column_list_a){
  IgA_pre_EC50_merge[, paste(i, ".adjusted", sep='')] <- (IgA_pre_EC50_merge[, ..i]
                                                       /IgA_pre_EC50_merge$EC50)
}

for (i in column_list_g){
  IgG_pre_EC50_merge[, paste(i, ".adjusted", sep='')] <- (IgG_pre_EC50_merge[, ..i]
                                                          /IgG_pre_EC50_merge$EC50)
}

for (i in column_list_m){
  IgM_pre_EC50_merge[, paste(i, ".adjusted", sep='')] <- (IgM_pre_EC50_merge[, ..i]
                                                          /IgM_pre_EC50_merge$EC50)
}

for (i in column_list_v){
  IgV_pre_EC50_merge[, paste(i, ".adjusted", sep='')] <- (IgV_pre_EC50_merge[, ..i]
                                                          /IgV_pre_EC50_merge$EC50)
}

#####merging the final dataset
###list of columns to drop
a_drop_list<-c("a_Analyte.45","a_Analyte.46","a_Analyte.47","a_Analyte.48","a_Analyte.51","a_Analyte.52","a_Analyte.53","a_Analyte.54","a_Analyte.55","a_Analyte.56","a_Analyte.57","a_Analyte.61","a_Analyte.62","a_Analyte.63","a_Analyte.64","a_Analyte.65","a_Analyte.66","V1.x","V1.y","count_a_uid","count_a_location","count_a_sample","count_a_plate.x","a_Location","count_a_Location","a_Sample","count_a_Sample","a_Total.Events","count_a_Total.Events","a_plate.y")
g_drop_list<-c("g_Analyte.45","g_Analyte.46","g_Analyte.47","g_Analyte.48","g_Analyte.51","g_Analyte.52","g_Analyte.53","g_Analyte.54","g_Analyte.55","g_Analyte.56","g_Analyte.57","g_Analyte.61","g_Analyte.62","g_Analyte.63","g_Analyte.64","g_Analyte.65","g_Analyte.66","V1.x","V1.y","count_g_uid","count_g_location","count_g_sample","count_g_plate.x","g_Location","count_g_Location","g_Sample","count_g_Sample","g_Total.Events","count_g_Total.Events","g_plate.y")
v_drop_list<-c("v_Analyte.45","v_Analyte.46","v_Analyte.47","v_Analyte.48","v_Analyte.51","v_Analyte.52","v_Analyte.53","v_Analyte.54","v_Analyte.55","v_Analyte.56","v_Analyte.57","v_Analyte.61","v_Analyte.62","v_Analyte.63","v_Analyte.64","v_Analyte.65","v_Analyte.66","V1.x","V1.y","count_v_uid","count_v_location","count_v_sample","count_v_plate.x","v_Location","count_v_Location","v_Sample","count_v_Sample","v_Total.Events","count_v_Total.Events","v_plate.y")
m_drop_list<-c("m_Analyte.45","m_Analyte.46","m_Analyte.47","m_Analyte.48","m_Analyte.51","m_Analyte.52","m_Analyte.53","m_Analyte.54","m_Analyte.55","m_Analyte.56","m_Analyte.57","m_Analyte.61","m_Analyte.62","m_Analyte.63","m_Analyte.64","m_Analyte.65","m_Analyte.66","V1.x","V1.y","count_m_uid","count_m_location","count_m_sample","count_m_plate.x","m_Location","count_m_Location","m_Sample","count_m_Sample","m_Total.Events","count_m_Total.Events","m_plate.y")

#drop columns from the appropriate data tables 
IgA_pre_EC50_merge <- IgA_pre_EC50_merge %>% select(-one_of(a_drop_list)) 
IgG_pre_EC50_merge <- IgG_pre_EC50_merge %>% select(-one_of(g_drop_list)) 
IgV_pre_EC50_merge <- IgV_pre_EC50_merge %>% select(-one_of(v_drop_list)) 
IgM_pre_EC50_merge <- IgM_pre_EC50_merge %>% select(-one_of(m_drop_list)) 

#merge commands
a_g_merge <- merge(IgA_pre_EC50_merge,IgG_pre_EC50_merge, by.x = "a_uid", by.y = "g_uid", all.x = T, all.y = T)
a_g_m_merge <- merge(a_g_merge,IgM_pre_EC50_merge, by.x = "a_uid", by.y = "m_uid", all.x = T, all.y = T)
isotype_merge <- merge(a_g_m_merge,IgV_pre_EC50_merge, by.x = "a_uid", by.y = "v_uid", all.x = T, all.y = T)

#new drop list for the merged columns
colnames(isotype_merge)[1:5] = c("uid","plate_coordinates","EC50","location","sample")

merged_drop_list<-c("EC50.x", "EC50.y","rn.x", "rn.y", "m_sample","g_sample","v_sample","a_sample","m_location","g_location","v_location","a_location")
isotype_merge <- isotype_merge %>% select(-one_of(merged_drop_list)) 

##########
##########

###perform avidity index calculation

###Avidity index calculation
analyte_vector <- c("_Analyte.45.adjusted","_Analyte.46.adjusted","_Analyte.47.adjusted","_Analyte.48.adjusted","_Analyte.51.adjusted","_Analyte.52.adjusted","_Analyte.53.adjusted","_Analyte.54.adjusted","_Analyte.55.adjusted","_Analyte.56.adjusted","_Analyte.57.adjusted","_Analyte.61.adjusted","_Analyte.62.adjusted","_Analyte.63.adjusted","_Analyte.64.adjusted","_Analyte.65.adjusted","_Analyte.66.adjusted")

for (i in analyte_vector){
  isotype_merge[, paste(i, ".avidity_index", sep='')] <- (isotype_merge[, paste("v",..i, sep='')]
                                                          /isotype_merge[, paste("g",..i, sep='')]*100)
}

