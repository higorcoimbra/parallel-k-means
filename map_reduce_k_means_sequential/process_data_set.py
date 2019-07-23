f = open('dataset', 'r')

for line in f:
    print(int(line.split(',')[1]))