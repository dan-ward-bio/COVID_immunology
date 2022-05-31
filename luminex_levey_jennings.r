#A janky R script for performing Levey-Jennings analysis on luminex CSV files. Should setwd as the dir with the CSVs in it. 

library(plyr)
library(drc)
library(ggplot2)
library(sjPlot)
library(tidyverse)
library(data.tables)
library(dpylr)

#list files in set directory and import
file_list <- list.files(pattern = "*.csv")
#first import the serialnumber of the device
for (i in 1:length(file_list)) assign(file_list[i], fread(file_list[i], skip = "SN" ,nrows = 1, showProgress = FALSE, header = FALSE, drop = "V1"))
#make a new list of the metadata table
list_meta <- mget(ls(pattern = '*.csv'))
#concatenate
metadata <- cbind(list_meta)
metadata <- do.call(rbind.data.frame, list_meta)

#import and list the full datatable, strating from the Median metric
for (i in 1:length(file_list)) assign(file_list[i], fread(file_list[i],skip = "Median", nrows = 97, showProgress = FALSE, stringsAsFactors=FALSE, check.names=T))
list_df <- mget(ls(pattern = '*.csv'))

###########################
#EC50 and parsing function

EC50 <- function(filename) {
  #put the positive standard curve in to a new table
  pos_curve <- filename[89:93,c("Analyte.48", "Sample")]
  #index label
  pos_curve$dilution <- seq.int(nrow(pos_curve))
  #drop sample column
  pos_curve <- pos_curve[ -c(2) ]
  #plot the curve
  fitted_curve <- drm(formula = Analyte.48 ~ dilution,
                      data = pos_curve,
                      fct = LL.4())
  plot(fitted_curve,
       log='x',
       xlab = 'Serum dilution factor',
       ylab= 'Luminex MFI')
EC50_pool <<- as.list(fitted_curve$coefficients[4])
}

#################
#run function and pool
EC50_pool <<- lapply(list_df,EC50)
#make list in to table
EC50_pool_df <- do.call(rbind.data.frame, EC50_pool)
#make index row
EC50_pool_df$plate <- seq.int(nrow(EC50_pool_df))
colnames(EC50_pool_df)[1] <- "EC50"

#mean and SD of EC50s
EC50.mean <- mean(EC50_pool_df$EC50)
EC50.SD <- sd(EC50_pool_df$EC50)


#combine the machine metadata to plot table
plot_table <- cbind(EC50_pool_df, metadata)

#moves the plate name to the first column so we can use as xlab
plot_table <- setDT(plot_table, keep.rownames = TRUE)[]

#rename some columns
names(plot_table)[names(plot_table) == "rn"] <- "Plate"
names(plot_table)[names(plot_table) == "V2"] <- "Machine_Serial"



#make plot
ggplot(plot_table, aes(x=Plate, y=EC50, color=Machine_Serial, labels = Plate)) +
geom_point()+
scale_y_continuous(breaks = pretty(plot_table$EC50, n = 10))+
ylim(0, 5) +
  #add mean
geom_hline(yintercept=EC50.mean, linetype="solid",
             color = "black", size=0.5) +
  #add SD
geom_hline(yintercept=EC50.mean+(EC50.SD*2), linetype="dashed",
             color = "red", size=0.5, alpha=0.5) +
geom_hline(yintercept=EC50.mean-(EC50.SD*2), linetype="dashed",
           color = "red", size=0.5, alpha=0.5) +
ggtitle("Levey–Jennings analysis - DMSc-LSHTM IgG")+
  theme(axis.text = element_text(size = 8, angle=0))+
  coord_flip()
