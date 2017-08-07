#!/usr/bin/env Rscript

# addseqs.r
#
# Adds newly cleaned sequences to an already existing set.
#
# Author: daniel.lundin@lnu.se

suppressPackageStartupMessages(library(optparse))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(readr))
suppressPackageStartupMessages(library(tibble))

# Get arguments
option_list = list(
  make_option(
    c('--inseqidfile'), type='character',
    help='Name of input sequence file containing the present sequence collection.'
  ),
  make_option(
    c('--intable'), type='character',
    help='Name of input table containing sequences (seq), samples and counts.'
  ),
  make_option(
    c('--outnewseqs'), type='character',
    help='Name of file to write new sequences with seqids to.'
  ),
  make_option(
    c('--outseqidfile'), type='character',
    help='Name of output sequence file containing the joined sequence collection. Can be the same as --inseqidfile, in which case that will be overwritten.'
  ),
  make_option(
    c('--outtable'), type='character',
    help='Name of output file with the data from the input file with added sequence identifiers.'
  ),
  make_option(
    c('--prefix'), type='character', default='LMO16S',
    help='Prefix for sequence names, default "%default".'
  ),
  make_option(
    c("-v", "--verbose"), action="store_true", default=FALSE, 
    help="Print progress messages"
  )
)
opt = parse_args(OptionParser(option_list=option_list))

# Option list for testing
# opt = list(args=c('addseqs.00.newseqs.tsv.gz'),=list(verbose=T, prefix='LMO16S', inseqidfile='addseqs.00.seqs.tsv.gz', outseqidfile='test.tsv', outtable='test.table.tsv', outnewseqs='test.new.tsv'))

logmsg = function(msg, llevel='INFO') {
  if ( opt$verbose ) {
    write(
      sprintf("%s: %s: %s", llevel, format(Sys.time(), "%Y-%m-%d %H:%M:%S"), msg),
      stderr()
    )
  }
}

if ( file.exists(opt$inseqidfile) ) {
  seqidtable = read_tsv(opt$inseqidfile, col_types = cols(.default = col_character()))
  logmsg(sprintf("Read old sequence id table %s, %d sequences", opt$inseqidfile, length(seqidtable$seq)))
} else {
  seqidtable = tibble(seqid=character(), seq=character())
  logmsg(sprintf("%s not found, created new seqid table", opt$inseqidfile))
}

# Get the last number in the series
if ( length(seqidtable$seqid) > 0 ) {
  lastnum = as.integer(gsub('^.*_', '', max(seqidtable$seqid)))
} else {
  lastnum = 0
}

# Read the new data
newdata = read_tsv(opt$intable, col_types=cols(.default=col_character(), count=col_integer()))
logmsg(sprintf("Read new data table %s, %d unique sequences", opt$intable, length(unique(newdata$seq))))

# Find new sequences by right joining with the present set and assign names to them
nonames = seqidtable %>% right_join(newdata %>% select(seq) %>% distinct(), by='seq') %>% 
  filter(is.na(seqid)) %>% select(seq) %>% arrange(seq)
nonames$seqid = sprintf("%s_%010d", opt$prefix, seq(from=lastnum + 1, to=lastnum + length(nonames$seq)))

# Write all names to the outseqidfile
newseqidtable = union(seqidtable, nonames) %>% arrange(seqid)
write_tsv(newseqidtable, opt$outseqidfile)
logmsg(sprintf("Wrote union sequence file %s with %d sequences.", opt$outseqidfile, length(newseqidtable$seq)))

# And all new sequences to outnewseqs
write_tsv(nonames %>% select(seqid, seq) %>% arrange(seqid), opt$outnewseqs)
logmsg(sprintf("Wrote only new sequence file %s with %d sequences.", opt$outnewseqs, length(nonames$seq)))

# Join in the complete table with the new data and write to outtable
newseqtable = newdata %>% inner_join(newseqidtable, by='seq') %>%
  select(seqid, sample, count, seq)
write_tsv(newseqtable, opt$outtable)
logmsg(sprintf("Wrote new sequence table to %s", opt$outtable))

logmsg("Done")
