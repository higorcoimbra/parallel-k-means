def load_centroids():
    centroids_file = open('centroids', 'r')
    centroids_coordinates = []
    for str_centroid_coordinates in centroids_file:
        centroids_coordinates.append(tuple(map(float, str_centroid_coordinates.split(' ')[:-1])))
    return centroids_coordinates

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
        acc_cost += euclidean_distance(centroid_coordinates, point)
    
    return acc_cost

centroids_coordinates = load_centroids()
print(centroids_coordinates)
# points = load_points()

