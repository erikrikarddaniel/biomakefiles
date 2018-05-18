#Introduction to Snakemake and Conda

This is an introduction to Snakemake and Conda, which are reproducible, user-friendly tools to
manage prokaryotic data coming from Next Generation Sequencing (NGS), be it transcriptomes, 
metagenomes or amplicones.
##Getting started
In this Git repo you can find a workflow consisting in an organized collection of files for the
UNIX environment. It is therefore important to fulfill a series of prerequisites 
before using it, with particular reference to the **Workflow** chapter of (../README.md). 
##0.Using Conda
Software installation varies according to the software, this is where package managers come in aid.
Conda is a python-based manager that handles software installation and update. Python
knowledge is not required in order to use it. With Conda you can:
1.Readily upload a software and all its required dependencies at once.
1.Easily update the installed softwares.
1.store different versions of programs in different environments, because Conda is also an
environment manager. 
###Insatlling Conda
The quickest way to have Conda is to install Miniconda, a reduced version of Anaconda that includes
only Conda and its dependencies. First, check the System Requirements (https://conda.io/docs/user-guide/install/index.html#system-requirements "here").
if one or more of the requirements are missing, you can install these packages by evoking the
python wrapper apt:
```
apt install packagename
```
Once you will have fulfilled all the system requirements you can download and install Miniconda
from (https://conda.io/miniconda.html "here").You need to choose a Miniconda installers suitable
for your operative system.
miniconda executive files contain the conda package manager and a Python version between 3.6
(miniconda3) and 2.7 (Miniconda). It is advisable to choose Miniconda3 as most of the bioinformatics
tools in use are compiled in Python 3 and are not correctly interpreted by one of the versions of
Python 2. Regardless, it is possible to have both Pyhton 3 and Python 2 in the same operative system
by creating separate environments with conda, as shown in the next chapter.
For example, in order to get Miniconda3 for a LINUX environment of 64 bit, type:
```
bash Miniconda3-latest-Linux-x86_64.sh
```
you can know if conda has been correctly installed, and the number of the conda version, by typing: 
```
conda --version
```
The following command updates the version of conda in use to the latest version released:
```
conda update conda 
``` 
###Setting Conda environment and all the required packages
Conda can install and manage the thousand packages and repositories that are collected in the
Anaconda database. The all-purpose command for installing programs with conda is:
``` conda install -c namechannel namepackage ```
where the -c flag specifies the channel (e.g. namechannel) that contains said package
(e.g. namepackage). You can look for the channel that contains the package of interest in the
(https://anaconda.org/ "Anaconda Cloud").
Although conda works both with Pytho 2.7 and 3.6, python 3 is the only verson
that is being currently updated. Furtherly, programs like CheckM will support only particular
versions of Python (e.g. 2.7 for CheckM), so sooner or later you might need to create a conda
environment that stores a specific version of a software.
Suppose we have installed Miniconda3 and are interested in having both Python 2.7 and Python 3.6
available in the same account. The following command line creates a conda environment named pyton2.7
with Python version 2.7 installed in it:
```conda create --name python2.7 python=2.7```
Remember to ```source activate pythonenv``` for uploading the environment with the desired python
version.
An environment (i.e. environmentname) can be activated by typing ```source activate environmentname```
Conversely, ```source deactivate environmentname``` deactivate an environment
Check the name and number of stored environments:

```
conda info --envs
```
To see which packages are installed in your current conda environment and their version numbers, run:
```
conda list
```
Note that conda will mark with an asterisk the currently active environment.
##1.Organizing a directory structure
The libraries provided by this Git Repo are meant to be used in a work environment with a precise 
folder hieracy, see (project_directory.md) for help.  
##2.Creating a Snakefile in the work directory
Snakemake is a Pythonic variant of Make specifically addressed at creating reproducible and scalable
workflows. Snakemake can be installed with conda:
```conda install snakemake```
Instead of including a library makefile into a Makefile you might want to include a snakemake
library into a Snakefile. If that is the case you just need to create a new document and use the 
```include``` statement:
```echo "include: "../lib/snakemake/snakefile."" > Snakefile``` 
Snakemake includes all the perks of Make that were presented in (makefile.md), as well as some
differences: 
1. The workflow syntax is based on Python. However, rules accept either shell commands, Python
code or external Python or R scripts to create output files from input files.
1. Snakemake can set environments in which specific jobs will be carried out.
##3.Symlinks preparation
Symbolic links (symlinks) are files that contain a text string that is automatically interpreted by
the operating system as a path to another file or directory. Simply put, a symlink is a "shortcut"
to a target file. The symbolic location of a target file or directory is reported in the form of
an absolute or relative path. They represent practical tools to organize your computer resources
effectively. Why using symlinks instead of actual files?
1. Unlike file copies symlinks are mere labels, so that a consideable amount of disk memory can be saved.
1. They are a safety measure: in case you accidentally overwrite them the original file remains
unaffected, thus preventing from losing valuable information. Commands which read or write file
contents will access the contents of the target file. The rm (delete file) and mv (move) commands,
however, affect the link itself, not the target file. 
1. Symbolic links operate transparently: programs accept symlinks as input files, as long as they
redirect to existing files, and they will behave as if operating directly on the target file.
The scripts contained in the library of this Git Repo are based on symlinks with relative paths
and, as such, are meant to be used in a work environment with a precise folder hieracy.For each
software used, it is suggested to provide input data in form of symlinks with relative
paths. The importance of using relative paths lies in the fact that relative paths are based on
the hieracy of the work directories. That is, the scripts and links prepared with a relative path
will work in a work environment made of directories with a specific name and a specific directory
structure, see (project_directory.md) for further information. On the other hand, absolute path
include information about the username and, as such, they are user-specific and cannot work on
different accounts.
You can find out how to create symlinks ( "here").
##4. Rinning Snakemake
Snakemake determines the target and the programs to create it thanks to the rules contained
in a file usually named ```Snakefile```. You can see Snakefiles as cookbooks which contain
a series of "recipies" (rules) with which "cook" your "raw" data (in contrast to the target, which
is the dish you would like to obtain). Snakefiles report jobs in terms of rules, which define what
targets snakemake need to use in order to create output files starting from input files.
This is how ```Snake.fastqc``` looks like:
```
SAMPLES, = glob_wildcards("{smp}.r1.fastq.gz")
 rule all:
     input:
         expand("{smp}.r1_fastqc.zip", smp=SAMPLES)

 rule fastqc:
     input:
         fwd="{smp}.r1.fastq.gz",
         rev="{smp}.r2.fastq.gz"
     output:
         fwd="{smp}.r1_fastqc.zip",
         rev="{smp}.r2_fastqc.zip"
     threads: 10
     shell:
         "fastqc {input.fwd} {input.rev} -t {threads}"
```

```SAMPLES,``` (note the trailing comma) is a list of wildcards generated by the function ```glob_wildcards```.
Wildcards are written in curled brackets (i.e.```{smp}``` ) and are commonly used in order to run
snakemake recursively for all the desired input files (i.e.```*.r1.fastq.gz```). 
Snakemake workflow is divided into serveral rules. Each rule requires ```input``` files to produce
```output``` files. Similar to Make, in Snakemake you specify a general rule at the top of the Snakefile,
 ```rule all```, that just collects the final output. When a workflow is executed, snakemake tries to generate
the target files specified by ```rule all```, whose ```input``` is the final ```output``` of the workflow.
If no target is specified, Snakemake tries to apply the first rule in the workflow, determinig the
dependencies in a top-down manner. The function ```expand()``` takes a string like ```{smp}.r1.fastq.gz``` and
expands it into a list like ```SAMPLE,```. The ```rule fastqc``` specifies the intermediates and the instruction 
required to produce the final output. Multiple input and output files can be named (i.e. ```fwd=```, ```rev=```)
and can be referred by name in the ```shell``` (i.e. ```{input.fwd}``` , ```{input.rev}```).
All the Snakemake workflows provided by this Git repo can be run just by typing ```snakemake```.
However, we advise to see the execution plan of snakemake before the actual run, just like a test 
drive. The command to make a dry run is ```snakemake -np```.

##5.Producing statistics
There are no tools in the library snakemake for retrieving statistic from outputs at the moment
