#PRENDRE LE BON COTE!!

#!/bin/bash

genes=(Grm1 Grm2 Gad1 Gad2 Egr1 Nr3c1 Nr3c2 Drd1 Npy Penk Vgf Sert)

>  ~/IDs.txt
for i in "${genes[@]}"; do
   awk -v i="$i" '{ if ($3 ~ i) print $2"\t"$3}' ~/mart_export.txt >>  ~/IDs.txt 
done

awk 'NR==FNR{c[$1]=$2;next};c[$4] > 0 {print $1"\t"$2"\t"$3"\t"$4"\t"c[$4]}' ~/IDs.txt  ~/rn5_annotation.txt > ~/genes_localisation.txt

chr=( $(cut -f 1 ~/genes_localisation.txt | cut -d "r" -f 2) )
start=( $(cut -f 2 ~/genes_localisation.txt) )
stop=( $(cut -f 2 ~/genes_localisation.txt) )
gene_symbol=( $(cut -f 5 ~/genes_localisation.txt) )
transcript=( $(cut -f 4 ~/genes_localisation.txt) )

flank=800

path=/sb/project/vvp-220-aa/genomes/rat/

##THIS STEP PROBABLY COULD BE MUCH FASTER
for i in `seq 0 $[${#chr[@]}-1]`;do
	sequences[$i]=$(zless $path"Rattus_norvegicus.Rnor_5.0.dna.chromosome."${chr[$i]}".fa.gz" | 
	tail -n +2 | tr -d '\n' | cut -c $[${start[$i]}-$flank]-$[${stop[$i]}+$flank]) 
done

for i in `seq 0 $[${#chr[@]}-1]`;do
	reverseSequence='';
	for j in `seq 0 $[${#sequences[$i]}-1]`;do
		letter=${sequences[$i]:$j:1}
		if [[ $letter = 'A' ]]; then letter2='T'
		elif [[ $letter = 'T' ]]; then letter2='A'
		elif [[ $letter = 'G' ]]; then letter2='C'
		elif [[ $letter = 'C' ]]; then letter2='G'
		elif [[ $letter = 'N' ]]; then letter2='N'
		else letter2='?' 
		fi
		reverseSequence=$letter2$reverseSequence 
	done
	reverseSequences[$i]=$reverseSequence
done

> /home/sipel35/sequences.txt
for i in `seq 0 $[${#chr[@]}-1]`;do
	echo -e "${gene_symbol[$i]}\t${transcript[$i]}\tchr${chr[$i]}:${start[$i]}-${stop[$i]} ($[${start[$i]}-$flank] (-$flank) - $[${stop[$i]}+$flank] (+$flank)) : \n${sequences[$i]}\n" >> /home/sipel35/sequences.txt
	echo -e "Complementary and reversed DNA of ${gene_symbol[$i]}\t${transcript[$i]}\tchr${chr[$i]}:${start[$i]}-${stop[$i]} ($[${start[$i]}-$flank] (-$flank) - $[${stop[$i]}+$flank] (+$flank)): \n${reverseSequences[$i]}\n" >> /home/sipel35/sequences.txt
done
>rn5_dna range=chr1:6412620-6819177 5'pad=800 3'pad=800 strand=- repeatMasking=none
