import csv
values = []
temp = open('info.txt','r').readlines()
words = {}
header = ["Name,Area,ConvexArea,Perimeter,Orientation,Centroid,MajorAxisLength,MinorAxisLength,Label\n"]
with open('info.txt','r') as csv_file:
    csv_read = csv.reader(csv_file,delimiter=' ')
    for n_row, row in enumerate(csv_read):
        if len(row) > 3:
            values.append(str(row[3]))
        else:
            values.append('N')
print('B: ' + str(values.count('B')))
print('M: ' + str(values.count('M')))
with open('exp.txt','r') as csv_file:
    with open('exp2.txt', 'w') as csv_writer:
        csv_read = csv.reader(csv_file)
        csv_write = csv.writer(csv_writer, lineterminator='\n')
        all = []
        # all.append(header)
        for n_row, row in enumerate(csv_read):
            if values[n_row] != 'N':
                row.append(values[n_row])
                all.append(row)
        
        csv_write.writerows(all)

with open('exp.txt','r') as csv_file:
    with open('inputs.txt', 'w') as csv_writer:
            csv_read = csv.reader(csv_file)
            csv_write = csv.writer(csv_writer, lineterminator='\n')
            all = []
            # all.append(header)
            for n_row, row in enumerate(csv_read):
                if values[n_row] != 'N':
                    # row.append(values[n_row])
                    all.append(row)
            
            csv_write.writerows(all)
file = open('targets.txt', 'w')
for val in values:
    if val != 'N':
        if val == 'B':
            file.write(str(1))
            file.write("\n")
        else:
            file.write(str(0))
            file.write("\n")