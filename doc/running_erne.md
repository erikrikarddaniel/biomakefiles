# Running ERNE


ERNE is a mapper, i.e. a fast alignment program for short reads typically used
to map reads to a genome. It has a special feature, however, that makes it a
good choice for projects containing sequences that should not be annotated
because they could mislead or make annotation slower. These sequences might
originate from host DNA (e.g. when sequencing human microbiota), added internal
standards or stable RNA in a transcriptome. ERNE in filter mode will map all
reads to a "contamination reference" that you create, throw away all sequences
that match the reference and report how many were discarded. It also *trims
sequences* making it a perfect tool for projects with contamination.  It's
available here:

http://sourceforge.net/projects/erne/

## Formating a database

A requisite for running ERNE is a formatted database. A target to format a
database from a nucleotide fasta file (suffix `.fna`) is available in the
`lib/make/makefile.erne` library makefile. Given a `Makefile` which includes the
`lib/make/makefile.erne` file and a fasta file (in the example named
`rrna_sequences.ebh`, all you need to do is:

```bash
$ make rrna_sequences.ebh
```

## Filtering mode

ERNE can be used to filter out sequences that matches a database of
"contaminants". The contaminants can be anything, e.g.  added internal standard
sequences, host sequence or stable RNA. In filtering mode all sequences that *do
not* match the reference are output so that they can be used downstream in the
annotation process. Furthermore, ERNE trims bad sequences in this step, making
it a good choice for quality control of samples where you have sequences you
want to get rid of.

### Creating a `Makefile` for filtering and running ERNE

The `lib/make/makefile.erne` library makefile contains targets to perform
filtering of paired read files in gzipped fastq files. In addition to including
the `lib/make/makefile.erne` file, you must define the `ERNE_REFERENCE` macro to
the full path of a formated ERNE database (see above) *including* the `.ebh`
suffix. Options and parameters to ERNE can be set using the `ERNE_OPTS` macro. A
`Makefile` file can look like this:

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

Given a pair of fastq files (name `s0.r1.fastq.gz` and `s0.r2.fastq.gz`) you can
run ERNE like this:

```bash
$ make s0.erne-filter
```

Output fastq files will have suffixes `erne-filter.rrna_sequences.r[12].fastq.gz`.

There will also be a log file (`s0.erne-filter`) that contains some statistics
on what ERNE found in terms of quality as well as contaminant/non-contaminant
sequences.

#### Running several ERNE processes in parallel

You can use `make` to parallelize tasks, in this case run ERNE on more than one
sample at the time. To do this, one add the `-j n` flag to `make`, where "n" is
the number of parallel tasks to run.

When you have several cpu cores at your disposal, maximizing performance can be
difficult because many programs, like ERNE, have parallelization internally so
it becomes difficult to decide if the fastest way to run is to run one ERNE
process at the time and telling it (via the `--threads n` option) to use all
available cores or if it's better to run several ERNE process in parallel. In
my, very brief, experience, letting a single ERNE process use four cores is
effective, but perhaps not so much more. If you have say 24 cores available you
could hence choose to start 6 ERNE processes in parallel (assuming nothing else
is running). To run ERNE on all pairs of fastq.gz files in the directory, and
with the above `Makefile` you just:

```bash
$ make -j 6 fastq.gzs2erne-filters
```

(Output will unfortunately be scrambled because of the six parallel processes
all writing to the screen. The output is collected in individual files however.)

#### Collecting statistics

After ERNE finished you can create a statistics file:

```bash
$ make erne-filter.stats.long.tsv
$ ( cd ../../../; make stats.long.tsv )
```

(The last line drops temporarily to the root directory and updates the global
statistics file.)

### Running ERNE filter more than once

If you have different *kinds* of contaminants and whish to know how much you
have of each of them, you can run ERNE more than once. I suggest you do that in
*different directories* with a single `Makefile` in each. Place symlinks to the
files produced by the former step in the directory where you run the next. Since
input sequences to the second run will be the result from the first run,
suffixes will be added to file names so that they can become quite long.
