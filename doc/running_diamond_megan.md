# Running Diamond/MEGAN

MEGAN is an annotation tool based on BLAST alignments to some database or
similar. 

It is thought to work on reads, which means it is quantitative directly. This
means BLAST is out of the question for any modern dataset, but an alternative
aligner, Diamond, has been developed by Benjamin Buchfink in collaboration with
the main author of MEGAN: Daniel Huson. Diamond is around five *orders of
magnitude* faster than BLAST, making it no big deal to align a couple of
flowcells worth of data to the NCBI RefSeq protein database.

MEGAN is a nice graphical application that allows nice visualizations as well as
some statistic tests both on the taxonomical composition of the data and a set
of different functional classifications: EggNOG, Interpro, GO. At the time of
writing I don't know about the status for the SEED classification.

(If one has assembled data, one can run Diamond/MEGAN, export the annotation,
add counts and reimport. Good if one wants one of the features of the graphical
interface, but not a nice hack.)

## Running Diamond

Diamond is, at the time of writing, a tool only for protein databases. It has a
blastx, as well as a blastp, mode though so one can align nucleotide sequences.

1) Download NCBI's RefSeq protein database

Target `mirror_refseq_protein.blast` in `biomakefiles/lib/mak/makefile.ncbidata`

```
$ make mirror_refseq_protein.blast
```

2) Convert to fasta format and the Diamond format

Targets in `biomakefiles/lib/mak/makefile.ncbidata` and
`/home/dl/dev/biomakefiles/lib/make/makefile.diamond`.

```
$ make refseq_protein.dmnd
```

3) Align

Targets in `biomakefiles/lib/make/makefile.diamond`

You must define the `DIAMOND_DB_PATH` macro to point to where the Diamond
formated database is (that's the directory where you ran the above steps). The
name of the latter *must be* `refseq_protein.dmnd`. 

A `Makefile` will look something like this:

```
include path/biomakefiles/lib/make/makefile.diamond

DIAMOND_DB_PATH = full_path_to_ncbi_data
```

To align a single fastq.gz file, `example.r1.fastq.gz`, to the NCBI RefSeq
protein database:

```
$ make example.r1.refseq_protein.daa
```

To run alignments of all fastq.gz files in the directory:

```
$ make fastq.gz2refseq_protein.daas
```

Diamond is a threaded application and will by default use all cpu cores it
finds. There is thus no need to use make's capabilities to parallelize this. If
you want to tweak cpu usage, e.g. because you're running other tasks, use the
`DIAMOND_ALIGN_OPTS` and set the Diamond `--threads=n` option in the `Makefile`
for that. E.g.:

```
include path/biomakefiles/lib/make/makefile.diamond

DIAMOND_DB_PATH = full_path_to_ncbi_data
DIAMOND_ALIGN_OPTS = --threads 8
```
