# Setting up an Rstudio project

There are a couple of files in this repository that make it somewhat simpler to
create an Rstudio project, and create a report of statistics from the steps in
data processing.

## Rproj file

The `lib/R/project.Rproj` can be copied -- typically called `project_name.Rproj`
-- to the root directory. (The default .gitignore
(`gitignores/project_root.gitignore`) already contains what Rstudio would add.

## Annotation statistics

The `lib/R/annotation_statistics.rmd` is an Rmarkdown script that, given files
produced by various makefiles here, summarizes the various steps of annotation.
