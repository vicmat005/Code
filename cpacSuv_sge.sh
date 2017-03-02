#! /bin/bash
## SGE batch file - cpacFAB
#$ -S /bin/bash
## cpacFAB is the jobname and can be changed
#$ -N cpac_fab
## execute the job using the mpi_smp parallel enviroment and 8 cores per job
#$ -pe mpi_smp 8
## create an array of 1112 jobs
#$ -t 1-48
#$ -V
#$ -l mem_free=2G
## change the following working directory to a persistent directory that is
## available on all nodes, this is were messages printed by the app (stdout
## and stderr) will be stored
#$ -wd /mnt/MD1200A/fbarrios/cpac_cluster_files/

module add singularity/2.2
## sudo chmod 777 /mnt
mkdir -p /mnt/MD1200A/fbarrios/cpac_cluster_files/log/reports

sge_ndx=$(( SGE_TASK_ID - 1 ))

# random sleep so that jobs dont start at _exactly_ the same time
sleep $(( $SGE_TASK_ID % 10 ))

singularity run -B /mnt:/mnt  \
  /mnt/MD1200A/fbarrios/fbarrios/singularity_images/cpac_v1.0.0 \
  --n_cpus 8 --mem 16 \
  /mnt/MD1200A/fbarrios/rsConRDC/ \
  /mnt/MD1200A/fbarrios/cpac_rsConRDC/outputs_FAB/ \  
  --pipeline_file /mnt/MD1200A/fbarrios/cpac_rsConRDC/pipeline_config_FAB.yml \
  --data_config_file /mnt/MD1200A/fbarrios/rsConRDC/cpac_data_config_20161104231240.yml \
  participant --participant_ndx ${sge_ndx}
