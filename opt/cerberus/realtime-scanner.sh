#!/bin/bash

#-----------------------------------------------
#	Author	    :   Imri Paloja
#	Email	    :	imri.paloja@gmail.com
#	HomePage    :   www.eurobytes.nl
#	Version	    :   0.0.1
#	Name        :   realtime-scanner.sh
#	Info	    :	monitor everything for suspicious behavior.
#----------------------------------------------- 

# Tools that will be used:

# 	- lsof(list open files)
# 	- http://askubuntu.com/a/49030/36315


# make a list of all the running process
ps aux | awk {'print $2'} | uniq -u | sed 1d > /tmp/procceslist.txt

# Get the pids of all rthe running process
# while read -r LINE; do pgrep $LINE > /tmp/pids.txt ; done < /tmp/procceslist.txt

# Find out the path of all those running processes:
while read -r LINE; do echo "/proc/$LINE/exe" | uniq -u >> /tmp/procpaths.txt ; done < /tmp/procceslist.txt
while read -r LINE; do readlink -f $LINE >> /tmp/filepaths.txt ; done < /tmp/procpaths.txt

# hash them
while read -r LINE; do sha256sum $LINE | awk {'print $1'} | uniq -u >> /tmp/hashed_proc.txt ; done < /tmp/filepaths.txt

# And here is where we scanned them

# Scanning....
