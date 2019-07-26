# Installing DAS Tool partly with Conda

DAS Tool is AFAIK not available as a Conda package. Some of the dependencies are however, making it
somewhat worthwhile to create a conda environment for this anyway.

## Creating an environment with available DAS Tool requirements

```
$ conda create --name das_tool
$ source activate das_tool
$ conda install diamond pullseq prodigal
$ conda install -c conda-forge ruby
```

## R packages

Make sure you have R >= 3.2.3 and install `data.table`, `ggplot2` and `doMC` using
`install.packages()` from the R command line.

```
$ R
> install.packages(c('data.table', 'ggplot2', 'doMC'))
> <ctrl>D
```
