#!/bin/bash

OUTDIR="/home/vzw531/data/GFH-project/distant/HET"
REF="/projects/seqafrica/data/mapping/genomes/SusScrofa11_1.fasta"
BAMLIST="/home/vzw531/data/GFH-project/distant/bamlists/bamfiles_GFH_hybrid_distant.txt"
winSFS="/maps/projects/seqafrica/apps/modules/software/winsfs/0.7.0/bin/winsfs"
sites="/home/vzw531/data/GFH-project/distant/sites_filter/GLfilters/combined_filters/sites_filters_GFH_keep.angsdfile"
scaffolds="/home/vzw531/data/GFH-project/distant/refs_files/SusScrofa_autosomes.txt"
ANGSD="/maps/projects/seqafrica/apps/modules/software/angsd-0.941/angsd"

cat ${BAMLIST} | while read line
do
$ANGSD -i "$line" -anc ${REF} -dosaf 1 -rf $scaffolds -sites $sites -minMapQ 30 -minQ 30 -P 2 -out ${OUTDIR}/$(basename "${line%.*}") \
-gl 2 -doMajorMinor 1 -doCounts 1 -setMinDepthInd 3 -uniqueOnly 1 -remove_bads 1
${winSFS}  ${OUTDIR}/$(basename "${line%.*}").saf.idx > ${OUTDIR}/$(basename "${line%.*}")_est.ml
done

## collect all estimates into one file and
## modify the sample names to drop the _est.ml suffix
awk '{print FILENAME, $0}' *_est.ml | grep -v "#" | sed 's/all_est.ml //g' | sed 's/_est.ml//g' > all_est.ml


module load gcc/11.2.0 R/4.2.2 R-packages/4.2.2 

echo "Running R code to generate heterozygosity plot..."

Rscript -e 'library(tidyverse)
a = as.data.frame(read.table("all_est.ml"))
mutate(a, V5=V3/(V2+V3+V4)) %>% ggplot(aes(y=V1, x=V5, fill="pink")) + geom_bar(stat="identity") + xlab("Heterozygosity") + ylab("Samples") + theme_minimal()
 
ggsave("Heterozygosity.pdf")'
