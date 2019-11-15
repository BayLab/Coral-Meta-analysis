# RNASeq-Pipeline
This repository contains scripts and hints for processing RNASeq data for gene expression analysis. This is not meant to be a complete guide to RNA-Seq (if you're looking for that, check out [this page](https://rnaseq.uoregon.edu/) which has a ton of great informtion).

## Working on XSEDE Bridges

For most of our computational needs, we will use the Bridges supercomputer, which is part of the XSEDE program. If you do not already have an account, click [here](https://portal.xsede.org) and set one up. Then send your user name to Rachael and she will add you to the lab account.

Once you have an account, you can log in through the single sign on hub. Directions here:  https://portal.xsede.org/single-sign-on-hub

&nbsp;

## Download your data
First, we need to get our data onto XSEDE. Make sure you are working in your pylon5 directory, otherwise you will run out of room. Make a new folder for your project. We will refer to this as the "project directory" from now on.

You will need two types of data:
1) Transcriptome or genome assembly
2) fastq files containing sequence data for each sample

If a transcriptome assembly does not exist, you may have to make your own. We won't cover that here.

How you download your data will depend on where it is currently located. Here are some tips:
*If it is on a server from the sequencing center, try `wget`. 
*If it is on NCBI, check out [this tutorial for downloading from the short read archive](https://www.ncbi.nlm.nih.gov/sra/docs/sradownload/).
*If the data are on your computer, consider `scp` or `rsync`

I suggest you put all of your fastq files in one folder inside your project directory called "fastq"

&nbsp;

## Estimating gene expression per contig

There are many different pipelines for estimating gene expression. I provide scripts for two:
1) Alignment-free estimation using the program salmon
2) Alignments using hisat2

### Alignment-free estimation using salmon

The program 




### Alignments using hisat2

We will use a program called `hisat2` ([manual here](https://ccb.jhu.edu/software/hisat2/manual.shtml)) to map the reads to the reference assembly, but first we need to build an index for that assembly. Luckily, `hisat2` is pre-installed on Bridges. To use it, you first need to load the module:

```{bash}
> module load hisat2
```
Then you can build your index. If we had a reference assembly called *Reference.fasta*, for example, you would build your index like this:

```{bash}
> hisat2-build Reference.fasta Reference
```
When you execute this command, the base name for the output files will be "Reference"

&nbsp;

## Mapping to the reference assembly

Now we can map each sample to the reference assembly. Make a new folder in your project directory called "bam".

Here we will map single end reads. If you are mapping double end reads you will need to make some adjustments to the script. See the hisat2 manual for details on how to do this. In the "scripts" folder of this repository, there is a script for mapping called **map.sbatch**

Open the script you will be using. Check out the heading region to make sure you understand all the SBATCH settings. For example, you can insert your email address so that you get an email when a job is complete. 

The adjustments you need to make to the script are listed below:

```{bash}
$LANE="<LANE ID>" # Replace <LANE ID> with Use this if you have run samples across multple lanes and are processing lanes separately. Otherwise, insert a placeholder (like $LANE="lane")
$OUTDIR="<DIR>" # Replace <DIR> with the path of your "bam" folder
$REFDIR="<DIR>" # Replace <DIR> with the path to your reference index (ex. $REFDIR="../Reference")
```
Make sure all of your files end in ".fastq.gz". If not, you'll need to change the script (where you see `-U $sample.fastq.gz`) to reflect your real file names.

This script is made to map just one file. Navigate to your "fastq" folder. To try it out, we'll execute it on just one file first. Let's say you have a file called *Sample1.fastq.gz*. We only need the base name to execute the script:

```{bash}
> sbatch ../scripts/map.sbatch Sample1
```
After you run this, you can see the status of your job by checking the queue:

```{bash}
> squeue -u <username>
```
When it is done running, navigate to your "bam" folder. There should be one file in there.

Once we know it is working, we want to map all of your fastq files at once. Navigate into your "fastq" folder and create a loop that submits all the jobs:

```{bash}
> for sample in `ls *.fastq.gz | cut -f1 -d'.'`; do sbatch ../scripts/map.sbatch $sample; done
```
The first part of this command `ls *.fastq.gz` just asks for a list of all files that end in fastq.gz. The second part of the command `cut -f1 -d'.'` cuts the file name at each "." and takes just the first part of the filename. You can change this if you want something different. We then loop through these samples and execute the **map.sbatch** script for each sample.


