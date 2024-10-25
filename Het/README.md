# Heterozygosity #

This script represents an example to calculate the heterozygosity of your samples using ANGSD and winSFS.

## Inputs
1. BAM files
2. Reference genome
3. List of scaffolds
4. Angsd file including list of filtered sites (good sites from RepeatMasker, depth and excess heterozygosity filters)

## Softwares needed 
1. ANGSD
2. winSFS
3. R

## Outputs 
1. ANGSD outputs (.saf.gz, .saf.idx, .saf.pos.gz)
2. winSFS outpus (*_est.ml)
3. comulative SFS table (all_est.ml)
4. R output (Heterozygosity.pdf)
