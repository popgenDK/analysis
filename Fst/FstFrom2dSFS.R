##This code is a modification of ANGSD R script FstFrom2dSFSHELLER.R to estimate Hudsons 1992 Fst as interpreted by Bhatia 2013 ###
# The script FstFrom2dSFSHELLER.R modified a previous R script in ANGSD which estimated Reynolds 1983 Fst.

args <- commandArgs(trailingOnly = TRUE)
# Function to display help information
display_help <- function() {
  cat("Usage: Rscript script.R PATH PATTERN\n")
  cat("Arguments:\n")
  cat("  PATH     - The path to the directory you want to process.\n")
  cat("  PATTERN  - The pattern to match files in the specified directory.\n")
  cat("\nExample:\n")
  cat("  Rscript script.R /path/to/directory your_pattern\n")
  cat("\nDescription:\n")
  cat("This script processes files in the specified PATH that match the given PATTERN.\n")
  quit(status = 1)
}

# Check if the correct number of arguments is provided
if (length(args) != 2) {
    display_help()
}

library(tidyverse)

##read in full 2dsfs:
PATH=args[1]
PATTERN=args[2]
samplelist=c(list.files(path = PATH, pattern = PATTERN, full.names = F))

##define Fst function
getFst<-function(est, sample_name){
    N1<-nrow(est)-1
    N2<-ncol(est)-1
    cat("N1: ",N1 ," N2: ",N2,"\n")
    est0<-est
    est0[1,1]<-0
    est0[N1+1,N2+1]<-0
    est0<-est0/sum(est0)
    aMat<<-matrix(NA,nrow=N1+1,ncol=N2+1)
    aMat.ss<<-matrix(NA,nrow=N1+1,ncol=N2+1)
    baMat<<-matrix(NA,nrow=N1+1,ncol=N2+1)
    for(a1 in 0:(N1)) {
        for(a2 in 0:(N2)){
            p1 <- a1/N1
            p2 <- a2/N2
            q1 <- 1 - p1
            q2 <- 1 - p2
            N <- (p1-p2)^2
            D <- p1*(1-p2)+p2*(1-p1)
            aMat[a1+1,a2+1]<<-N
            baMat[a1+1,a2+1]<<-D
            #sample size correction
            N.ss <- (p1-p2)^2-((p1*(1-p1))/(N1-1))-((p2*(1-p2))/(N2-1))
            aMat.ss[a1+1,a2+1]<<-N.ss
        }
            }
    ## sample size corrected moment estimator
    ss <- sum(est0*aMat.ss,na.rm=T)/sum(est0*baMat,na.rm=T)
    name=gsub(PATH,"",gsub(PATTERN,"", sample_name))
    return(data.frame(Sample = name, fstSS = ss))
}


result_list <- list()
for (sample in paste(PATH,samplelist,sep="")) {
    name=gsub(PATH,"",gsub(PATTERN,"", sample))
    full<-scan(sample)
    fullM<-matrix(full, ncol=3, nrow=3, byrow=T)
    result <- getFst(fullM, sample)  # Replace fullM with your actual matrix for each sample
    #print(result)
    result_list[[name]] <- result
}

# Combine results into a single data frame
final_results <- do.call(rbind, result_list)

# Print the results in a table format
print(final_results)

write.table(final_results, file = "Fst_results.txt", sep = "\t", row.names = FALSE, quote = TRUE)
ggplot(final_results, aes(y=Sample,x=fstSS, col=fstSS)) + geom_point()
ggsave('Fst_results.pdf')
