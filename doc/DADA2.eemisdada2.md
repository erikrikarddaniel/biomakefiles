# Correcting amplicon reads with DADA2

This document describes how to correct errors in Illumina amplicon reads with the 
[DADA2](http://benjjneb.github.io/dada2/) algorithm as packaged in my
[eemisdada2](https://github.com/erikrikarddaniel/eemisdada2) repository. It uses
the library makefile `makefile.dada2` which assumes that the four scripts in the
eemisdada2 repository are installed and available through your `PATH` variable.

To check that you have installed everything correctly, run the four scripts with 
the --help flag:

```bash
$ dada2filter --help
$ dada2errmodels --help
$ dada2cleanNmerge --help
$ dada2bimeras --help
```

## Workflow

All my make targets that involve fastq files assume:

1. Fastq files are gzipped and hence end with `.fastq.gz`

2. Forward and reverse reads are identified with `.r1.fastq.gz` and
`.r2.fastq.gz` respectively. This is because the way files are named by the 
instruments have tended to change over the years.

[See project_directory.md](project_directory.md) for more instructions on how
to set up your project.

### Checking quality profiles

To be able to set program parameters properly, you need to find out what the 
quality profiles of your sequences look like. There are tools in R for this (see
e.g. [DADA2 workflow example](http://benjjneb.github.io/dada2/tutorial.html)), but
you can also use e.g. FastQC (`makefile.fastqc`).

### Running DADA2

DADA2 requires all sequences to be of equal length and you hence need to decide at which
lengths to cut forward and reverse reads respectively. The quality profiles should allow 
you to decide. You set this by overriding the `DADA2FILTER_TRUNCLEN` macro in your Makefile.
You can also override the `DADA2FILTER_OPTS` (all options except --trimleft and --trunclen)
and `DADA2FILTER_TRIMLEFT` macros. Check the defaults for these in the makefile.

Assuming you have an updated `biomakefiles` repository in the parent directory to your
data directory, a `Makefile` may look like this:

```make
include ../biomakefiles/lib/make/makefile.dada2

DADA2_FILTER_OPTS    = --verbose --trimleft=8,8 --trunclen=250,250
```

There's a default setting for the `DADA2_FILTER_OPTS` macro that's suitable for
2x300 bp MiSeq sequences. However, the `--trunclen` (default 290 for forward,
210 for reverse reads) option might be worth looking into depending on
sequencing quality and length of your PCR product.

Assuming you have a set of gzipped fastq files ending with `.r1.fastq.gz` and
`.r2.fastq.gz` for forward and reverse reads (see above) in your current 
directory, you can run the whole process like this:

```
$ make dada2.cleaned.merged.bimeras.rds
```

(It never hurts to run with `-n` once before you run the actual command.)

If your uncertain about how e.g. your filtering settings will affect the 
outcome, you can also run one or more steps individually and check logs after
each step.

This will run *each* step individually:

```
$ make dada2filter.out
$ make dada2errmodels.out
$ make dada2.cleaned.merged.rds
$ make dada2.cleaned.merged.bimeras.rds
```
