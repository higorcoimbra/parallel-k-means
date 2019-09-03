from pyspark import SparkContext
from pyspark.mllib.clustering import KMeans

from numpy import array
from math import sqrt

import sys

def error(point):
    center = clusters.centers[clusters.predict(point)]
    return sqrt(sum([x**2 for x in (point - center)]))

sc = SparkContext(appName="KMeansAminoacid")
dataset = sc.textFile('/home/higor/Documents/CEFET/TCC/parallel-k-means/protein_base/formatted_protein_base.txt')
parsedDataSet = dataset.map(lambda line: array([float(x) for x in line.split(' ')])[1:])

clusters = KMeans.train(parsedDataSet, k=500, maxIterations=1000)

WSSSE = parsedDataSet.map(lambda point: error(point)).reduce(lambda x, y: x + y)
print("Within Set Sum of Squared Error = " + str(WSSSE))

sc.stop()