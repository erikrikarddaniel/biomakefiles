# Correcting amplicon reads with DADA2

This document describes how to correct errors in Illumina amplicon reads with the 
[DADA2](http://benjjneb.github.io/dada2/) algorithm as packaged in my
[eemisdada2](https://github.com/erikrikarddaniel/eemisdada2) repository. It uses
the library makefile `makefile.dada2` which assumes that the three scripts in the
eemisdada2 repository are installed and available in your PATH variable.

## Workflow

### Checking quality profiles

To be able to set program parameters properly, you need to find out what the 
quality profiles of your sequences look like.
