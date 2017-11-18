# Introduction: Using Make to automate steps in workflows

Make is originally a tool for programmers but happens to have features that 
make it a good choice for automation of steps in computational workflows.

* It is installed in all computers with UNIX-like operating systems (including 
Linux)

* It handles *dependencies* and can calculate which intermediate steps are 
required for a certain goal. This also means it only runs a program if it has not
yet been run, or if the input files have been updated.

* It has built in support for running programs in parallel

* It documents *how* a program is/was/will be run

## Simplest case: hardcoded target and dependencies

Make calls other programs and needs instructions for how to do that. The instructions
are contained in a file, in most cases called `Makefile`. If, for example, you wish
to instruct Make how to run the assembly program megahit on a pair of gzipped fastq 
input files, you create a `Makefile` looking like this:

```make
my_assembly.megahit_out: forward_reads.fastq.gz reverse_reads.fastq.gz
        megahit -1 $< -2 $(word 2,$^) -o $@
```

The actual command is the line starting with a **tab** (this must be a tab and not
a number of spaces), while the line above specifies the *target* (the name before
the colon) and dependencies (filenames after the colon). The command line uses 
variables to refer to file names on the line above (`$<`: first dependency, `$^`:
all dependencies and `$@`: name of the target). The target can now be made, i.e.
the assembly run with the following command on the command line:

```bash
$ make my_assembly.megahit_out
```
## Next step: Pattern rules to allow reuse of rules

If you will run the same program many times on different input files of the same
type (from several samples for instance), you can save a lot of typing by writing
one *pattern rule* plus a rule that calculates what can be run from the files 
present in a directory. Assuming you have pairs of fastq files for five samples
called `sample1.r1.fastq.gz`, `sample1.r2.fastq.gz` etc., you can write a `Makefile`
looking like this:

```make
# Pattern rule for assemblies
%.megahit_out: %.r1.fastq.gz %.r2.fastq.gz
        megahit -1 $< -2 $(word 2,$^) -o $@
        
# Rule that calculates all possible assemblies that can be run
all_assemblies: $(subst .r1.fastq.gz,.megahit_out,$(wildcard *.r1.fastq.gz))
```

The first rule specifies how to run an assembly, the second a rule that is only
a *list of dependencies* created by looking at what pairs of sequence files are
present in the directory. Since Make is aware of chains of dependencies, calling
the target of the second rule will call the assembly program to "make" all possible
assemblies. The second rule does not have any instructions, which is fine as it's
only there to collect all the dependent assemblies. This is the command you would run:

```bash
$ make all_assemblies
```

If you think it would be faster to run a number of assemblies in parallel (it won't
in the case of megahit, but there are many cases when this is beneficial), you can 
tell Make to run e.g. four parallel asseblies like this:

```bash
$ make -j 4 all_assemblies
```

Note the `-j 4` flag, that's what tells Make to try to parallelize.

## Third step: Library makefiles

If you run the same program in different projects, you could save time by saving
Make rules you've written in a file that you call from `Makefile`s: library
makefiles. Assuming you've created a file called `some_dir/makefile.megahit` with 
the content of the last example above, you can include that in a `Makefile` like
below and call Make just like above:

```make
include some_dir/makefile.megahit
```

# This repository of library makefiles

To automate general tasks I have written a set of library makefiles, typically
one per *major program*, i.e. one each for the aligners Diamond and LAST
respectively. You use such a library makefile by writing a `Makefile` in an
analysis directory containing an `include` statement which calls in the library
makefile. In some cases this suffices, but in most cases you will add other
statements -- macros and targets -- to the `Makefile`. You never need to edit
the library makefile, unless there's something wrong in it. (If you find a
mistake, file a bug at GitHub: https://github.com/erikrikarddaniel/biomakefiles.)

An example of a `Makefile` (note capital "M") in a directory you run the LAST
aligner, *assuming* this directory is two levels below the root, where you
placed a clone of the biomakefiles repo ([see setting up project
directory](project_directory.md)):

```make
include  ../../biomakefiles/lib/make/makefile.last

# Override default LAST options to use 8 cpu threads and keep only hits with at
# least 200 score.
#
# Important: This must come *after* the include, since defaults for options are
# set in the library makefile. By setting the value here, you *override* that.
LAST_OPTS = -P8 -e200 ```
```
