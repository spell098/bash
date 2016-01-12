


#~/Workbench/codes/bash/oestrogen_genes.txt
#~/Workbench/psych_chip

#This one does the same as the second, but is not ordered
#awk -F, 'BEGIN{i=0}NR==FNR{i++;a[i]=$1;b[i]=$2;c[i]=$3;d[i]=$4;next }; {for (j = 1; j <= i; j++) if(b[j] == $11 && $12 > c[j] && $12 < d[j]) print $2"\t"$11"\t"$12"\t"a[j]"\t"b[j]"\t"c[j]"\t"d[j]}'  ~/Workbench/codes/bash/oestrogen_genes.txt  ~/psych_chip_rs.csv > ~/workbench/rs_by_gene.txt

awk -F, 'BEGIN{i=0}NR==FNR{i++;a[i]=$11;b[i]=$12;c[i]=$2;next }; {for (j = 1; j <= i; j++) if(a[j] == $2 && b[j] > $3 && b[j] < $4) print c[j]"\t"a[j]"\t"$12"\t"$1"\t"$2"\t"$3"\t"$4}' ~/psych_chip_rs.csv ~/Workbench/codes/bash/oestrogen_genes.txt > ~/workbench/rs_by_gene.txt

#gene=( $(cut -d , -f 1 ~/workbench/codes/bash/oestrogen_genes.txt) )
#chr_gene=( $(cut -d , -f 2 ~/workbench/codes/bash/oestrogen_genes.txt) )
#start_gene=( $(cut -d , -f 3 ~/workbench/codes/bash/oestrogen_genes.txt) )
#stop_gene=( $(cut -d , -f 4 ~/workbench/codes/bash/oestrogen_genes.txt) )

#chr_snp=( $(cut -d , -f 11 ~/psych_chip_rs.csv) )
#snp=( $(cut -d , -f 12 ~/psych_chip_rs.csv) )
#id_rs=( $(cut -d , -f 3 ~/psych_chip_rs.csv) )

#> ~/workbench/rs_list.txt

#echo -e gene'\t'chr'\t'pos_start'\t'pos_stop'\t'id_rs'\t'chr'\t'position >> ~/workbench/rs_list.txt
#for j in `seq 0 $[${#chr_gene[@]}-1]`;do
#    for i in `seq 0 $[${#chr_snp[@]}-1]`;do &
#    	if (( $(($i % 10000)) == 0 ));then echo $i/${#chr_snp[@]}; fi
#    	if (( (${snp[$i]} < ${stop_gene[$j]} && ${snp[$i]} > ${start_gene[$j]}) && ${chr_snp[$i]} == ${chr_gene[$j]} ))
#      	then echo -e ${gene[$j]}'\t'${chr_gene[$j]}'\t'${start_gene[$j]}'\t'${stop_gene[$j]}'\t'${id_rs[$i]}'\t'${chr_snp[$i]}'\t'${snp[$i]}'\t'$i;
#      fi
#    done
#done
#
#grep(${chr_gene[@]},${#chr_snp[@]}
 selectedGenes=allTranscripts[match(selectedGeneCpg,allTranscripts[,typeID]),]
  selectedGenes$chr_name = paste0(rep("chr",length(selectedGenes$chr_name)),as.character(selectedGenes$chr_name))
  write.table(allCpgs[[selectedComparison]],"annotations/allCpgs.txt",quote=FALSE)
  write.table(selectedGenes,"annotations/selected_genes.txt",quote=FALSE)
  
  system('awk \'BEGIN{i=0}NR==FNR{i++;a[i]=$2;b[i]=$3;c[i]=$5;next }; {for (j = 1; j <= i; j++) 
         if(a[j] == $5 && b[j] > $6 && b[j] < $7) print $2"\t"$3"\t"$4"\t"$5"\t"a[j]"\t"b[j]"\t"$6"\t"$7}\' 
         annotations/allCpgs.txt annotations/selected_genes.txt > annotations/selected_genes_cpg.txt')
  system('awk \'BEGIN{i=0}NR==FNR{i++;a[i]=$5;b[i]=$6;c[i]=$7;next }; {for (j = 1; j <= i; j++) 
         if(a[j] == $5 && $6 > b[j] && $7 < c[j]) print $2"\t"$3"\t"$4"\t"$5"\t"a[j]"\t"b[j]"\t"$6"\t"$7}\' 
        annotations/selected_genes.txt annotations/allCpgs.txt > annotations/selected_genes_cpg.txt')
