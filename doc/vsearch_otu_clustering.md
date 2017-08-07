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
option), do so by setting the `SICKLE_OPTS` macro like this:

```make
SICKLE_OPTS = -q 30
```

You can run Sickle on all read pairs like this:

```bash
$ make -n fastq.gz2pesickle  # Showing what would be run
$ make fastq.gz2pesickle     # Running for real
```

## Joining (merging) read pairs

After trimming sequences you should join the forward and reverse reads into a 
single longer sequence. One program that does this is 
[PEAR](http://sco.h-its.org/exelixis/web/software/pear/).

Create a new directory, e.g. `assembly/pear`, in which you collect symlinks to
the `r1` and `r2` fastq files from Sickle, i.e. dismissing the unpaired reads in
the `single` files. The Makefile should look like this:

```make
include ../../makefile.commondefs
include ../../biomakefiles/lib/make/makefile.pear

# This controls the number of threads uses. Don't set higher than the number of
# computing cores you have.
PEAR_OPTS = -j 24

gzip_all_fastqs: $(subst .fastq,.fastq.gz,$(wildcard *.fastq))

%.fastq.gz: %.fastq
        gzip $<

concat_unassembled: $(subst .r1.fastq.gz,.concat.fastq.gz,$(wildcard *.unassembled.r1.fastq.gz))
```

And you're ready to run:

```bash
$ make -n fastq.gzs2pears
$ make fastq.gzs2pears
```

## OTU clustering with VSEARCH

The OTU clustering consists of a couple of steps: dereplication, i.e. collecting all
identical sequences in one fasta entry (with a count), chimera removal, OTU clustering
and quantification, i.e. mapping back reads to clusters. All of the steps are performed
in the same directory with a single Makefile.

Create a directory, e.g. `otu_clustering`, and create symlinks to the `*.assembled.fastq.gz`
from PEAR above. Write a Makefile that looks like this:

```make
include ../../makefile.commondefs
include ../biomakefiles/lib/make/makefile.vsearchotus
include ../biomakefiles/lib/make/makefile.misc
```

### Create a fasta file with all sequences and dereplicate

Dereplication will identify all identical sequences and replace them with a single one,
although with a count in the header. Moreover it will sort sequence in descending order
of abundance to make sure that the must abundant sequences end up as seed sequences in
clusters.

In this step, we also get rid of very rare sequences (by default singletons, i.e. sequences
only observed once over all samples) and sequences that are likely too short. This is the
(current) default for options as defined in the makefile:

```make
VSEARCH_DEREP_OPTS = --minuniquesize 1 --minseqlength 300
```

It will filter out singletons and sequences that are shorter than 300 nucleotides, which I
think is fine if you already merged pairs. Override this macro in your own <code>Makefile</code>
if needed (remember to put the new definition ''after'' the line where you include the librar
makefile).

Now you can run the dereplication:

```bash
$ make -n samples.derep.fna  # Just to check
$ make samples.derep.fna
```

### Get rid of chimeras

After dereplication you're ready to remove chimeras.

```bash
$ make samples.derep.nochim.fna
```

### OTU clustering

Now your data is ready for OTU clustering. This will be performed at a number of identity
levels; look in the library makefile for what the <code>DEREP_CLUSTER_LEVELS</code> macro
is set to. You can of course define your own levels by overriding that macro. Otherwise,
there are no options to set.

```bash
$ make samples.derep.nochim.clusters
```

### Quantification

After clustering you will want to calculate counts for OTUs:

```bash
$ make samples.derep.nochim.counts
```

This will produce a set of long files, one for each clustering levels, with a `.tsv` suffix 
their names.
