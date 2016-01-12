#!/bin/bash
genome=hg19
table=ensGene
table2=snp142
promoter=3000

find_gene () {
	echo "SELECT * FROM $table JOIN $table2 ON $table.txStart < ($table2.chromStart + $promoter) AND $table.txEnd > $table2.chromEnd AND $table.chrom = $table2.chrom;" | mysql -h genome-mysql.cse.ucsc.edu -u genome -D $genome -A -r -N > allSnps.txt
}

	echo "SELECT * FROM  $table2;" | mysql -h genome-mysql.cse.ucsc.edu -u genome -D $genome -A -r -N > allSnps.txt

#net_read_timeout=90;

mysql --user=genome --host=genome-mysql.cse.ucsc.edu -A -D hg19 -e 'SELECT name,chromStart,chromEnd,strand FROM snp138Common' | tail -n +2 > snp138CommonNames.txt