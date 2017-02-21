# OTU clustering with VSEARCH

[VSEARCH](https://github.com/torognes/vsearch) is a free alternative to the
[USEARCH](http://drive5.com/usearch/) clustering program. 

This document describes how to use VSEARCH to implement the UPARSE algorithm 
(Edgar 2013) for OTU clustering that by default uses USEARCH. In order not to 
reinvent the wheel too often, instead of using only VSEARCH the initial QC
steps will be shown here using Sickle and PEAR for which makefiles already
exist.

I'm assuming you have MiSeq sequences of at least 2x250 b so there's a reasonable 
chance forward and reverse reads overlap.

## Quality trimming with Sickle

With Sickle you can trim poor quality bases off your sequences. It has a 
paired end mode so that sequence pairs are kept together and pairs where only
one sequence remains after trimming are discarded.

Collect your gzipped fastq files -- following the `.r1.fastq.gz`/`.r2.fastq.gz` 
naming scheme (preferably symlinks to your `samples` directory symlinks so that
files have understandable names) -- in a directory (`qc/sickle`), , and create a 
Makefile looking like this (assuming a symlink to the `biomakefiles` repository 
in the project root directory):

```make
include ../../biomakefiles/lib/make/makefile.sickle
```

If you want to use another quality score cutoff than 20 (or set another Sickle 
option), do so by setting the `SICKLE_OPTS` macro.

You can run Sickle on all read pairs like this:

```bash
$ make -n fastq.gz2pesickle  # Showing what would be run
$ make fastq.gz2pesickle     # Running for real
```
