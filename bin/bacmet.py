#!/usr/bin/python

"""
Usage:

join.arg.py [arg1] [num] [arg2]

arg1: input tabular file with annotation
num: minimum a.a. length threshold
arg2: output file name

"""
import io
import sys
import string
import pandas as pd
#import click


if len(sys.argv) == 0:
	print (__doc__)
	exit(0)

# Change the header names to suit your input tabular file structure
arg=pd.read_csv(sys.argv[1], sep='\t', index_col=0, header=None, names=["read_ID", "db_id", "mrg", "features", "secondary_id", "phenotype", "pident", "alignmentlength", "mismatch", "gapopen", "qstart", "qend", "sstart", "send", "evalue", "bitscore", "qcovhsp"])
argf=arg.loc[(arg['alignmentlength']>=float(sys.argv[2]))]
#
#
argf.to_csv(sys.argv[3],sep="\t", index=True)
#


