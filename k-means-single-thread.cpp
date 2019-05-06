#include <bits/stdc++.h>

using namespace std;

class Point{
    private:

    float x,y;

    int cluster;

    public:

    Point(float _x, float _y){
        x = _x;
        y = _y;
    }

    void setCluster(int _cluster){cluster = _cluster;}

    float getX(){return x;}
    float getY(){return y;}
    int getCluster(){return cluster;}
};

float calc_euclidean_distance(Point p1, Point p2){
    return pow((p1.getX() - p2.getX()), 2) + pow((p1.getY() - p2.getY()), 2);
}

int main(){
    //initial variables
    float random_coord_x, random_coord_y, space_limit = 100.0, dist_to_cluster;
    vector<Point> random_points, clusters;
    int random_pos, n_clusters = 5, n_points = 500, n_iterations = 1, chosen_cluster;

    //initialize random seed
    srand(time(NULL));

    //initialize random points in 2d space
    for(int i = 0;i < n_points;i++){
        random_coord_x = (float) (rand()) / ((float) (RAND_MAX/space_limit));
        random_coord_y = (float) (rand()) / ((float) (RAND_MAX/space_limit));
        random_points.push_back(Point(random_coord_x, random_coord_y));
    }

    //set initial clusters
    for(int i = 0; i < n_clusters; i++){
        random_pos = rand() % n_points;
        clusters.push_back(random_points[random_pos]);
    }

    //main loop
    for(int i = 0; i < n_iterations; i++){
        //assign a cluster to every point
        for(int j = 0; j < n_points; j++){
            dist_to_cluster = INT_MAX;
            for(int k = 0; k < n_clusters; k++){
                if(dist_to_cluster > calc_euclidean_distance(random_points[j], clusters[k])){
                    chosen_cluster = k;
                    dist_to_cluster = calc_euclidean_distance(random_points[j], clusters[k]);
                }
            }
            random_points[j].setCluster(chosen_cluster);
        }

        //calculate means
    }
}