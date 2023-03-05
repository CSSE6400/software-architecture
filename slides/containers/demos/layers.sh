#!/bin/bash

mount -t tmpfs tmpfs /home/brae/csse6400/tmp
mkdir tmp/upper tmp/workdir
touch tmp/upper/diary.md
clear
echo "> mount -t overlay -o lowerdir=lower/,upperdir=tmp/upper/,workdir=tmp/workdir none merged"
mount -t overlay -o lowerdir=lower/,upperdir=tmp/upper/,workdir=tmp/workdir none merged

/bin/bash
