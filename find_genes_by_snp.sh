#snps=( $(<~/Workbench/codes/bash/oestrogen_genes.txt) )
snp_name=( $(cut -d, -f 2 ~/psych_chip_rs.csv) )
snp_chrom=( $(cut -d, -f 11 ~/psych_chip_rs.csv | sed "s/^/'chr/" | sed "s/$/'/") )
snp_pos=( $(cut -d, -f 12 ~/psych_chip_rs.csv) )

 
mawk -F, 'BEGIN{i=0}NR==FNR{i++;a[i]=$11;b[i]=$12;c[i]=$2;next }; {for (j = 1; j <= i; j++) if(a[j] == $2 && b[j] > $3 && b[j] < $4) print c[j]"\t"a[j]"\t"$12"\t"$1"\t"$2"\t"$3"\t"$4}' ~/psych_chip_rs.csv > ~/workbench/gene_by_rs.txt


> ~/genes_by_snps.txt

for i in `seq 1 $[${#snp_chrom[@]}-1]`;do
	if (( $i == 1 ));then
		echo "SELECT name, chrom, strand, txStart, txEnd, exonStarts FROM ensGene WHERE txStart < ${snp_pos[$i]} AND txEnd > ${snp_pos[$i]} AND chrom = ${snp_chrom[$i]};" | mysql -h genome-mysql.cse.ucsc.edu -u genome -D hg19 -A -r >> ~/genes_by_snps.txt
	else 		
		echo "SELECT name, chrom, strand, txStart, txEnd, exonStarts FROM ensGene WHERE txStart < ${snp_pos[$i]} AND txEnd > ${snp_pos[$i]} AND chrom = ${snp_chrom[$i]};" | mysql -h genome-mysql.cse.ucsc.edu -u genome -D hg19 -A -r -N >> ~/genes_by_snps.txt
	fi
done


#$(echo "SELECT name, chrom, strand, txStart, txEnd, exonStarts FROM ensGene WHERE ${snp_pos[$i]} > txStart AND ${snp_pos[$i]} < txEnd AND ${snp_chrom[$i]} = chrom;" | mysql -h genome-mysql.cse.ucsc.edu -u genome -D hg19 -A)



#	genes=( $(echo "SELECT name, chrom, strand, txStart, txEnd, exonStarts FROM ensGene WHERE txStart > 1" | mysql -h genome-mysql.cse.ucsc.edu -u genome -D hg19 -A) )

#mysql -uUSER -t -e "select value1, value2, value3 from table" -pPASS

> ~/genes_by_snps.txt
printf "name\tchrom\tstrand\ttxStart\ttxEnd\texonStarts\n" >> ~/genes_by_snps.txt
for i in `seq 1 $[${#snp_chrom[@]}-1]`;do
	printf "${snp_name[$i]}\n"
	echo "SELECT name, chrom, strand, txStart, txEnd, exonStarts FROM ensGene WHERE txStart < ${snp_pos[$i]} AND txEnd > ${snp_pos[$i]} AND chrom = ${snp_chrom[$i]};" | mysql -h genome-mysql.cse.ucsc.edu -u genome -D hg19 -A -r -N
done

for line in ${results[@]};do
	printf "$line\n";
done

###USE AWK
> ~/genes_by_snps.txt
for i in `seq 1 $[${#snp_chrom[@]}-1]`;do
	results=( $(echo "SELECT name, chrom, strand, txStart, txEnd, exonStarts FROM ensGene WHERE txStart < ${snp_pos[$i]} AND txEnd > ${snp_pos[$i]} AND chrom = ${snp_chrom[$i]};" | mysql -h genome-mysql.cse.ucsc.edu -u genome -D hg19 -A -r -N) )
	if (( ${#results[@]} > 6 ));then 
		for i in `seq 1 $[${#results[@]}-1]`;do
			printf "${snp_name[$i]}\t${snp_chrom[$i]}\t${snp_pos[$i]}";
			printf "%s\t" "${results[$i]}";	
			if (( $[$i+1] % 6 == 0));then printf "\n";fi
		done
	fi
done


###USE AWK
> ~/genes_by_snps.txt
for i in `seq 1 $[${#snp_chrom[@]}-1]`;do
	results=( $(echo "SELECT name, chrom, strand, txStart, txEnd, exonStarts FROM ensGene WHERE txStart < ${snp_pos[$i]} AND txEnd > ${snp_pos[$i]} AND chrom = ${snp_chrom[$i]};" | mysql -h genome-mysql.cse.ucsc.edu -u genome -D hg19 -A -r -N) )
	mawk -F, 'BEGIN{i=0}{i++;a[i]=$11;b[i]=$12;c[i]=$2;next }; {for (j = 1; j <= i; j++) if(a[j] == $2 && b[j] > $3 && b[j] < $4) print c[j]"\t"a[j]"\t"$12"\t"$1"\t"$2"\t"$3"\t"$4}' 
done

