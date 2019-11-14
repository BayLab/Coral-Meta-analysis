# RNASeq-Pipeline
This repository contains scripts and hints for processing RNASeq data for gene expression analysis

## Working on XSEDE Bridges

For most of our computational needs, we will use the Bridges supercomputer, which is part of the XSEDE program. If you do not already have an account, click [here](https://portal.xsede.org) and set one up. Then send your user name to Rachael and she will add you to the lab account.

Once you have an account, you can log in through the single sign on hub. Directions here:  https://portal.xsede.org/single-sign-on-hub

&nbsp;

## Download your data
First, we need to get our data onto XSEDE. Make sure you are working in your pylon5 directory, otherwise you will run out of room. Make a new folder for your project.

You will need two types of data:
1) Transcriptome or genome assembly
2) fastq files containing sequence data for each sample

If a transcriptome assembly does not exist, you may have to make your own. We won't cover that here.

How you download your data will depend on where it is currently located. Here are some tips:
*If it is on a server from the sequencing center, try `wget`. 
*If it is on NCBI, check out [this tutorial for downloading from the short read archive](https://www.ncbi.nlm.nih.gov/sra/docs/sradownload/).
*If the data are on your computer, consider `scp` or `rsync`

&nbsp;

## Index the transcriptome assembly



