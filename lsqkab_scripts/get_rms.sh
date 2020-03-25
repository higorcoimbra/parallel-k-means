#! /bin/sh
../lsqkab_scripts/call_lsqkab.sh $1 $2 $3 | egrep -e "RMS.*XYZ" | cut -d '=' -f2 >> ./rms_results_cluster_i
