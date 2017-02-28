#! /bin/bash
## SGE batch file - bgsp
#$ -S /bin/bash
## bgsp is the jobname and can be changed
#$ -N bgsp_fab
## execute the job using the mpi_smp parallel enviroment and 8 cores per job
#$ -pe mpi_smp 8
## create an array of 1112 jobs
#$ -t 1-1112
#$ -V
## change the following working directory to a persistent directory that is
## available on all nodes, this is were messages printed by the app (stdout
## and stderr) will be stored
#$ -wd /mnt/MD1200A/fbarrios/fbarrios

## sudo chmod 777 /mnt
mkdir -p /mnt/MD1200A/fbarrios/fbarrios/log/reports

sge_ndx=$(( SGE_TASK_ID - 1 ))

# random sleep so that jobs dont start at _exactly_ the same time
sleep $(( $SGE_TASK_ID % 10 ))

singularity run -B /mnt:/mnt \
  /mnt/MD1200A/fbarrios/fbarrios/singularity_images/cpac_v1.0.0 \
  --n_cpus 8 --mem 12 \
  --data_config_file /mnt/workspace/cluster_files/bgsp_data_config.yml \
  /mnt/MD1200A/fbarrios/orig_bids/ \
  /mnt/MD1200A/fbarrios/cpac_out/ \
  participant --participant_ndx ${sge_ndx}
