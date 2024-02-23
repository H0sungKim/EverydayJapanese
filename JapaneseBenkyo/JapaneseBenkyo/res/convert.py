import csv
 
name = "n1"
f = open(f'{name}.csv','r')
rdr = csv.reader(f)

data = "[\n"
for line in rdr:
    if line[0] == line[1] :
        line[1] = ""
    data += "    { " + f"\"word\": \"{line[0]}\", \"sound\": \"{line[1]}\", \"meaning\": \"{line[2]}\"" + " },\n"
data += "]"

f.close()


f2 = open(f"{name}.json", "w")

f2.write(data)

f2.close()