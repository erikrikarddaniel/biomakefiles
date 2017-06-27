DIFF = grep -v "^[ ]*$$" $@.out | diff $@.expect -

CHECK = if [ ` $(DIFF) | wc -l ` -eq 0 ]; then echo "*** $@ OK ***"; else echo "*** $@ FAILED ***"; echo "Here's a diff: "; $(DIFF); exit 1; fi

all: addseqs.00

addseqs.00: 
	@../R/addseqs.r \
	  --verbose \
	  --prefix=LMO16S \
	  --inseqidfile=$@.seqids.tsv.gz \
	  --outseqidfile=$@.out.seqids.tsv \
	  --outnewseqs=$@.out.newseqids.tsv \
	  --outtable=$@.out.table.tsv \
	  --intable=$@.table.tsv.gz
	@cat $@.out.seqids.tsv $@.out.newseqids.tsv $@.out.table.tsv > $@.out
	@$(CHECK)
