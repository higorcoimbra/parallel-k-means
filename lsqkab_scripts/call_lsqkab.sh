#! /bin/bash

export PDB_DATABASE=/home/higor/Documents/CEFET/TCC/parallel-k-means/protein_base/mc6

moved_file=`cat $1 | egrep ^$2 | cut -d ' ' -f 2`
fixed_file=`cat $1 | egrep ^$3 | cut -d ' ' -f 2`

lsqkab\
XYZINM $PDB_DATABASE/$moved_file\
XYZINF $PDB_DATABASE/$fixed_file\
DELTAS $PDB_DATABASE/$moved_file-$fixedfile.delta\
<< 'END-lsqkab'
FIT ATOM 1 to 12
MATCH 1 to  12
OUTPUT DELTAS
end
END-lsqkab

