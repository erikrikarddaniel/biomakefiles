# Running ERNE

ERNE is a sequence read mapper, but with some extra features. It's available
here:

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
include path/lib/make/makefile.erne

ERNE_REFERENCE = dbpath/rrna_sequences.ebh

ERNE_OPTS = --threads 3
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

### Running ERNE filter more than once

If you have different *kinds* of contaminants and whish to know how much you
have of each of them, you can run ERNE more than once. I suggest you do that in
*different directories* with a single `Makefile` in each. Place symlinks to the
files produced by the former step in the directory where you run the next. Since
input sequences to the second run will be the result from the first run,
suffixes will be added to file names so that they can become quite long.
