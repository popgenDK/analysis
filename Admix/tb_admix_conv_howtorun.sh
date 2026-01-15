# takes as input:
# loglikelihood file (no header)
# Qlist file (no header) - paths should either be relative to where the script is called or absolute paths
# convergence threshold (0.01)

# distance based convergence [written by TB]
    #  extracts Q matrix with minimum difference to the old Q(that has 1 less population) using euclidean distance
    # prints to std out : number of converged runs per k [k is considered converged if number output >=3 ]

#---------------------------------------------------------------------------------------------------------------------
cd $indir/admixture
module load R/4.2.2 R-packages

# i = ks, eg 2-10
# j = number of reps, eg 1-49

pref='ah_pruned' # prefix to files

for i in {2..10}
do
    for j in {1..49}
    do
        echo output/K$i/$pref.$i.Q_$j >> output/K$i/$i.Qlist
    done
    awk '{print $2}' output/K$i/$pref.likes.tmp > output/K$i/ll.$i.txt 
    CONV=$(Rscript testQconv.R output/K$i/ll.$i.txt output/K$i/$i.Qlist 0.01) 
    echo "k: "$i $CONV
done

#---------------------------------------------------------------------------------------------------------------------

# example of what input files shoudl look like [for k2] -
head pop_structure/admixture/output/K2/2.Qlist
output/K2/ah_pruned.2.Q_1
output/K2/ah_pruned.2.Q_2
output/K2/ah_pruned.2.Q_3

head pop_structure/admixture/output/K2/ll.2.txt
-18698254.438441
-18698265.197887
-18698365.127531

