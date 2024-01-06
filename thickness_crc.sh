#!/bin/bash
#SBATCH --job-name=thickness_processing
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16GB
#SBATCH --time=99:00:00
#SBATCH --array=1-1
#SBATCH --mail-type=ALL
#SBATCH --mail-user=jil202@pitt.edu
#SBATCH --account=tibrahim
#SBATCH --cluster=htc

source activate DL_DiReCT
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

# Define an array of input filenames
T1s=(/ix1/tibrahim/jil202/thickness_map/img/T1w/*.nii)

current_img=${T1s[$SLURM_ARRAY_TASK_ID - 1]}
current_name=$(echo "$current_img" | rev | cut -d'/' -f1 | rev)
current_name=$(echo "$current_name" | cut -d'.' -f1)
current_name=$(echo "$current_name" | cut -d'_' -f1-3)
current_folder=$(echo "$current_img" | cut -d'/' -f1-6)/derivatives
output="$current_folder/thickness/$current_name"
dl+direct --subject $current_name --bet $current_img $output

current_thickmap=($output/T1w_norm_thickmap.nii.gz)
mv $current_thickmap $output/$(echo $output | rev | cut -d'/' -f1 | rev)_thickmap.nii.gz
python3 registration.py $output/$(echo $output | rev | cut -d'/' -f1 | rev)_thickmap.nii.gz $output/mni_$(echo $output | rev | cut -d'/' -f1 | rev)_thickmap.nii.gz
