#!/bin/sh
ls -lR | sort -rnk 5 | awk '{ if($1 ~/^d/) dir++; if($1 ~/^-/) file++; size=size+$5; if(NR<6) print NR": "$5" "$9} END{ print "Dir = "dir"\n" "File = " file"\n" "total = "size}'
