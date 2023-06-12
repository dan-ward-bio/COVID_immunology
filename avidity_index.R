###Avidity index calculation
analyte_vector <- c("_Analyte.45.adjusted","_Analyte.46.adjusted","_Analyte.47.adjusted","_Analyte.48.adjusted","_Analyte.51.adjusted","_Analyte.52.adjusted","_Analyte.53.adjusted","_Analyte.54.adjusted","_Analyte.55.adjusted","_Analyte.56.adjusted","_Analyte.57.adjusted","_Analyte.61.adjusted","_Analyte.62.adjusted","_Analyte.63.adjusted","_Analyte.64.adjusted","_Analyte.65.adjusted","_Analyte.66.adjusted")

for (i in analyte_vector){
  isotype_merge[, paste(i, ".avidity_index", sep='')] <- (isotype_merge[, paste("v",..i, sep='')]
                                                          /isotype_merge[, paste("g",..i, sep='')]*100)
}

