# COVID_immunology

## A repository for scripts used in the 2022 LSHTM - DMSc COVID study.

### Levey Jennings chart (R)
With the working directory set to a directory with CSV outputs from the Luminex Exponent software, the script will generate a Levey-Jennings plot based on a 4-parameter logistic model on a positive standard curve, in this case hardcoded as being in wells 89-93 (line 30). You also need to specify an analyte (found on line 30) to use as the standard analyte. If different Luminex machines were used to generate the experiments, different colours will be applied to the plot to distinguish datasets.

### r_plate_metamerge_IgG_count (R)
With the working directory set to a directory with CSV outputs from the Luminex Exponent software, the script will parse the CSV file from exponent software, reannotate the outputs, based on a 96-well plate diagram situated in another directory. The script will also integrate the "Count" value, enabling QC in later analysis. For our analyses, we exclided any sample wile < 10 beadcount.

###  (R)
With the working directory set to a directory with CSV outputs from the Luminex Exponent software, the script will generate a table containing an EC50 for each analyte used in a Luminex experiment. The EC50 is derived from a 4-parameter logistic model inferred from a titrated standard curve appropriate for the analyte in question.

### EC50_premerge (R)
With the working directory set to a directory with metadata merged outputs from the r_plate_metamerge_IgX script, this script will combine the EC50 data and normalise the MFI values for the entire plate. Each MFI value is divided by the EC50 for the respective antigen.

### Avidity index (R)
A script for calculating the avidity index from the merged dataframe.