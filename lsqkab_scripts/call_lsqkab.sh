#! /bin/bash

export START_CCP4_FILE_LOCATION=/home/higor/Documents/CCP4/ccp4-7.0
export PDB_DATABASE=/home/higor/Documents/CEFET/TCC/parallel-k-means/protein_base/mc6
export DELTA_FILES_LOCATION=/home/higor/Documents/CEFET/TCC/parallel-k-means/protein_base/delta_files
source ~/Documents/CCP4/ccp4-7.0/bin/ccp4.setup-sh

moved_file=`cat $1 | egrep ^$2 | cut -d ' ' -f 2`
fixed_file=`cat $1 | egrep ^$3 | cut -d ' ' -f 2`

#echo $moved_file
#echo $fixed_file

lsqkab                        \
XYZINM $PDB_DATABASE/${moved_file} \
XYZINF $PDB_DATABASE/${fixed_file} \
DELTAS $DELTA_FILES_LOCATION/${moved_file}-${fixed_file}.delta > /dev/null \
<< 'END-lsqkab'
FIT ATOM 1 to 12
MATCH 1 to  12
OUTPUT DELTAS
end
END-lsqkab

delta_file=`cat $DELTA_FILES_LOCATION/${moved_file}-${fixed_file}.delta | cut -d$' ' -f6`
printf '%b\n' $delta_file > $DELTA_FILES_LOCATION/${moved_file}-${fixed_file}.delta
valid_superposition=`awk '$1<0.5{c++} END{print c+0}' $DELTA_FILES_LOCATION/${moved_file}-${fixed_file}.delta`
echo $valid_superposition
