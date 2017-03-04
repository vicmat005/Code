#! /bin/bash
## SGE batch file - cpacFAB
#$ -S /bin/bash
## cpacFAB is the jobname and can be changed
#$ -N cpac_fab
## execute the job using the mpi_smp parallel enviroment and 8 cores per job
## create an array of 1112 jobs
#$ -t 1-48
#$ -V
#$ -l mem_free=2G
## ## ##  #$ -pe mpi_smp 8  we dont have mpi_smp running in our Ada sge.
## change the following working directory to a persistent directory that is
## available on all nodes, this is were messages printed by the app (stdout
## and stderr) will be stored
#$ -wd /mnt/MD1200A/fbarrios/volalde/cpac_cluster_files/

module add singularity/2.2
## sudo chmod 777 /mnt
mkdir -p /mnt/MD1200A/fbarrios/volalde/cpac_cluster_files/log/reports

sge_ndx=$(( SGE_TASK_ID - 1 ))

# random sleep so that jobs dont start at _exactly_ the same time
sleep $(( $SGE_TASK_ID % 10 ))

singularity run -B /mnt:/mnt  \
  /mnt/MD1200A/fbarrios/fbarrios/singularity_images/cpac_v1.0.1a_13 \
  --n_cpus 8 --mem 16 \
  --pipeline_file /mnt/MD1200A/fbarrios/volalde/cpacBIDS/pipeline_config_pipeline_PsyRes.yml \
  --data_config_file /mnt/MD1200A/fbarrios/volalde/cpacBIDS/CPAC_subject_list_Lista_PsyRes_v01.yml \
  /mnt/MD1200A/fbarrios/BIDS/BIDS_PsyRes \
  /mnt/MD1200A/fbarrios/volalde/cpacBIDS/outputDir/ \
  participant --participant_ndx ${sge_ndx} 
