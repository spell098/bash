#!/bin/bash
promoter=3000
table=ensGene
snp_name=( $(cut -d, -f 2 ~/manifest.prs.01_snplist.csv) )
snp_chrom=( $(cut -d, -f 11 ~/manifest.prs.01_snplist.csv | sed "s/^/'chr/" | sed "s/$/'/") )
snp_pos=( $(cut -d, -f 12 ~/manifest.prs.01_snplist.csv) )

printf "name\tchrom\tstrand\ttxStart\ttxEnd\tcdsEnd\tcdsStart\texonStarts\texonEnds\tsnp_name\tsnp_chrom\tsnp_pos\tpart_of_gene\n" > ~/genes_by_snps.txt
for i in `seq 1 $[${#snp_chrom[@]}-1]`;do
	results=( $(echo "SELECT name, chrom, strand, txStart, txEnd, cdsEnd, cdsStart, exonStarts, exonEnds FROM $table WHERE txStart < $[${snp_pos[$i]}+$promoter] AND txEnd > ${snp_pos[$i]} AND chrom = ${snp_chrom[$i]};" | mysql -h genome-mysql.cse.ucsc.edu -u genome -D hg19 -A -r -N) )
	if (( ${#results[@]} > 0 ));then 
		for k in `seq 0 $[${#results[@]}-1]`;do
			(( t++ ))			
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

				printf "${snp_name[$i]}\t${snp_chrom[$i]}\t${snp_pos[$i]}\t"  >> ~/genes_by_snps.txt;
				if [[ ($cdsEnd < ${snp_pos[$i]}) && ($txEnd > ${snp_pos[$i]}) ]];then
					printf "3UTR\n" >> ~/genes_by_snps.txt;
				elif [[ ($txStart < ${snp_pos[$i]}) && ($cdsStart > ${snp_pos[$i]}) ]];then
					printf "5UTR\n" >> ~/genes_by_snps.txt;
				elif [[ ($[$txStart-$promoter] < ${snp_pos[$i]}) && ($txStart > ${snp_pos[$i]}) ]];then
					printf "promoter\n" >> ~/genes_by_snps.txt;
				else 
					for n in `seq 0 $[${#exonStartsArray[@]}-1]`;do
						if [[ (${snp_pos[$i]} > ${exonStartsArray[$n]}) && (${snp_pos[$i]} < ${exonEndsArray[$n]}) ]];then
							exon=1;
						fi
					done
				fi
				if (( $exon == 1 ));then printf "exon\n" >> ~/genes_by_snps.txt;
				elif (( $exon == 0 ));then printf "intron\n" >> ~/genes_by_snps.txt;
				fi
			fi
		done		
	fi
done

