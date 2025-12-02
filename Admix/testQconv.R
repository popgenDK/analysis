## Returns number of converged runs based on Q matrix differences to the best run
## Arguments: 1) file with log likelihoods per run (Recommended: 0.01, virtually no visual difference)
##            2) file with list of Q matrix files per run (same order as log likelihoods)
##            3) threshold for maximum difference to consider run converged



## returns the Q matrix with minimum difference to the old Q(that has 1 less population)
## (from source("https://raw.githubusercontent.com/popgenDK/admixturePlot/refs/heads/main/admixFun.R"))
getFast<-function(Q,Qold){
    options(warn = -1)
    npop<-nrow(Qold)
    res<-c()
    for(g in 1:nrow(Q)){
        w<-rowSums((rep(Q[g,],each=npop)-Qold)^2)
        res<-rbind(res,c(which.min(w),min(w)))
    }
    dub <- duplicated(res[,1])
    dd<-res[dub,1]
    ww<-which.max(res[res[,1]==dd,2])       # gives a warning here if more than 1 ancestries are have pointed towards by multiple ancestries in the other Q 
    res[which(res[,1]==dd)[ww],1]<-npop+1   # not a problem when checking convergence, since this will only happen in very different Qs
    options(warn = 0)
    Q[order(res[,1]),]
}

args <- commandArgs(trailingOnly = TRUE)
# args <- c("sitatunga/ll.7.txt", "sitatunga.7.Qlist", "0.05")

ll <- data.table::fread(args[1], header=FALSE)$V1
best <- which.max(ll)
Qlist <- data.table::fread(args[2], header=FALSE)$V1

res <- c()
Qb <- t(data.table::fread(Qlist[best]))
for (i in 1:length(ll)) {
    Qt <- t(data.table::fread(Qlist[i]))
    Qt <- getFast(Qt, Qb)
    diff <- abs(Qt - Qb)
    diffsum <- colSums(diff)
    res <- rbind(res,
                 c(ll[i],
                   ll[i] - ll[best],
                   mean(diffsum),
                   max(diffsum),
                   sqrt(mean(colSums((Qt - Qb)**2))),
                   quantile(diffsum, 0.95),
                   quantile(diffsum, 0.975),
                   max(diff)
                   ))
}
res <- as.data.frame(res)
names(res) <- c("ll", "lldiff", "mean", "maxdiffsum", "rmse", "q95", "q975", "max")
res$conv <- res$max < as.numeric(args[3])
# print(res[rev(order(res$ll)), ])
cat(sum(res$conv))
#cat("\n")
