#!/usr/bin/env Rscript

# taxonomyhierfields.r
#
# Calculates separate taxonomy fields from the concatenated hierarchy in the
# Mothur output.
#
# Author: daniel.lundin@lnu.se

suppressPackageStartupMessages(library(optparse))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(readr))
suppressPackageStartupMessages(library(tidyr))

# Get arguments
option_list = list(
  make_option(
    c('--inputfile'), type='character', default='LMO.16S.wang.silva.tsv.gz',
    help='Name of input file from Mothur/Wang/SILVA, default %default'
  ),
  make_option(
    c('--outputfile'), type='character', default='LMO.16S.wang.silva.hier.tsv.gz',
    help='Name of output file, default %default'
  ),
  make_option(
    c("-v", "--verbose"), action="store_true", default=FALSE, 
    help="Print progress messages"
  )
)
opt = parse_args(OptionParser(option_list=option_list))

logmsg = function(msg, llevel='INFO') {
  if ( opt$verbose ) {
    write(
      sprintf("%s: %s: %s", llevel, format(Sys.time(), "%Y-%m-%d %H:%M:%S"), msg),
      stderr()
    )
  }
}
logmsg(sprintf("Reading %s", opt$inputfile))

taxonomy = read_tsv(
  opt$inputfile,
  col_names = c('seqid', 'taxonhier'),
  col_types = cols(.default=col_character())
)

# Split the hierarchy
taxonomy = taxonomy %>%
  mutate(th=gsub('\\([0-9]+\\)', '', taxonhier)) %>%
  separate(th, c('domain', 'phylum', 'class', 'order', 'family', 'genus', 'empty'), sep=';') %>%
  select(-empty)

logmsg(sprintf("Writing %s", opt$outputfile))

write_tsv(taxonomy, opt$outputfile)

logmsg("Done")
