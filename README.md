# RNASeq-Pipeline
This repository contains scripts and hints for processing RNASeq data for gene expression analysis. This is not meant to be a complete guide to RNA-Seq (if you're looking for that, check out [this page](https://rnaseq.uoregon.edu/) which has a ton of great informtion).

## Working on XSEDE Bridges

For most of our computational needs, we will use the Bridges supercomputer, which is part of the XSEDE program. If you do not already have an account, click [here](https://portal.xsede.org) and set one up. Then send your user name to Rachael and she will add you to the lab account.

Once you have an account, you can log in through the single sign on hub. Directions here:  https://portal.xsede.org/single-sign-on-hub

Once you are signed on to the single sign on hub, sign into the Bridges supercomputer:

```{bash}
 > gsissh bridges
```
We don't have much space in the main directory, but we have lots of space in the pylon5 directory. To navigate to your pylon5 directory:

```{bash}
 > cd /pylon5/bi5613p/<yourID>/
```
&nbsp;

## Download your data
I will use the example of the data from Barshis et al. (2013).

First, we need to get our data onto XSEDE. Make sure you are working in your pylon5 directory, otherwise you will run out of room. Make a new folder for your project (Use the last name of the first author and year of publication - Ex. Barshis_2013). We will refer to this as the "project directory" from now on. Navigate into that directory.

You will need two types of data:
1) Transcriptome or genome assembly
2) fastq files containing sequence data for each sample

If the transcriptome assembly is online somewhere, right click on the link and click *Copy Link Address*. Then, in your console use `wget` to download the assembly:
```{bash}
 > wget "https://copied.link.here.com"
```
This should work if the assembly is either on a website or on a server from the sequencing center. For example, I found the assembly for Acropora hyacinthus ont he [Palumbi lab web page](https://palumbilab.stanford.edu/data/index.html). I can then download the assembly:
```{bash}
 > wget "https://palumbilab.stanford.edu/data/33496_Ahyacinthus_CoralContigs.fasta.zip"
```
Notice this is a compressed fasta, so I uncompress it:
```{bash}
 > unzip 33496_Ahyacithus_CoralContigs.fasta
```
&nbsp;

Now I need the sequence files. If you have an NCBI Bioproject ID you can download directly from NCBI. [Here's some information on downloading from the short read archive](https://www.ncbi.nlm.nih.gov/sra/docs/sradownload/). The sra toolkit is already installed on Bridges, so let's load it:

```{bash}
 > module load sra-toolkit
```

Then, for our BioProject ID, we need a list of all the sample numbers. Insert your bioproject ID instead of "BIOPROJECTID" into the script below:

```{bash}
 > wget 'http://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?save=efetch&rettype=runinfo&db=sra&term=BIOPROJECTID' -O - | cut -f1 -d',' | sed 1d > SRR_numbers.txt
```
We can use that list to download all the fastq files:

```{bash{
 > fastq-dump --split-files $(<SRR_numbers.txt)
```
The command above takes each line in the "SRR_numbers.txt" file and asks for the fastq files. This may take a long time (potentially a really long time). It may also time out (fastq-dump is a little unstable). If you have lots of trouble we can talk about other strategies.

I suggest you put all of your fastq files in one folder inside your project directory called "fastq"

&nbsp;

## Estimating gene expression per contig
Now we can use the assembly and the fastq files to estimate gene expression levels. For this project, I think we will use the program [salmon](https://salmon.readthedocs.io/en/latest/salmon.html#using-salmon) because it is very fast and seems to perform well. The link above has a great tutorial. See if you can use salmon to quantify gene expression for one of your samples (use the method for mapping based quantification). If you can do that, you can quantify all of your samples in a batch.

## Scripts
In general, you shouldn't be running much straight from the command line. To add a job to the cluster queue you will need an sbatch script. 
The download.sbatch script can be use for downloading data. You will just need to change the project ID. You can submit jobs like this:

```{bash}
> sbatch download.sbatch
```

