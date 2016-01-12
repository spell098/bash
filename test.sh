#!/bin/bash
snp_name=( $(cut -d, -f 2 ~/psych_chip_rs.csv) )
snp_chrom=( $(cut -d, -f 11 ~/psych_chip_rs.csv | sed "s/^/'chr/" | sed "s/$/'/") )
snp_pos=( $(cut -d, -f 12 ~/psych_chip_rs.csv) )

printf "name\tchrom\tstrand\ttxStart\ttxEnd\texonStarts\tsnp_name\tsnp_chrom\tsnp_pos\n" > ~/genes_by_snps.txt
for i in `seq 1 $[${#snp_chrom[@]}-1]`;do
	results=( $(echo "SELECT name, chrom, strand, txStart, txEnd, exonStarts FROM ensGene WHERE txStart < ${snp_pos[$i]} AND txEnd > ${snp_pos[$i]} AND chrom = ${snp_chrom[$i]};" | mysql -h genome-mysql.cse.ucsc.edu -u genome -D hg19 -A -r -N) )
	if (( ${#results[@]} > 0 ));then 
		for k in `seq 1 ${#results[@]}`;do
			printf "${results[$k]}" >> ~/genes_by_snps.txt
			printf "\t" >> ~/genes_by_snps.txt
			if (( $k % 6 == 0 ));then printf "${snp_name[$i]}\t${snp_chrom[$i]}\t${snp_pos[$i]}\n"  >> ~/genes_by_snps.txt;fi
		done		
	fi
done

