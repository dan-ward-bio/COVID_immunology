# COVID_immunology

## A repository for scripts used in the 2022 LSHTM - DMSc COVID study.

### Levey Jennings chart (R)
With the working directory set to a directory with CSV outputs from the Luminex Exponent software, the script will generate a Levey-Jennings plot based on a 4-point logistic model on a positive standard curve, in this case hardcoded as being in wells 89-93 (line 30). You also need to specify an analyte (found on line 30) to use as the standard analyte. If different Luminex machines were used to generate the experiments, different colours will be applied to the plot to distinguish datasets.

### EC50_premerge (R)
With the working directory set to a directory with CSV outputs from the Luminex Exponent software, the script will generate a table containing an EC50 for each analyte used in a Luminex experiment. The EC50 is derived from a 4-point logistic model inferred from a titrated standard curve appropriate for the analyte in question.

