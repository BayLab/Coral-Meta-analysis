#!/bin/bash
#
#all commands that start with SBATCH contain commands that are just used by SLURM for scheduling
#################
#set a job name
#SBATCH --job-name=MAP
#################
#a file for job output, you can check job progress for each sample
#SBATCH --output=MAP.%j.out
#################
# a file for errors from the job for each sample
#SBATCH --error=MAP.%j.err
#################
#time you think you need; default is one hour
#in minutes in this case
#SBATCH -t 24:00:00
#################
#quality of service; think of it as job priority
#SBATCH -p RM
#################
#number of nodes- for RM-shared -N 1
#SBATCH -N 1
#SBATCH --ntasks-per-node 4
#################
#SBATCH --mem=8G
#################
#get emailed about job BEGIN, END, and FAIL
#SBATCH --mail-type=END
#################
#who to send email to; please change to your email
#SBATCH  --mail-user=
#################
#now run normal batch commands
##################
#echo commands to stdout
set -x
##################

##Load programs you need
module load hisat2
module load samtools

##Study specific info
$LANE="<LANE ID"
$LANE="<LANE ID>" # Replace <LANE ID> with Use this if you have run samples across multple lanes and are processing lanes separately. Otherwise, insert a placeholder (like $LANE="lane")
$OUTDIR="<DIR>" # Replace <DIR> with the path of your "bam" folder
$REFDIR="<DIR>" # Replace <DIR> with the path to your reference index (ex. $REFDIR="../Reference")


##Mapping
sample=$1
ID="$LANE.$sample"

hisat2 -x $REFDIR \
	--threads 8 -U $sample.fastq.gz \
	--rg-id $ID --rg SM:$sample --rg LB:$LANE --rg PU:$LANE --rg PL:illumina | \
	samtools view -bhS - | \
	samtools sort -o $OUTDIR/$ID.bam
