# Get started with metagenomics/-transcriptomics project

This document aims at describing how to get started using the tools in this
repository to annotate a metagenomics or metatranscriptomics project.

Basic UNIX/bash knowledge is required including how to use a text editor (nano,
vim, emacs, ...).

## Cloning the biomakefiles repository

You need a local copy of all the files contained in this repository. Assuming
you want to keep them under `dev` in your home directory:

```bash
$ cd dev
$ git clone https://github.com/erikrikarddaniel/biomakefiles.git
```

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
in this directory. You should hence create a file called `Makefile` using a text
editor (gedit, vim, nano, ...). Here's an example:

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

FastQC takes a little while. If you have several cpus or cpu cores you can speed
it up by running several programs in parallel (assuming you have 24 free cores):

```bash
$ make -j 24 all_fastqc
```

When the program is finished you should have one html file and one zip file for
each sample file. Take your time to look through the html reports, and discuss
with colleagues and search the net to investigate possible issues.

You can view the html files using a browser, e.g. firefox, over X. Firefox
requires a flag to force it to run over X in case there's a local Firefox
process running:

```bash
$ firefox -no-remote
```

### ERNE for trimming and filtering

ERNE is a mapper that can be used to filter out contamination, but can also trim
sequences. Read more [here](running_erne.md). Here, I'm going to show you how to
run ERNE to filter out internal standard sequences and trim reads in one step.

#### Create the standards database

If you added internal standards to your samples you probably already have the
sequences. Assuming you have them in `path/st_dna.fasta` and `path/st_rna.fasta`
you can create a single file in the project root directory and add the
`makefile.erne` to the root `Makefile` like this:

```bash
$ cat path/st_dna.fasta path/st_rna.fasta > standards.fna
$ echo 'include ./biomakefiles/lib/make/makefile.erne' >> Makefile
```

*Important*: Note the double `>` above! If you use only one, you will overwrite
the content of the `Makefile`, with two you *append*.

Formating the ERNE database takes a little while but is simple:

```bash
$ make standards.ebh
```

#### Running ERNE filter

To run ERNE, all you have to do is the usual steps: create directory, symlinks,
`Makefile` and run `make`.

```bash
$ mkdir -p qc/erne/standard-filter
$ cd qc/erne/standard-filter
$ ln -s ../../../samples/*.fastq.gz
```

The last line, creating symlinks should be different if this is a *second*
filtering run, because then you want to link to the output from the first
filtering step. An example if this situation is when you have added 
internal standards to a transcriptome and want to first remove (and quantify)
the standards and then remove rRNA.

The `Makefile` should look something like this (exactly like this if you
followed the above instructions):

```make
include ../../../makefile.commondefs
include ../../../biomakefiles/lib/make/makefile.erne
include ../../../biomakefiles/lib/make/makefile.misc

# Here, you can set any other ERNE options than the path to the contamination
# database. See ERNE's documentation.
ERNE_OPTS = --threads 4

ERNE_REFERENCE = ../../../standards.ebh

# Define this number to get statistics output in the order programs were run
STAT_ORDER = 00100
```

There are many options for parallelization of ERNE ([see
running_erne.md](running_erne.md)). To make it simple here, assuming you have 16
cpu cores at your disposal and with the above `Makefile` (`ERNE_OPTS = --threads
4` definition) you can run four parallel ERNE processes, each using four cores,
like this:


```bash
$ make -j 6 fastq.gzs2erne-filters
$ make erne-filter.stats.long.tsv
$ ( cd ../../../; make stats.long.tsv )
```

(The last two lines updates statistics files.)

### QC conclusion

What you have after filtering with ERNE are quality-trimmed reads free from any
contamination you have thought of. The reads can now be used for further
processing like assembly or alignment to a database. This document will continue
with a description of how to merge the forward and reverse reads using PandaSEQ
and how to annotate the merged reads with Diamond and MEGAN against the NCBI
RefSeq database.

## Merging pairs with PandaSEQ

If your reads are sufficiently long compared to the length of the fragments that
were sequenced -- a not uncommon case with RNA -- you can merge the forward and
reverse reads using e.g. PandaSEQ. To do this with the tools in the
`biomakefiles` repository you just perform the usual steps: create a directory,
symlink the output fastq files from the last step of ERNE, create a Makefile and
run:

```bash
$ mkdir -p assembly/pandaseq
$ cd assembly/pandaseq
$ ln -s ../../qc/erne/standards-filter/*.fastq.gz  # Modify if you ran more than one ERNE filter
```

The Makefile can look like the following:

```make
include ../../biomakefiles/lib/make/makefile.pandaseq
include ../../makefile.commondefs

PANDASEQ_OPTS = -T 2
STAT_ORDER = 00300
```

If you have 16 cpu cores available and with the above Makefile, you can run 8
pandaseq processes in parallel.

```bash
$ make -j 8 fastq.gz2pandaseqs
$ make pandaseq.stats.long.tsv
```

If you want to proceed with this data or not is largely dependent on how many
pairs were merged so check the `pandaseq.stats.long.tsv` file and compare the
numbers with the number of input reads before deciding (both numbers plus the
number of unmerged are written to the stats file `pandaseq.stats.long.tsv`).
Note that both merged and unmerged reads are output, but in different files
ending with `.pandaseq.fna.gz` and `.

## Aligning reads to the NCBI RefSeq database with Diamond

Diamond is a very fast BLAST-like program that aligns nucleotide or protein
sequences to a *protein* database (i.e. blastx and blastp functionality).
