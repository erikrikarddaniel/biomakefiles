# Running Sickle

Sickle is a fastq read trimmer, available here:

https://github.com/najoshi/sickle

It is available prepackaged from Ubuntu.

```
$ sudo apt-get install sickle
```

Rules are available in `lib/make/makefile.sickle`.  

The program can be run either with paired or single reads. So far I have only
implemented rules for the former.

Pretty standard, write a `Makefile` where you include the
`lib/make/makefile.sickle`, override the `SICKLE_OPTS` variable if you need to
(note that you need to specify the format of quality score like `-t sanger`).

Run all pairs:

```
$ make -j 8 fastq.gz2pesickle
```

After you have run all files you can run the below command to produce a 
statistics file:

```
$ make pesickle.stats.long.tsv
```
