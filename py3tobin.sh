#!/bin/sh

# This program takes a python3 .pyx (or .py) file and compiles it into c code binary
# Optionally chmod +x this program and place in /usr/local/bin as 'py3tobin'
# Developed by Ian P Jarvis

# get program name
prg=$(basename $0):

# input check
if [ -z $1 ]; then
 echo $prg"error:no code specified\a"
 exit 1
elif [ -z `which python3` ]; then
 echo $prg"error:could not find python3\a"
 exit 2
elif [ -z `which cython3` ]; then
 echo $prg"error:could not find cython3\a"
 exit 2
elif [ -z `which gcc` ]; then
 echo $prg"error:could not find gcc\a"
 exit 2
elif [ -z `which python3-config` ]; then
 echo $prg"error:could not find python3-config"
 echo $prg"(install with python3-pkgconfig)\a"
 exit 2
fi

# cython3 compilation to c code
echo $prg"compiling to c code..."
cython3 -f -3 --embed $@ -o main.c && \

# gcc compilation of c code
echo $prg"compiling to object code..." && \
gcc $(python3-config --cflags) -fPIE -c main.c -o main.o && \

# link object file to python3 lib and output binary
echo $prg"linking..." && \
gcc main.o $(python3-config --embed --ldflags) -o main && \

# finishing up output messages
echo $prg"output binary file is named 'main'\n"$prg"done\a"

exit 0
