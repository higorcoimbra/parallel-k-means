'''
    This code is reponsible of process the amioacid-pair base
    and calculate the primary data structure used in this work
    i.e, a 66-position array of distances between all of the 12
    atoms in the aminoaacid-pair structures from the database.
'''

'''
    The primary database is formatted in 36-position array 
    with the x,y and z coordinates of all 12 atoms in the
    amioacid-pair structures.
'''

import re
import sys

AMONIOACID_PAIR_LEN = 36
N_COORDINATES = 3

def euclidean_distance(a1, a2):
    return (a1[0]-a2[0])**2 + (a1[1]-a2[1])**2 + (a1[2]-a2[2])**2

def set_atoms_distances(atoms_coordinates):
    atoms_distances = []
    for i in range(0, len(atoms_coordinates)):
        src_atom = atoms_coordinates[i]
        for j in range(i+1, len(atoms_coordinates)):
            atoms_distances.append(euclidean_distance(src_atom, atoms_coordinates[j]))
    
    return atoms_distances

protein_base_file = open('protein_base/protein_base.txt', 'r')
formatted_protein_base_file = open('protein_base/formatted_protein_base.txt', 'w')
formatted_protein_base_content = ''

for aminoacid_pair in protein_base_file:
    aminoacid_pair_id = re.findall(r'^[0-9]*', aminoacid_pair)[0]
    string_coordinates_data = re.findall(r'-*[0-9]+\.[0-9]+', aminoacid_pair)
    
    atoms_coordinates = []
    for i in range(0, AMONIOACID_PAIR_LEN, N_COORDINATES):
        atoms_coordinates.append((float(string_coordinates_data[i]), float(string_coordinates_data[i+1]), float(string_coordinates_data[i+2])))        
    
    formatted_protein_base_content += aminoacid_pair_id + ' '
    for distance in set_atoms_distances(atoms_coordinates):
        formatted_protein_base_content += str(distance)
        formatted_protein_base_content += ' '
    formatted_protein_base_content = formatted_protein_base_content.strip()
    formatted_protein_base_content += '\n'
    
    string_coordinates_data = []
formatted_protein_base_content.strip('\n')
formatted_protein_base_file.write(formatted_protein_base_content)