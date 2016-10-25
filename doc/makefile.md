# Introduction: Using Make to automate steps in workflows

NOT FINISHED YET.

# Library makefiles

To automate general tasks I have written a set of library makefiles, typically
one per *major program*, i.e. one each for the aligners Diamond and LAST
respectively. You use such a library makefile by writing a `Makefile` in an
analysis directory containing an `include` statement which calls in the library
makefile. In some cases this suffices, but in most cases you will add other
statements -- macros and targets -- to the `Makefile`. You never need to edit
the library makefile, unless there's something wrong in it. (If you find a
mistake, file a bug at GitHub: https://github.com/erikrikarddaniel/biomakefiles.)

An example of a `Makefile` (note capital "M") in a directory you run the LAST
aligner:

```make
include  /usr/local/lib/make/makefile.last

# Override default LAST options to use 8 cpu threads and keep only hits with at
# least 200 score.
#
# Important: This must come *after* the include, since defaults for options are
# set in the library makefile. By setting the value here, you *override* that.
LAST_OPTS = -P8 -e200 ```
```
