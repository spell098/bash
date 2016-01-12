#!/bin/bash
mawk -F";" 'BEGIN{i=0}NR==FNR{i++;\
	split($1, a, "///");split($2, b, "///");split($3, c, "///");d=$4;\
	for(j=1;j<=length(a);j++){print d";"a[j]";biological_process\n"\
	d";"b[j]";cell_component\n"d";"c[j]";molecular_function"};next}'\
 	~/Workbench/codes/R/phd/rnaseq_analysis2/rnaseq_analysis/goTable.txt\
	> ~/Workbench/codes/R/phd/rnaseq_analysis2/rnaseq_analysis/goTable2.txt

mawk -F";" 'BEGIN{i=0}NR==FNR{i++;\
	a=$1;split($2, b, "//");c=$3;\
	print a";"b[2]";"c;next}'\
 	~/Workbench/codes/R/phd/rnaseq_analysis2/rnaseq_analysis/goTable2.txt\
	> ~/Workbench/codes/R/phd/rnaseq_analysis2/rnaseq_analysis/goTable3.txt
