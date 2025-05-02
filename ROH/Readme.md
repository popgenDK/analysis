# ROH Runs of homozygosity

## About

The software ROHan can be used to find runs of homozygosity and compute rates of heterozygosity. We here provide a way to run [ROHan](https://github.com/grenaud/ROHan) on a set of binary alignment maps, save the results in a set of corresponding folders and then plot them. The method is here used on data obtained from African bushpigs, but it is applicable for any type of binary alignment maps as well. 


## Running ROHan on samples:

The script run_ROHan.sh runs ROHan on the given samples (presented as a collection of .bam files with one file per sample) and saves the results in the indicated working directory.

The working directory and collection of samples to be used can be changed at the very top of the script by assigning new values to the global variables WORKDIR and BAMLIST, respectively.

Specifically, the program takes the given working directory and list of .bam files and creates a new folder with a list of sample names that link to the corresponding .bam files. A series of output folders are then prepared in the working directory for the results of the analysis. The program then runs ROHan on each sample in the list in parallel twice: First with the default rhomu parameters of 2e-5 and then with a rohmu parameter of 1e-4. The results are put into the prepared output folders.

The final output is then one folder per sample, each containing about 22 files that detail the results of the ROHan analysis.


## Plotting the results:

Using the function plotROHAN()  in the script plotROH.R, you can then plot whichever results were reached by the previous analysis and save these plots in a location of your choosing. The function takes the following parameters:
* The path to one of the created output folders + the name of the corresponding sample. An example could be: "/maps/projects/alab/people/mqr375/saola/output/05MBWindow_tvonly/9253/9253_rohan_05MBWindow_tvonly"
* A path for the output of the function. An example could be: "/maps/projects/alab/people/mqr375/saola/9253_rohan_05MBWindow_tvonly.png"
