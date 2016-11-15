# Starting a new processing step

This document details the steps typically needed to start a new processing step
in an already started project. In addition to the mandatory steps, it also
details what you would do if you run `screen` (a "window manager" for terminals)
or `git` (version control system).

The example below uses *program_name* as the name of the program doing the heavy
lifting for the new processing step.

1. screen: Open a new screen window: `<Ctrl-a>c`

2. screen: Change name of the window: <Ctrl->A

3. screen: Update .screenrc so that you automatically get the window next time you start screen.

```bash
$ vim .screenrc

	# This is what you add to .screenrc
	chdir $ROOT program_name
	screen -t program_name
```

4. Create the directory and cd into it:

```bash
$ mkdir program_name`
$ cd program_name
```

5. Create a Makefile, looking something like this:

```make
include ../biomakefiles/lib/make/makefile.program_name
STAT_ORDER = 00N00
NAME_OPTS = <program options, read the docs>
```

6. git: Add the Makefile to the repository

```bash
$ git add Makefile
$ git status
```

7. Create symbolic links to input files

8. Find the target that makes all outputs from present input files in the
   library makefile, run `make -n` to check and then run `make`, possibly with
   parallel jobs (`-j n`).

```bash
$ make -n target
-- CHECK --
$ make -j n target
```

9. When `make` is done, in the library makefile (the one you included in the
   Makefile above, i.e. `lib/make/makefile.program_name`) find the target that
   makes the statistics file and make that.

```bash
$ make program_name.stats.long.tsv
```

10. Change to the root window (assuming you're running screen; otherwise cd) and
    update global stats file.

```bash
$ make stats.long.tsv
```

11. git: Add files to repository, commit and push

```bash
$ git status
# Possibly edit .gitignore in the root directory
$ git add …	# Make sure you know that you're not adding large files
$ git commit -m “Message”
$ git push # Outside screen
```
