from random import randrange
import re

#util variables
points = []
string_coordinates_data = []
coordinates_data = []
centroid_file = open('centroids', 'w')

#reading through protein database
protein_base_file = open('protein_base/protein_base.txt', 'r')

for aminoacid_pair in protein_base_file:
	string_coordinates_data = re.findall(r'-*[0-9]+\.[0-9]+', aminoacid_pair)
	points.append(string_coordinates_data)
	string_coordinates_data = []

for coordinate in points[randrange(len(points))]:
	centroid_file.write(coordinate + ' ')

