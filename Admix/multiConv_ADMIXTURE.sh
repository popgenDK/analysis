#!/bin/bash
file=$1 #plink filename without .bed
num=$2 #number of iterations
P=$3 #number of threads
out=$4 #output directory (no /)
K=$5 #number of populations
star=$6 # starting seed
bfile=`basename $file`

# How to run: `bash multiConv_ADMIXTURE.sh <plink prefix> <last seed> <threads> <output folder> <number of K> <first seed>`

ADM=/home/mdn487/bin/admixture_linux-1.3.0/admixture
CONV_TIMES=3
# conv success if 5 LL unit within max 

echo num = $num 
echo p = $P 
echo out = $out 
echo K = $K

mkdir -p $out
touch $out/$bfile.$K.likes.tmp

for f in `seq $star $num`
do
        echo -n -e $f"\t" >> $out/$bfile.$K.likes.tmp
        $ADM $file.bed $K -s $f -j$P > $out/$bfile.$K.log_$f
        # Uncomment to see the Q and P for each iteration and get the best seed
        mv $bfile.$K.Q $out/$bfile.$K.Q_$f
        #mv $bfile.$K.P $out/$bfile.$K.P_$f
        # else the new Q and P will rewrite the previous Q and P
        grep ^Loglikelihood  $out/$bfile.$K.log_$f | cut -f2 -d" " >> $out/$bfile.$K.likes.tmp
                           
        CONV=`Rscript -e "r<-read.table('$out/$bfile.$K.likes.tmp');r<-r[order(-r[,2]),];cat(sum(r[1,2]-r[,2]<3),'\n')"`
        echo conv $CONV with chosen $CONV_TIMES
        echo $out/$bfile.$K.Q_$f >> $out/$K.Qlist
        awk '{print $2}' $out/$bfile.$K.likes.tmp > $out/ll.$f.txt 
        CONV2=`Rscript testQconv.R $out/ll.$f.txt $out/$K.Qlist 0.01` 
        echo "second criteria conv: "$CONV2 with chosen $CONV_TIMES
        if [ $CONV -gt $CONV_TIMES ] || [ $CONV2 -gt $CONV_TIMES ] 
        then
            mv $out/$bfile.$K.Q_$f $out/$bfile.$K.Q_conv
            mv $bfile.$K.P $out/$bfile.$K.P_conv
            mv $out/$bfile.$K.log_$f $out/$bfile.$K.log_conv
            echo "k: "$K first conv criteria $CONV second conv criteria $CONV2
            break
        fi      
done 
cat $out/$bfile.$K.likes.tmp | sort -k2 -n -r > $out/$bfile.$K.likes
