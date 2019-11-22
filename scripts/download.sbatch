#!/bin/bash
#
#all commands that start with SBATCH contain commands that are just used by SLURM for scheduling
#################
#set a job name
#SBATCH --job-name=SRA
#################
#a file for job output, you can check job progress for each sample
#SBATCH --output=SRA.%j.out
#################
# a file for errors from the job for each sample
#SBATCH --error=SRA.%j.err
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
module load sra-toolkit

##Bioproject ID here
PROJID="PRJNA177515"

##Make a file with all the sample IDS
wget 'http://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?save=efetch&rettype=runinfo&db=sra&term=$PROJID' 
	-O - | cut -f1 -d',' | sed 1d > SRR_numbers.txt

##Download the samples
fastq-dump --split-files $(<SRR_numbers.txt)
