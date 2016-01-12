#!/bin/bash
table=ensGene
snp_name=( $(cut -d, -f 3 ~/manifest.prs.01_snplist.csv) )
snp_chrom=( $(cut -d, -f 11 ~/manifest.prs.01_snplist.csv | sed "s/^/'chr/" | sed "s/$/'/") )
snp_pos=( $(cut -d, -f 12 ~/manifest.prs.01_snplist.csv) )


find_gene () {
	promoter=3000
	local snp_pos=$1
	local snp_name=$2
	local snp_chrom=$3
	results=( $(echo "SELECT name, chrom, strand, txStart, txEnd, cdsEnd, cdsStart, exonStarts, exonEnds FROM $table WHERE txStart < $[$snp_pos+$promoter] AND txEnd > $snp_pos AND chrom = $snp_chrom;" | mysql -h genome-mysql.cse.ucsc.edu -u genome -D hg19 -A -r -N) )
	#SELECT name, chrom, strand, txStart, txEnd, cdsEnd, cdsStart, exonStarts, exonEnds FROM ensGene 
	if (( ${#results[@]} > 0 ));then 
		for k in `seq 0 $[${#results[@]}-1]`;do
			(( t++ ))			
			if (( $t == 1 ));then awk -v i="${results[$k]}" '{ if ($2 ~ i) printf $3"\t"}' ~/workbench/mart_export.txt >> ~/genes_by_snps.txt;fi
			printf "${results[$k]}" >> ~/genes_by_snps.txt
			printf "\t" >> ~/genes_by_snps.txt
			if (( $t == 4 ));then txStart=${results[$k]};fi
			if (( $t == 5 ));then txEnd=${results[$k]};fi
			if (( $t == 6 ));then cdsEnd=${results[$k]};fi
			if (( $t == 7 ));then cdsStart=${results[$k]};fi
			if (( $t == 8 ));then 
				exonStart=${results[$k]};
				IFS=',' read -a exonStartsArray <<< "$exonStart"
			fi
			if (( $t == 9 ));then 
				exon=0
				t=0
				exonEnd=${results[$k]};
				IFS=',' read -a exonEndsArray <<< "$exonEnd"

				printf "$snp_name\t$snp_chrom\t$snp_pos\t"  >> ~/genes_by_snps.txt;
				if [[ ($cdsEnd < $snp_pos) && ($txEnd > $snp_pos) ]];then
					printf "3UTR\n" >> ~/genes_by_snps.txt;
				elif [[ ($txStart < $snp_pos) && ($cdsStart > $snp_pos) ]];then
					printf "5UTR\n" >> ~/genes_by_snps.txt;
				elif [[ ($[$txStart-$promoter] < $snp_pos) && ($txStart > $snp_pos) ]];then
					printf "promoter\n" >> ~/genes_by_snps.txt;
				else 
					for n in `seq 0 $[${#exonStartsArray[@]}-1]`;do
						if [[ ($snp_pos > ${exonStartsArray[$n]}) && ($snp_pos < ${exonEndsArray[$n]}) ]];then
							exon=1;
						fi
					done
					if (( $exon == 1 ));then printf "exon\n" >> ~/genes_by_snps.txt;
					elif (( $exon == 0 ));then printf "intron\n" >> ~/genes_by_snps.txt;
					fi
				fi
			fi
		done		
	fi
}

printf "name\tchrom\tstrand\ttxStart\ttxEnd\tcdsEnd\tcdsStart\texonStarts\texonEnds\tsnp_name\tsnp_chrom\tsnp_pos\tpart_of_gene\n" > ~/genes_by_snps.txt
for i in `seq 1 $[${#snp_chrom[@]}-1]`;do
	find_gene ${snp_pos[$i]} ${snp_name[$i]} ${snp_chrom[$i]} 
done


awk '{print $10"\t"$11"\t"$12"\t"$13"\t"$1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9}' ~/genes_by_snps.txt > ~/genes_by_snps2.txt
