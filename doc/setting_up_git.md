# Using Git in project directories

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

## Copy .gitignore

In this repository, in the directory `lib/gitignores` there's are files that can
be used to start with. For the *root directory* of a project there is:
the file `project_root.gitignore`. Copy that to the root
directory of the new project; make sure it's called `.gitignore`.

```bash
$ cp *path_to_biomakefiles*/lib/gitignores/project_root.gitignore .gitignore
```

## Initialize the directory for Git and add a remote

To initialize the directory structure, you just run the below command standing
in the project root directory. With this, your project becomes a Git repository,
or "repo":

```bash
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

```bash
$ git remote add origin user@system:project.git
```

Now, you're ready to add the single file (the .gitignore), commit and push to
the remote directory:

```bash
$ git add .
$ git commit
$ git push --set-upstream origin master
```


