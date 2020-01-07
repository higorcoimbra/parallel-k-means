#!/bin/sh

lsqkab                        \
XYZINM $PDB_TEST_DATABASE/11bg_CYS-26-B_CYS-84-B_mc6.pdb \
XYZINF $PDB_TEST_DATABASE/133l_CYS-65-A_CYS-81-A_mc6.pdb \
DELTAS $PDB_TEST_DATABASE/delta_out.delta       \
<< 'END-lsqkab'
FIT ATOM 1 to 12
MATCH 1 to  12
OUTPUT DELTAS 
end
END-lsqkab
