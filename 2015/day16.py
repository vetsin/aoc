import pandas as pd

sues = {}
with open('day16.in', 'r') as f:
  for line in f:
    parts = line.strip().split(': ', 1)
    n = int(parts[0].split()[-1])
    k = {k:int(v) for k,v in [a.split(': ') for a in parts[1].split(', ')]}
    sues[n] = k
with open('day16.in', 'r') as f:
  for line in f:
    print(line.strip().split(': '))
    break
df = pd.DataFrame.from_dict(sues, orient='index')
p1 = df.query('''
(children == 3 or children.isna()) \
and (cats == 7 or cats.isna()) \
and (samoyeds == 2 or samoyeds.isna()) \
and (pomeranians == 2 or pomeranians.isna()) \
and (akitas == 0 or akitas.isna()) \
and (vizslas == 0 or vizslas.isna()) \
and (goldfish == 5 or goldfish.isna()) \
and (trees == 3 or trees.isna()) \
and (cars == 2 or cars.isna()) \
and (perfumes == 1 or perfumes.isna()) \
             ''')
print('p1', p1.index[0])
p2 = df.query('''
(children == 3 or children.isna()) \
and (cats > 7 or cats.isna()) \
and (samoyeds == 2 or samoyeds.isna()) \
and (pomeranians < 2 or pomeranians.isna()) \
and (akitas == 0 or akitas.isna()) \
and (vizslas == 0 or vizslas.isna()) \
and (goldfish < 5 or goldfish.isna()) \
and (trees > 3 or trees.isna()) \
and (cars == 2 or cars.isna()) \
and (perfumes == 1 or perfumes.isna()) \
             ''')
print('p2', p2.index[0])