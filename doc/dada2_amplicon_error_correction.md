# Correcting amplicon reads with DADA2

This document describes how to correct errors in Illumina amplicon reads with the 
[DADA2](http://benjjneb.github.io/dada2/) algorithm as packaged in my
[eemisdada2](https://github.com/erikrikarddaniel/eemisdada2) repository. It uses
the library makefile `makefile.dada2` which assumes that the three scripts in the
eemisdada2 repository are installed and available in your PATH variable.

To check that you have installed everything correctly, run the three scripts with 
the --help flag:

```bash
$ dada2filter --help
$ dada2errmodels --help
$ dada2correction --help
```

## Workflow

### Checking quality profiles

To be able to set program parameters properly, you need to find out what the 
quality profiles of your sequences look like. There are tools in R for this (see
e.g. [DADA2 workflow example](http://benjjneb.github.io/dada2/tutorial.html)), but
you can also use e.g. FastQC (`makefile.fastqc`).

### Trimming sequences

DADA2 requires all sequences to be of equal length and you hence need to decide at which
lengths to cut forward and reverse reads respectively. The quality profiles should allow 
you to decide. You set this by overriding the `DADA2FILTER_TRUNCLEN` macro in your Makefile.
You can also override the `DADA2FILTER_OPTS` (all options except --trimleft and --trunclen)
and `DADA2FILTER_TRIMLEFT` macros. Check the defaults for these in the makefile.

Assuming you have an updated `biomakefiles` repository in the parent directory to your
data directory, a `Makefile` may look like this:

```make
include ../biomakefiles/lib/make/makefile.dada2

# This line is mandatory, set to good values for forward and reverse read lengths
# respectively
DADA2FILTER_TRUNCLEN=250,200

# There's a 8,8 option for this, so you don't need to set it
DADA2FILTER_TRIMLEFT=10,10

# The DADA2FILTER_OPTS is set to --verbose, which is good in most cases
```

With the above makefile, you're ready to perform the truncation. First run 
`$ make -n dada2filter.out` to check that everything is working, then run the real command:

```bash
$ make dada2filter.out
```
