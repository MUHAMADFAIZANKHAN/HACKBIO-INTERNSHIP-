#!/bin/bash

# Create directories for storing the data
mkdir -p {data,ref_genome,fastqc_results,trimmed_fastq,aligned_data}

# Download reference genome
echo "Downloading reference genome..."
wget -P ref_genome/ https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/001/405/GCA_000001405.29_GRCh38.p14/GCA_000001405.29_GRCh38.p14_genomic.fna.gz

# Unzip the reference genome
echo "Unzipping reference genome..."
gunzip ref_genome/GCA_000001405.29_GRCh38.p14_genomic.fna.gz

# BWA Index the reference genome
echo "Indexing reference genome with BWA..."
bwa index ref_genome/GCA_000001405.29_GRCh38.p14_genomic.fna

# Download datasets
echo "Downloading datasets..."
wget -P data/ ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR867/001/SRR8670681/SRR8670681_1.fastq.gz
wget -P data/ ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR867/001/SRR8670681/SRR8670681_2.fastq.gz
wget -P data/ ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR867/009/SRR8670669/SRR8670669_1.fastq.gz
wget -P data/ ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR867/009/SRR8670669/SRR8670669_2.fastq.gz

# FastQC quality control
echo "Running FastQC..."
fastqc data/*.fastq.gz -o fastqc_results/

# Trimming reads using fastp
echo "Trimming reads using fastp..."
fastp -i data/SRR8670681_1.fastq.gz -I data/SRR8670681_2.fastq.gz -o trimmed_fastq/SRR8670681_1_trimmed.fastq.gz -O trimmed_fastq/SRR8670681_2_trimmed.fastq.gz
fastp -i data/SRR8670669_1.fastq.gz -I data/SRR8670669_2.fastq.gz -o trimmed_fastq/SRR8670669_1_trimmed.fastq.gz -O trimmed_fastq/SRR8670669_2_trimmed.fastq.gz

# Align reads to the reference genome using BWA MEM
echo "Aligning reads to reference genome..."
bwa mem ref_genome/GCA_000001405.29_GRCh38.p14_genomic.fna trimmed_fastq/SRR8670681_1_trimmed.fastq.gz trimmed_fastq/SRR8670681_2_trimmed.fastq.gz > aligned_data/SRR8670681.sam
bwa mem ref_genome/GCA_000001405.29_GRCh38.p14_genomic.fna trimmed_fastq/SRR8670669_1_trimmed.fastq.gz trimmed_fastq/SRR8670669_2_trimmed.fastq.gz > aligned_data/SRR8670669.sam

# Convert SAM to BAM, sort, and index using Samtools
echo "Converting, sorting, and indexing BAM files..."
samtools view -Sb aligned_data/SRR8670681.sam | samtools sort -o aligned_data/SRR8670681_sorted.bam
samtools view -Sb aligned_data/SRR8670669.sam | samtools sort -o aligned_data/SRR8670669_sorted.bam

samtools index aligned_data/SRR8670681_sorted.bam
samtools index aligned_data/SRR8670669_sorted.bam

echo "Pipeline completed successfully."
