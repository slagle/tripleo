#!/usr/bin/python3

import datetime
import sys

infile = sys.argv[1]

play_start = task_start = play = task = None
plays = {}
tasks = {}

with open(infile) as f:
    line = f.readline()
    if 'PLAY ' in line:
        play = line
        play_start = line.split(' ')[0]
        if play_start:
            play_length = play_end - play_start
            plays[play] = play_length
        play_start = datetime.datetime.strptime(start, '%Y-%m-%d %H:%M:%S,sss')
    if 'TASK ' in line:
        task = line
        task_start = line.split(' ')[0]
        if task_start:
            task_length = task_end - task_start
            tasks[task] = task_length
        task-start = datetime.datetime.strptime(start, '%Y-%m-%d %H:%M:%S,sss')

for k, v in plays.items():
    print(v, k)
for k, v in tasks.items():
    print(v, k)
