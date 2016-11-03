# Get started with metagenomics/-transcriptomics project

This document aims at describing how to get started using the tools in this
repository to annotate a metagenomics or metatranscriptomics project.

Basic UNIX/bash knowledge is required including how to use a text editor (nano,
vim, emacs, ...).

## Project root directory

Create a directory which will serve as the root directory for your project.
Assuming you have a root for *all* projeccts called `projects`:

```bash
$ cd projects
$ mkdir new_project
$ cd new_projects
```

### Copying fastq files

Copy the sequence files from wherever you have them stored. The UNIX command
`cp` is perhaps simplest (assuming your fastq files are gzipped and hence end
with `.gz`):

```bash
$ cp sequence_source_dir/*.fastq.gz .
```

### Symlinking the `biomakefiles` repository

It will be *much* easier for you in the long run if you can refer to the
library makefiles in biomakefiles if you can refer to them by a path that is
relative to the project directory structure. Assuming you have cloned the
repostiroy in a directory called `~/dev/biomakefiles`, you can create a symbolic
link thus:

```bash
$ ln -s ~/dev/biomakefiles .
```

### Creating a Makefile

You are not going to work in the root directory except to generate summaries of
annotation, but there are still a few things that will be useful in a `Makefile`
in this directory. Here's an example:

```make
include ./biomakefiles/lib/make/makefile.seqroot
include ./biomakefiles/lib/make/makefile.erne
include makefile.commondefs
```

The last line includes a project specific file that will be included by all
makefiles in subdirectories and can hence contain any project-specific
information that is common to all types of analyses you will perform. At the
time of writing I only use this to enumerate the sample names:

```make
SAMPLES = s0 s1 s2 ... sn
```

### Copy skeleton `annotation_statistics.rmd`

The `annotation_statistics.rmd` file is a skeleton R markdown script to help you
generate summary statistics from the various steps in the annotation process.
To be really useful you will have to edit it, but for the moment just copy it.
At the same time you can copy a skeleton Rstudio project file, if you wish --
it's easy to create one directly in Rstudio too:

```bash
$ cp biomakefiles/lib/R/annotation_statistics.rmd .
$ cp biomakefiles/lib/R/project.Rproj new_project.Rproj
```

### Copy `project_root.gitignore` to `.gitignore`

I won't go into (what Git can do for you here](setting_up_git.md), but to be on
the safe side in case you later decide Git might be a good idea, copy the
project `.gitignore` to the root directory:

```bash
$ cp biomakefiles/gitignores/project_root.gitignore .gitignore
```

*Note* the period as the first character of the filename -- important!

## `samples` directory

The primary reason for this directory is to record the mapping between your
sample names and the names of files from the sequencing machine, i.e. a map in
the form of symbolic links from the actual fastq files in the root directory to
files with sample names in this directory. You create the directory and symlinks
similar to this:

```bash
$ mkdir samples
$ cd samples
$ ln -s ../seqfile_1.fastq.gz s0.r1.fastq.gz	# Repeat for all forward read files
$ ln -s ../seqfile_2.fastq.gz s0.r2.fastq.gz	# Same for reverse reads
```

*Note* that I use the file name suffixes `.r1` and `.r2` instead of the Illumina
standard `_1` and `_2`. You have to do the same if you want to use the tools
here.

### Makefile

The `Makefile` is similarly simple as in the root directory:

```make
include ../biomakefiles/lib/make/makefile.samples
include ../makefile.commondefs
```

### Generate statistics

With this you're ready to generate the first statistics files, here and in the
root directory:

```bash
$ make samples.stats.long.tsv	# Takes a while, counting rows in fastq files
$ cd ..
$ make stats.long.tsv
```

As the name indicates the file is in tab separated format and is "long" in the
"tidyverse" sense, i.e. contains one observation per row. The file in the
project root directory is just a concatenation of similar files from various
subdirectories. You can start Rstudio from the root directory and open the
`annotation_statistics.rmd` Rmarkdown file.

## Quality trimming and filtering

The sequences in fastq files contain quality scores, estimates of the
reliability for each nucleotide, encoded as "phred scores". One typically trims
sequences before proceeding with annotation and other steps to get rid of poor
quality nucleotides. 

### FastQC

FastQC is a diagnostics tool that will show you how good your sequences are and
if they contain problematic sequences such as adapters or duplicates. FastQC can
be run interactively (a Java GUI (graphical user interface) application) or in
command line mode. The latter will generate HTML-formated reports that can be
viewed in a browser, and is what I'll show here.

The sequence of actions is the same as for most tasks here: create a directory,
symlinks, a Makefile (in this case only a line, so I'll include it below) and
run `make`.

```bash
$ mkdir -p qc/fastqc
$ cd qc/fastqc
$ ln -s ../../samples/*.fastq.gz .
$ echo 'include ../../biomakefiles/lib/make/makefile.fastqc' > Makefile
$ make all_fastqc
```

When the program is finished you should have one html file and one zip file for
each sample file. Take your time to look through the html reports, and discuss
with colleagues and search the net to investigate possible issues.


