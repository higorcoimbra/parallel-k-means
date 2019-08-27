import csv

DISTANCE_ARRAY_SIZE = 66

def generate_columns_names():
	n_atoms = 12
	columns_names = []
	for i in range(1, n_atoms):
		for j in range(i+1, n_atoms+1):
			columns_names.append(str(i) + '_' + str(j))
	return tuple(columns_names)

with open('protein_base/formatted_protein_base.txt', 'r') as formatted_protein_base_file:
    lines = (line.split(" ") for line in formatted_protein_base_file)
    with open('protein_base/formatted_protein_base.csv', 'w') as formatted_protein_base_csv:
        writer = csv.writer(formatted_protein_base_csv)
        writer.writerow(generate_columns_names())
        writer.writerows(lines)
