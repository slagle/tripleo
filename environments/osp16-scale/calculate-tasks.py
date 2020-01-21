#!/usr/bin/python3

import datetime
import sys

infile = sys.argv[1]

play_start = task_start = play = task = None
plays = {}
tasks = {}

with open(infile) as f:
    line = f.readline()
    while line:
        for i in ['PLAY ', 'TASK ']:
            if i in line:
                task = line
                start = line.split(' ')[0]
                current = datetime.datetime.strptime(start, '%Y-%m-%d %H:%M:%S,sss')
                if task_start:
                    length = current - task_start
                    if 'PLAY' in i:
                        plays[task] = length
                    else:
                        tasks[task] = length
                task_start = current
        line = f.readline()

for k, v in plays.items():
    print(v, k)
for k, v in tasks.items():
    print(v, k)
