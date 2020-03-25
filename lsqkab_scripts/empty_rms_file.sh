#! /bin/bash

FILE=./rms_results_cluster_i
if [ -f "$FILE" ] 
then
	cp /dev/null $FILE
fi
