#! /usr/bin/env python3

with open('lvls.txt') as f:
	lvls = f.readlines()
lvl_data = []
for lvl in lvls:
	if '#' in lvl:
		lvl = lvl[:lvl.find('#')]
	lvl = lvl.strip()
	if lvl:
		with open(lvl) as f:
			lvl_data.append(f.read())
with open('../leveldata.json', 'w') as f:
	f.write('[' + ','.join(lvl_data) + ']')
