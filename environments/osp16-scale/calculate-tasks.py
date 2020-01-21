#!/usr/bin/python3

import datetime
import sys

infile = sys.argv[1]

play_start = task_start = play = task = None
plays = {}
tasks = {}
old_start = None
old_start['PLAY '] = None
old_start['TASK '] = None

with open(infile) as f:
    line = f.readline()
    while line:
        if 'PLAY ' in line:
            start = line.split(' ')[0] + ' ' + line.split(' ')[1].split(',')[0]
            current = datetime.datetime.strptime(start, '%Y-%m-%d %H:%M:%S')
            if old_start:
                length = current - old_start[i]
                plays[task] = length
            old_start = current
            task = line
        line = f.readline()

f.close()

with open(infile) as f:
    line = f.readline()
    while line:
        if 'TASK ' in line:
            start = line.split(' ')[0] + ' ' + line.split(' ')[1].split(',')[0]
            current = datetime.datetime.strptime(start, '%Y-%m-%d %H:%M:%S')
            if old_start:
                length = current - old_start[i]
                tasks[task] = length
            old_start = current
            task = line
        line = f.readline()


for k, v in plays.items():
    print(v, k)
for k, v in tasks.items():
    print(v, k)
