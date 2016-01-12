# Transformation des fichiers de methylation
# de: chr"	"start"	"end"	"num_C_fw"	"num_total_fw"	"meth_fw"	"num_C_rv"	"num_total_rv"	"meth_rv"	"total_C"	"total"	"total_meth
# Pour donner: chr"	"start"	"end"	"total_C"	"total"	"total_meth

path=/sb/project/vvp-220-aa/TY_methylation/
cut -f-3,10- $path/High2_vDG_Brain_BS_1.profile.cg_strand_combined.csv | awk '{ if ( $5 + 0 > 0 )
	print $1"."$2 "\t" $1 "\t" $2 "\t*\t" $5 "\t" $4/$5*100 "\t" ($5-$4)/$5*100 }' > /home/sipel35/High2_vDG_Brain_BS_1.profile.cg_strand_corrected
cut -f-3,10- $path/High2_dDG_Brain_BS_1.profile.cg_strand_combined.csv | awk '{ if ( $5 + 0 > 0 )
	print $1"."$2 "\t" $1 "\t" $2 "\t*\t" $5 "\t" $4/$5*100 "\t" ($5-$4)/$5*100 }' > /home/sipel35/High2_dDG_Brain_BS_1.profile.cg_strand_corrected
	
cut -f-3,10- $path/Low1_dDG_Brain_BS_1.profile.cg_strand_combined.csv | awk '{ if ( $5 + 0 > 0 )
	print $1"."$2 "\t" $1 "\t" $2 "\t*\t" $5 "\t" $4/$5*100 "\t" ($5-$4)/$5*100 }' > /home/sipel35/Low1_dDG_Brain_BS_1.profile.cg_strand_corrected
	
cut -f-3,10- $path/Low1_vDG_Brain_BS_1.profile.cg_strand_combined.csv | awk '{ if ( $5 + 0 > 0 )
	print $1"."$2 "\t" $1 "\t" $2 "\t*\t" $5 "\t" $4/$5*100 "\t" ($5-$4)/$5*100 }' > /home/sipel35/Low1_vDG_Brain_BS_1.profile.cg_strand_corrected

awk '{
	print $1"."$2}' $path/High2_vDG_Brain_BS_1.profile.cg_strand_combined.csv > /home/sipel35/High2_vDG_Brain_BS_1.profile.cpg_pos 
