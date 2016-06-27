import numpy as np

print ('Preparing Arrays...')
f = open('D:/r/wd/bimbo/data/source/train.csv', "r")
f.readline()
latest_demand_clpro = dict()
global_median = list()
total = 0
while 1:
    line = f.readline().strip()
    total += 1
    if total % 5000000 == 0:
        print('Read {} lines..'.format(total))
    if line == '':
        break
    arr = line.split(",")
    week = int(arr[0])
    depot = int(arr[1])
    channel = int(arr[2])
    route = int(arr[3])
    client = int(arr[4])
    product = int(arr[5])
    demand = int(arr[10])
    if client != '' and product != '':
        hsh = (depot, client, product)
        if hsh in latest_demand_clpro:
            latest_demand_clpro[hsh] = ((.5 * latest_demand_clpro[hsh]) + (.5 * demand))
        else:
            latest_demand_clpro[hsh] = demand
    list.append(global_median, demand)
f.close()
print('')
path = ('submission3.csv')
out = open(path, "w")
f = open('D:/r/wd/bimbo/data/source/test.csv', "r")
f.readline()
out.write("id,Demanda_uni_equil\n")
median_demand = np.median(global_median) 
total = 0
total1 = 0
total2 = 0
while 1:
    line = f.readline().strip()
    total += 1
    if total % 1000000 == 0:
        print('Write {} lines...'.format(total))
    if line == '':
        break
    arr = line.split(",")
    id = int(arr[0])
    week = int(arr[1])
    depot = int(arr[2])
    client = int(arr[5])
    product = int(arr[6])
    out.write(str(id) + ',')
    hsh = (depot, client, product)
    if hsh in latest_demand_clpro:
        d = latest_demand_clpro[hsh]
        out.write(str(d))
        total1 += 1
    else:
        out.write(str(round(median_demand) - 1))
        total2 += 1
    out.write("\n")
out.close()
print ('')
print ('Total 1: {} ...'.format(total1))
print ('Total 2: {} ...'.format(total2))
print ('')
print ('Completed!')