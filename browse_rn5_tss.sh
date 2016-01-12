#PRENDRE LE BON COTE!!

#!/bin/bash

genes=(Grm1 Grm2 Gad1 Gad2 Egr1 Nr3c1 Nr3c2 Drd1 Npy Penk Vgf Sert)

>  ~/IDs.txt
for i in "${genes[@]}"; do
   awk -v i="$i" '{ if ($3 ~ i) print $2"\t"$3}' ~/mart_export.txt >>  ~/IDs.txt 
done

awk 'NR==FNR{c[$1]=$2;next};c[$4] > 0 {print $1"\t"$2"\t"$3"\t"$4"\t"c[$4]"\t"$6}' ~/IDs.txt  ~/rn5_annotation.txt > ~/genes_localisation.txt

chr=( $(cut -f 1 ~/genes_localisation.txt | cut -d "r" -f 2) )
start=( $(cut -f 2 ~/genes_localisation.txt) )
stop=( $(cut -f 3 ~/genes_localisation.txt) )
transcript=( $(cut -f 4 ~/genes_localisation.txt) )
gene_symbol=( $(cut -f 5 ~/genes_localisation.txt) )
strand=( $(cut -f 6 ~/genes_localisation.txt) )
flank_up=800
flank_down=800
path=/sb/project/vvp-220-aa/genomes/rat/

##THIS STEP PROBABLY COULD BE MUCH FASTER; COULD BE DONE WITH AWK
for i in `seq 0 $[${#chr[@]}-1]`;do
	if [[ ${strand[$i]} = '+' ]]; then sequences[$i]=$(zless $path"Rattus_norvegicus.Rnor_5.0.dna.chromosome."${chr[$i]}".fa.gz" | tail -n +2 | tr -d '\n' | cut -c $[${start[$i]}-$flank_down]-$[${start[$i]}+$flank_up])
	elif [[ ${strand[$i]} = '-' ]]; then sequences[$i]=$(zless $path"Rattus_norvegicus.Rnor_5.0.dna.chromosome."${chr[$i]}".fa.gz" | tail -n +2 | tr -d '\n' | cut -c $[${stop[$i]}-$flank_up]-$[${stop[$i]}+$flank_down])
	fi
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
	if [[ ${strand[$i]} = "+" ]];then
		echo -e "${gene_symbol[$i]}\t${transcript[$i]}\tchr${chr[$i]}:${start[$i]}-${stop[$i]}\tStrand:${strand[$i]}\nposition: ( $[${start[$i]}-$flank_down] - $[${start[$i]}+$flank_up] ) :" >> /home/sipel35/sequences.txt
	elif [[ ${strand[$i]} = "-" ]];then
		echo -e "${gene_symbol[$i]}\t${transcript[$i]}\tchr${chr[$i]}:${start[$i]}-${stop[$i]}\tStrand:${strand[$i]}\nposition: ( $[${stop[$i]}-$flank_up] - $[${stop[$i]}+$flank_down] ) :" >> /home/sipel35/sequences.txt
	fi
	echo -e "\nStrand:+\n${sequences[$i]}\n" >> /home/sipel35/sequences.txt
	echo -e "\nStrand:-\n${reverseSequences[$i]}\n" >> /home/sipel35/sequences.txt
done
