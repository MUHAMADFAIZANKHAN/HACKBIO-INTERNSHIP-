mkdir FAIZAN
mkdir biocomputing && cd biocomputing
wget https://raw.githubusercontent.com/josoga2/dataset-repos/main/wildtype.fna
https://raw.githubusercontent.com/josoga2/dataset-repos/main/wildtype.gbk
https://raw.githubusercontent.com/josoga2/dataset-repos/main/wildtype.gbk
mv wildtype.fna ../FAIZAN
rm wildtype.gbk.1
if grep -q "tatatata" wildtype.fna; then echo "mutant"; else echo "wildtype"; fi
grep "tatatata" wildtype.fna > mutant.fna
wget "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nucleotide&id=NM_001256799 &rettype=fasta&retmode=text" -O gadphgene.fasta
grep -c -v "^>" gadphgene.fasta
grep "A" gadphgene.fasta | wc -l
grep "G" gadphgene.fasta | wc -l
grep "C" gadphgene.fasta | wc -l
grep "T" gadphgene.fasta | wc -l
awk '!/^>/{n+=length($0); g+=gsub(/[GgCc]/,"") } END{print g/n * 100 "%"}' gadphgene.fasta
nano FAIZAN.fasta
echo "GCGCGCGCGCGCGCGCGCGC" >> FAIZAN.fasta
history 
clear
ls
