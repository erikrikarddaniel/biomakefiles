# Setting up a new project directory

This explains how I usually set up my project directories. The general
principle is to have one directory for each type of program to run -- quality
control, assembly, annotation etc.

The below assumes you have created a directory which will serve as the *root
directory* for the project. Let's call the directory `project_root`. You create
that like below, standing somewhere suitable, e.g. `projects` in your home
directory.

```
$ mkdir project_root	# Create the directory
$ cd project_root	# Change to the newly created directory
```

## Root directory Makefile

There is a library makefile also for the root directory `lib/make/makefile.rootdir`.
At the time of writing this is only to produce a statistics file. To use this,
create a `Makefile` looking like this:

```
include path/biomakefiles/lib/make/makefile.rootdir
```

## Using screen

If you want to use `screen` in your project, you can copy a template `.screenrc`
file from my GitHub hosted `dltemplates` repository
(https://github.com/erikrikarddaniel/dltemplates).

```
$ cp path/dltemplates/misc/screenrc .screenrc
```

Add whatever `chdir` and `screen -t` directives you wish to that.

## Using Git in project directories

In addition to showing how the directory structure should be, I will also show
how I setup a directory structure to use Git, a version control software. Git is
documented elsewhere in more detail, but I will in this document repeat how to
perform some common tasks. Of importance here is that project directories will
contain files that are under version control by Git, *as well as* **files that
are not**. The latter applies to large files, e.g. raw sequence files and large
fasta files. 

*Skip* to the next section *Directory structure* if you don't want to use Git.

To make sure you not inadverdently add very large files to your Git repository,
you can place a file called `.gitignore` in a directory. The file will control
which types of files -- typically defined by file endings/suffices -- are added
by default to that directory and *any child directories*. By using several
`.gitignore` files one can hence gain detailed control of which files are added
to Git. Moreover, it is always possible add a file to Git even if it matches
a pattern in a `.gitignore` file by adding the `-f` (force) flag to `git add`.

### Copy .gitignore

In this repository, in the directory `lib/gitignores` there's are files that can
be used to start with. For the *root directory* of a project there is:
the file `project_root.gitignore`. Copy that to the root
directory of the new project; make sure it's called `.gitignore`.

```
$ cp *path_to_biomakefiles*/lib/gitignores/project_root.gitignore .gitignore
```

### Initialize the directory for Git and add a remote

To initialize the directory structure, you just run the below command standing
in the project root directory. With this, your project becomes a Git repository,
or "repo":

```
$ git init .
```

To become really useful, you should set up a "remote" for your repo. With this,
you can share your work between different computers and users and each user can
work on their branch to make sure you don't interfere with each other. (More
information on Git available e.g. at the GitHub help pages:
https://help.github.com/).

GitHub, where the repository this document is included in resides, is a public
Git server acting as remote for many projects. For many reasons (e.g.
privateness and space) you are probably better served by a *private* Git server
for your biological data. A popular choice is to set up a Gitolite server
(http://gitolite.com/gitolite/index.html) on a server you own yourself. To
access Git repositories from this, you just need ssh access.

Assuming you have setup a remote repo for your project, you specify the url for
this like this, again assuming you're standing in the project root directory):

```
$ git remote add origin user@system:project.git
```

Now, you're ready to add the single file (the .gitignore), commit and push to
the remote directory:

```
$ git add .
$ git commit
$ git push --set-upstream origin master
```

## Directory structure

I prefer to keep files organized after the type of analyzis they are used in. In
most cases this means adding a directory for each new type of analysis run, but
here's a summary of a few commonly used directories and subdirectories:

```
project_root/
  assembly/
    megahit/
    ray/
  qc/
  read-oriented-analyses/
    diamond_megan/
  samples/
```

NOTE: If you're using Git, note that you can't add an empty directory to the
repo. To come around this, add either a `.gitignore` file (perhaps from this
repo) or an empty `.gitkeep`. The latter is easilly done like this:

```
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

```
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

```
$ ls -l *.fastq.gz	# Shows if files are symlinks or not
$ git add -f *.fastq.gz	# Only proceed with this step if you're certain
```

From now on, whenever you need the *raw, unprocessed* fastq files in any of
your directories, symlink to the symlinks in the `samples` directory!

Assuming you have transferred your fastq files (in gz format!) to the root
directory, created symlinks in the `samples` directory and want to the files in
the qc directory, you can:

```
$ cd qc
$ ln -s ../samples/*.fastq.gz .
```

To assemble statistics about the samples, create a `Makefile` that includes the
`lib/make/makefile.samples` and run this command:

```
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

```
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

```
$ git status	# Check what files git sees
$ git add .	# MAKE SURE YOU HAVE GITIGNORE BEFORE!!!
$ git commit
$ git push
```

6) Start the analysis

Some types of analyses might get their own documentation one day.
