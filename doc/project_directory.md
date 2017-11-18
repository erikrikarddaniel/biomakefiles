# Setting up a new project directory

This explains how I usually set up my project directories. The general
principle is to have one directory for each type of program to run -- quality
control, assembly, annotation etc.

The below assumes you have created a directory which will serve as the *root
directory* for the project. Let's call the directory `project_root`. You create
that like below, standing somewhere suitable, e.g. `projects` in your home
directory.

```bash
$ mkdir project_root	# Create the directory
$ cd project_root	# Change to the newly created directory
```

## Placing a symlink to the biomakefiles repository

To make it easier to transfer your data to anothe file system, and allow some
of the benefits of Git (see below) you should create a symbolic link to a
"production", i.e. stable, branch of the biomakefiles GitHub repo in the root
directory of the project. Assuming you have checked out the master branch at
*path*/biomakefiles, you create that symlink like this:

```
$ ln -s path/biomakefiles .
```

If you need to change where you keep the biomakefiles, just change (delete and
create a new) that symlink.

`include` directives in the `Makefile` of directories should be *relative
paths* to the above link.

## Root directory Makefile

There is a library makefile also for the root directory `lib/make/makefile.rootdir`.
At the time of writing this is only to produce a statistics file. To use this,
create a `Makefile` looking like this:

```make
include biomakefiles/lib/make/makefile.rootdir
```

## Using screen

If you want to use `screen` in your project, you can copy a template `.screenrc`
file from my GitHub hosted `dltemplates` repository
(https://github.com/erikrikarddaniel/dltemplates).

```bash
$ cp path/dltemplates/misc/screenrc .screenrc
```

Add whatever `chdir` and `screen -t` directives you wish to that.

## Using Git in project directories

*Skip* to the next section *Directory structure* if you don't want to use Git.

[See setting_up_git.md](setting_up_git.md)

## Setting up an Rstudio project

[See setting_up_rstudio.md](setting_up_rstudio.md)

## Directory structure

I prefer to keep files organized after the type of analyzis they are used in. In
most cases this means adding a directory for each new type of analysis run, but
here's a summary of a few commonly used directories and subdirectories:

```bash
project_root/			# Raw sequencing files and overall statistics
  assembly/
    megahit/
    ray/
  qc/
    erne/
      standard-filter/		# ERNE-filter for added standards
      rrna-filter/		# ERNE-filter for rRNA
    sickle/
  read-oriented-analyses/
    diamond_megan/		# Diamond .daa files plus meganized versions
  samples/			# Symlinks to record which sequence files belong to which sample
```

NOTE: If you're using Git, note that you can't add an empty directory to the
repo. To come around this, add either a `.gitignore` file (perhaps from this
repo) or an empty `.gitkeep`. The latter is easilly done like this:

```bash
$ mkdir qc/
$ touch qc/.gitkeep
$ git add qc/.gitkeep
```

## Raw sequencing (fastq) files

I typically keep the original fastq files in the root directory of the project.
Since sequencing files have technical names and not sample names, I create
symbolic links ("symlinks") in a subdirectory: `samples` where each file has a
meaningful name pointing to the original fastq.gz file.

I also change the way the individuals of the read pairs are designated from a
`_1` and `_2` respectively to `.r1.` and `.r2.` respectively.

```bash
$ mkdir samples
$ cd samples
$ ln -s ../original_name_tag0_1.fastq.gz sample0.r1.gz
$ ln -s ../original_name_tag0_2.fastq.gz sample0.r2.gz
$ ln -s ../original_name_tag1_1.fastq.gz sample1.r1.gz
$ ln -s ../original_name_tag1_2.fastq.gz sample1.r2.gz
```

Since these files are only symlinks, they can be added to a Git repo. This will
document which sample pointed to which sequencing file. Since you probably have
a `.gitignore` that refuses .fastq files, you will have to use the -f flag.
*Make an extra check* that you actually have symlinks!

```bash
$ ls -l *.fastq.gz	# Shows if files are symlinks or not
$ git add -f *.fastq.gz	# Only proceed with this step if you're certain
```

From now on, whenever you need the *raw, unprocessed* fastq files in any of
your directories, symlink to the symlinks in the `samples` directory!

Assuming you have transferred your fastq files (in gz format!) to the root
directory, created symlinks in the `samples` directory and want to the files in
the qc directory, you can:

```bash
$ cd qc
$ ln -s ../samples/*.fastq.gz .
```

To assemble statistics about the samples, create a `Makefile` that includes the
`lib/make/makefile.samples` and run this command:

```bash
$ make samples.stats.long.tsv
```

(After that, update the statistics file in the *root directory*: `make
stats.long.tsv`.)

## Analysis directories

For each type of analysis you want to perform, the basic steps are the same:

1) Create the directory

The directory name should reflect the type of analysis. Often, as e.g. with
assembly, several programs are tried for the same purpose. For these cases it is
clearer to group the real analysis directories in a parent directory (e.g.
`assembly/metahit`).

2) Create a `Makefile` that includes one or more library makefiles

In this repository there are several library makefiles (see `lib/make`) that
defines targets that make it easier to run a certain program. To use them, write
a `Makefile` in the analysis directory in which you start by calling the library
makefile. E.g., if you want to include `lib/make/makefile.last` from the
`path/biomakefile` directory you create a Makefile that contains this row:

```make
include path/biomakefile/lib/make/makefile.last
```

Each library makefile has documentation on each target and possible extra
options. [Also see makefile.md](makefile.md).

3) Create symlinks to whatever files are required

4) Add a `.gitignore`

There may be a template file in this repo (`lib/gitignores`).

5) Add the directory with content to Git

To make sure you don't add too big files, do a `git status` first to check what
git considers files in its domain. If very large files are present, add the
suffixes of them to the `.gitignore` in this directory.

```bash
$ git status	# Check what files git sees
$ git add .	# MAKE SURE YOU HAVE GITIGNORE BEFORE!!!
$ git commit
$ git push
```

6) Start the analysis

Some types of analyses might get their own documentation one day.
