import numpy as np

print ('Preparing Arrays...')
f = open('D:/r/wd/bimbo/data/source/train.csv', "r")
#f = open('C:/renjith/datascience/git/data/grupobimbo/train.csv', "r")
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
        hsh1 = (depot, channel, route, client, product)
        hsh2 = (depot, channel, client, product)
        hsh3 = (depot, route, client, product)
        hsh4 = (depot, client, product)
        hsh5 = (client, product)
        hsh6 = (product)
        if hsh1 in latest_demand_clpro:
            latest_demand_clpro[hsh1] = ((.5 * latest_demand_clpro[hsh1]) + (.5 * demand))
        else:
            latest_demand_clpro[hsh1] = demand
        
        if hsh2 in latest_demand_clpro:
            latest_demand_clpro[hsh2] = ((.5 * latest_demand_clpro[hsh2]) + (.5 * demand))
        else:
            latest_demand_clpro[hsh2] = demand
            
        if hsh3 in latest_demand_clpro:
            latest_demand_clpro[hsh3] = ((.5 * latest_demand_clpro[hsh3]) + (.5 * demand))
        else:
            latest_demand_clpro[hsh3] = demand
 
        if hsh4 in latest_demand_clpro:
            latest_demand_clpro[hsh4] = ((.5 * latest_demand_clpro[hsh4]) + (.5 * demand))
        else:
            latest_demand_clpro[hsh4] = demand
            
        if hsh5 in latest_demand_clpro:
            latest_demand_clpro[hsh5] = ((.5 * latest_demand_clpro[hsh5]) + (.5 * demand))
        else:
            latest_demand_clpro[hsh5] = demand

        if hsh6 in latest_demand_clpro:
            latest_demand_clpro[hsh6] = ((.5 * latest_demand_clpro[hsh6]) + (.5 * demand))
        else:
            latest_demand_clpro[hsh6] = demand
    list.append(global_median, demand)
f.close()
print('')
path = ('submission4.csv')
out = open(path, "w")
f = open('D:/r/wd/bimbo/data/source/test.csv', "r")
#f = open('C:/renjith/datascience/git/data/grupobimbo/test.csv', "r")
f.readline()
out.write("id,Demanda_uni_equil\n")
median_demand = np.median(global_median) 
total = 0
total1 = 0
total2 = 0
total3 = 0
total4 = 0
total5 = 0
total6 = 0
total7 = 0
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
    hsh1 = (depot, channel, route, client, product)
    hsh2 = (depot, channel, client, product)
    hsh3 = (depot, route, client, product)
    hsh4 = (depot, client, product)
    hsh5 = (client, product)
    hsh6 = (product)
    if hsh1 in latest_demand_clpro:
        d = latest_demand_clpro[hsh1]
        out.write(str(d))
        total1 += 1
    elif hsh2 in latest_demand_clpro:
        d = latest_demand_clpro[hsh2]
        out.write(str(d))
        total2 += 1
    elif hsh3 in latest_demand_clpro:
        d = latest_demand_clpro[hsh3]
        out.write(str(d))
        total3 += 1
    elif hsh4 in latest_demand_clpro:
        d = latest_demand_clpro[hsh4]
        out.write(str(d))
        total4 += 1
    elif hsh5 in latest_demand_clpro:
        d = latest_demand_clpro[hsh5]
        out.write(str(d))
        total5 += 1
    elif hsh6 in latest_demand_clpro:
        d = latest_demand_clpro[hsh6]
        out.write(str(d))
        total6 += 1
    else:
        out.write(str(round(median_demand) - 1))
        total7 += 1
    out.write("\n")
out.close()
print ('')
print ('Total 1: {} ...'.format(total1))
print ('Total 2: {} ...'.format(total2))
print ('Total 3: {} ...'.format(total2))
print ('Total 4: {} ...'.format(total2))
print ('Total 5: {} ...'.format(total2))
print ('Total 6: {} ...'.format(total2))
print ('Total 7: {} ...'.format(total2))
print ('')
print ('Completed!')





