def load_centroid():
    centroid_file = open('centroids', 'r')
    centroid_coordinates = []
    str_centroid_coordinates = centroid_file.readline().split(' ')[:-1]
    print(len(str_centroid_coordinates))
    for coordinate in str_centroid_coordinates:
        centroid_coordinates.append(float(coordinate))
    return centroid_coordinates

def load_points():
    points_file = open('protein_base/formatted_protein_base.txt', 'r')
    points = []
    for point_data in points_file:
        coordinates_array = []
        for coordinate in point_data.split(' ')[:-1]:
            coordinates_array.append(float(coordinate))
        points.append(coordinates_array)
    return points

def euclidean_distance(p1, centroid):
    acc_distance = 0
    for i in range(0, len(p1)):
        acc_distance += (p1[i] - centroid[i])**2
    return acc_distance

def cost(centroid_coordinates, points):
    acc_cost = 0
    for point in points:
        acc_cost += euclidean_distance(centroid_coordinates, points)
    
    return acc_cost

centroid_coordinates = load_centroid()
points = load_points()

