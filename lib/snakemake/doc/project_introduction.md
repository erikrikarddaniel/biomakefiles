#PROJECT PINHASSI_SEQUENCING

This guide aims at providing a reproducible, user-friendly workflow to manage RNA or DNA data coming from Next Generation Sequencing (NGS), be it transcriptomes, metagenomes or amplicones.
##Getting started
Here a workflow consisting in an organized collection of files for the UNIX environment is provided. It is therefore important to fulfill a series of prerequisites before using it. 

###Organize a directory structure
The scripts provided by this Git Repo are meant to be used in a work environment with a precise folder hieracy. First of all, a folder that roots the entire project should be created:
```
$ mkdir project_name	# Create the root directory
$ cd project_name	# Change to the newly created directory
```
This directory will be called from now on _root directory_ and shall contain all the data and files related to said project. It is advisable to crate a directory for each step of the workflow, i.e. for each software you are planning to use. In this way, the outputs produced from every different software will be stored in their respective directory. For example, if the softwares FastQC, Sickle and cutadaptor are expected to be used in the preprocessing step, 
the command line should be:
```
$ mkdir qc
$ cd qc
$ mkdir fastqc sickle cutadaptor # Create a folder for each software
```

Thus, the consequent folder organization would be :
```
project_root/			# Raw sequencing files and overall statistics
 qc/                            
  sickle/                       # outputs of sickle
  fastqc/                       # outputs of FastQC and MultiQC
  cutadaptor/                   # outputs of cutadaptor
``` 

###Symlinks preparation

###Using Conda

###Executing Snakemake
Snakefiles: You can see it as a series of "recipies" with which "cooking" your data.

