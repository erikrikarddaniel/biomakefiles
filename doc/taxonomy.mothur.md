# Determining amplicon taxonomy with Mothur

In this document we describe how to determine the taxonomy of 16S or 18S rRNA
sequences with [Mothur's Classify.seqs](https://mothur.org/wiki/Classify.seqs)
method, the SILVA database and library makefiles from this repository.

## Install Mothur and download databases

The [download page at the Mothur site](https://mothur.org/wiki/Download_mothur)
provides links to download both Mothur and databases.

(At least Ubuntu includes a `mothur` package, which is easy to install via
`apt`.)

After installing, make sure you have a working `mothur` program in your path:

```bash
$ which mothur
$ mothur --version
```

### SILVA database(s)

Make sure you download at least one of the SILVA databases. At the time of
writing, the most recent version is 128 and there are two variants: the 
non-redundant (NR) and the seed version. I use the former, but both should
work.

The database can be downloaded either to the directory where you will run the
analysis, or to a more central directory to which you point in the project
directory. The latter is better if you have several projects that you will use
the  files for.

## Workflow

### Preparing a directory

To run Mothur with a SILVA database on your sequences, you need a directory
with a fasta file (ending with `.fna`), links to the `.align` and `.tax`
database files and a `Makefile` that includes the `lib/make/makefile.mothur`
from this repository. 

Personally, I create symbolic links to the `.align` and `.tax` database files
called `silva.mothur.nr.alnfna` and `silva.mothur.nr.taxonomy` respectively,
which is the default in the library makefile, but you can override this.)

If you follow this suggestion, your `Makefile` should look like this:

```make
include *path_to_biomakefiles*/lib/make/makefile.mothur
```

If your database files are called something else, e.g. the default names of the
128 release from the download page: `silva.nr_v128.tax` and
`silva.nr_v128.align`, the file should look like this:

```make
include *path_to_biomakefiles*/lib/make/makefile.mothur

SILVA_TEMPLATE_FILE = silva.nr_v128.align
SILVA_TAXONOMY_FILE = silva.nr_v128.tax
```

*Note* that the macro definitions *must* come after the `include` row.

### Running `mothur`

Assuming your fasta file is called `sequences.fna`, you should now be able to
start `mothur` like this:

```bash
$ make sequences.nr.wang.taxonomy.tsv.gz
```

As usual, it doesn't hurt to try the command with `-n` before actually
executing it.

When the program finishes, you should have a tab separated file with sequence
names and the taxonomy hierarchy as a semicolon (;) separated string with 
quality scores. The hierarchy contains the well known ranks from domain down to
genus.
