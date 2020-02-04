# BIOINFORMATICS APPLICATION FOR K-MEANS ++

## INTRODUCTION

This project aims to reproduce and improve the work done by Monteiro (2017) in his Master degree thesis. The main goal is to group similar
aminoacid structures based on their atom by atom distances using the clustering algorithm K-Means. After that, compare Monteiro's methodology
with K-Means++, a well known initialization algorithm for K-Means.

The metrics for the descripted comparison are:

* Time for execution;
* CPU use;
* Quality of formed clusters (based on RMS);
* Distance between cluster members and their centroids;
* Other relevant metrics suggested by the advisor professor and colleagues;

## METHODOLOGY

Both of the approaches to clustering aminoacid structures previously described it's gonna be used in a database of 16583 aminoacid-pair
PDB files. The main steps for the methodology of this work are as follows:

* Calculate atom by atom distance of the 16583 aminoacid-pair of the database;
* Group all of the atom distance vectors using Matlab K-Means.
* Using LSQKAB, calculate the metrics described in Introduction section. Basically, the quality of the formed clusters will be calculate 
by superposing all of the aminoacid-pairs inside a cluster and retrieving their atom by atom distance after superposition.
* Repeating all steps above using K-Means++, generate same metrics as K-Means.
* Compare the impact of a well-known initialization of K-Means on a Bioinformatics application.

## REFERENCES

MONTEIRO, O. M. **Desenvolvimento de uma metodologia baseada em matriz de distâncias para a verificação de similaridades em proteínas.**
CEFET-MG, 2017.

DIAS, S. R. **Residue interaction database: proposição de mutações sítio dirigidas com base
em interações observadas em proteínas de estrutura tridimensional conhecida.**
UFMG,2012.  
