# Introduction: Using Make to automate steps in workflows

# Library makefiles

To automate general tasks I have written a set of library makefiles, typically
one per *major program*, i.e. one each for the aligners Diamond and LAST
respectively. You use such a library makefile by writing a `Makefile` in an
analysis directory containing an `include` statement which calls in the library
makefile. In some cases this suffices, but in most cases you will add other
statements -- macros and targets -- to the `Makefile`. You never need to edit
the library makefile, unless there's something wrong in it. (If you find a bug,
file a bug at GitHub: https://github.com/erikrikarddaniel/biomakefiles.)
