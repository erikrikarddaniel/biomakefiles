#Pipeline overview
The pipeline consists in several workflows to allow users to handle data according to the kind of data they use. In fact, the following guideline has been implemented for both metagenomic and metatranscriptomic reads.
##Screening workflow
--Briefly explain the desired output of the workflow and the main tools involved (DIAMOND and MEGAN) add description , redirect on report for the purpose of it--
1.Quality check(FastQC + cutadapt)
1.Mapping/filtering out(ERNE)
1.(DIAMOND)
1.Taxonomic annotation(MEGAN)

##Assembly workflow
-- highlight the in-depth  
1.FastQC
1.cutadapt
1.Assembly(Megahit)(metagenome or metatranscriptome)
1.Mapping(Bowtie2)
1. Mapping metagenome reads vs metagenome contigs (Bowtie2)
1.Annotation(RAST+Checkm-genome)
1.Binning(Prokka)

##Two possible outcomes:
1. __De novo__ metatranscriptomics asembly and mapping
1.Mapping metatranscriptomics against metagenome (Bowtie2)

