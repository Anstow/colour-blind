#! /usr/bin/env python3

with open('lvls.txt') as f:
	lvls = [s.strip() for s in f.readlines() if s.strip()]
lvl_data = []
for lvl in lvls:
	with open(lvl) as f:
		lvl_data.append(f.read())
with open('../leveldata.json', 'w') as f:
	f.write('[' + ','.join(lvl_data) + ']')
