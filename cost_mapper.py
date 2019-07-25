def load_centroid():
    centroid_file = open('centroids', 'r')
    centroid_coordinates = []
    str_centroid_coordinates = centroid_file.readline().split(' ')[:-1]
    for coordinate in str_centroid_coordinates:
        centroid_coordinates.append(float(coordinate))
    return centroid_coordinates

centroid_coordinates = load_centroid()

print(centroid_coordinates)