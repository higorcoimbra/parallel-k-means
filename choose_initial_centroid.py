from random import randrange
import re

#util variables
points = []
string_coordinates_data = []
coordinates_data = []
centroid_file = open('centroids', 'w')

#reading through protein database
protein_base_file = open('protein_base/formatted_protein_base.txt', 'r')

for aminoacid_pair in protein_base_file:
	points.append(aminoacid_pair.split(' ')[:-1])

for coordinate in points[randrange(len(points))]:
	centroid_file.write(coordinate + ' ')

