from random import randrange
import re

#util variables
points = []
string_coordinates_data = []
coordinates_data = []

#reading through protein database
protein_base_file = open('protein_base/protein_base.txt', 'r')

for aminoacid_pair in protein_base_file:
	string_coordinates_data = re.findall(r'-*[0-9]+\.[0-9]+', aminoacid_pair)
	for coordinate in string_coordinates_data:
		coordinates_data.append(float(coordinate))
	points.append(coordinates_data)
	string_coordinates_data = []
	coordinates_data = []

print(points[randrange(len(points))])

