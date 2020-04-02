#! /bin/sh
../lsqkab_scripts/call_lsqkab.sh $1 $2 $3 $4 | egrep -e "RMS.*XYZ" | cut -d '=' -f2 >> ./rms_files/rms_results_cluster_$4
