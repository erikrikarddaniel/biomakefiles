# Setting up a new project directory

This explains how I usually set up my project directories. The general
principle is to have one directory for each type of program to run -- quality
control, assembly, annotation etc.

The below assumes you have created a directory which will serve as the *root
directory* for the project. Let's call the directory `project_root`. You create
that like below, standing somewhere suitable, e.g. `projects` in your home
directory.

```
$ mkdir root_directory	# Create the directory
$ cd root_directory	# Change to the newly created directory
```

## Using Git in project directories

In addition to showing how the directory structure should be, I will also show
how I setup a directory structure to use Git, a version control software. Git is
documented elsewhere in more detail, but I will in this document repeat how to
perform some common tasks. Of importance here is that project directories will
contain files that are under version control by Git, *as well as* **files that
are not**. The latter applies to large files, e.g. raw sequence files and large
fasta files. 

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
