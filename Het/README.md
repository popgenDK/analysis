# Heterozygosity #

This script represents an example to calculate the heterozygosity of your samples using ANGSD and winSFS.

## Inputs
1. List of BAM files (one path/bam file per line)
2. Reference genome 
3. List of scaffolds
4. Angsd file including a list of filtered sites (good sites from RepeatMasker, depth and excess heterozygosity filters)
   
   This file was obtained from a `.bed` file that was indixed following the instructions in this page: https://www.popgen.dk/angsd/index.php/Sites.

## Softwares needed 
1. ANGSD
2. winSFS
3. R

## Outputs 
1. ANGSD outputs (.saf.gz, .saf.idx, .saf.pos.gz)
2. winSFS outpus (*_est.ml)
3. A comulative SFS table (all_est.ml) for all samples included
4. R output (Heterozygosity.pdf)
