#!/bin/bash

#-----------------------------------------------
#	Author	    :   Imri Paloja
#	Email	    :	imri.paloja@gmail.com
#	HomePage    :   www.eurobytes.nl
#	Version	    :   0.5.1
#	Name        :   update_db
#	Info		:	Downloads Virus definitions from various sources
#----------------------------------------------- 

# Sources

# https://stackoverflow.com/questions/191364/quick-unix-command-to-display-specific-lines-in-the-middle-of-a-file
# Remove duplicate lines: http://unix.stackexchange.com/q/30173/54880
# https://stackoverflow.com/questions/448005/whats-an-easy-way-to-read-random-line-from-a-file-in-unix-command-line
# https://www.virusbulletin.com/virusbulletin/2015/11/optimizing-ssdeep-use-scale


# ToDo:

# - Read the json data in shell script
#	- http://stackoverflow.com/a/20488535/1148529

# Json maybe, or we could use: CSV
# 	- http://www.unix.com/shell-programming-and-scripting/132268-how-create-csv-file-using-shell-script.html

# cdb: container metadata
# fp: database of known good files
# hdb: MD5 hashes of known malicious programs
# ldb: matching signatures, icon signatures and PE metadata strings
# mdb: MD5 hashes of PE sections in known malicious programs
# ndb: hexadecimal signatures
# rmd: archive metadata signatures
# zmd: archive metadata signatures


# make the cutoms db .7z.xz
# https://askubuntu.com/questions/92328/how-do-i-uncompress-a-tarball-that-uses-xz
#    add     
# 7z a -t7z -m0=lzma -mx=9 -mfb=64 -md=32m -ms=on cerberus_db.7z *.xz


# 7z a -mx=9 cerberus_db daily.rmd.xz

# 7z a -mx=9 daily.crbrs daily.rmd.xz

# xz -z main.mdb -e -v -9



# if [ $(id -u) = "0" ]; then
#     echo "superuser"
# fi
    
# Downloading the databases

# Checking daily.cvd timestamp
dailytime=$(stat -c '%y' daily.cvd | awk {'print $2'})

# Downloading the latest version:
echo "Checking for new version of daily.cvd"
wget --timestamping http://database.clamav.net/daily.cvd


if [ $(stat -c '%y' daily.cvd | awk {'print $2'}) = "$dailytime" ]; then
    
    echo "No new version of daily.cvd available"
else 

# Daily CVD

	# extracting and making the current user the owner
	dd if=daily.cvd of=daily_clam.tar.gz bs=512 skip=1

	mkdir clam/daily_clam

	tar -xzf daily_clam.tar.gz --directory clam/daily_clam

	sudo chown -R blade:blade clam/daily_clam/*.*
	sudo chmod -R 775 clam/daily_clam/*

fi


# Checking main.cvd timestamp
maintime=$(stat -c '%y' main.cvd | awk {'print $2'})

# Downloading the latest version:
echo "Checking for new version of main.cvd"
wget --timestamping http://database.clamav.net/main.cvd


if [ $(stat -c '%y' main.cvd | awk {'print $2'}) = "$maintime" ]; then
    
    echo "No new version of main.cvd available"

else 

# main CVD

	# extracting and making the current user the owner
	dd if=main.cvd of=main_clam.tar.gz bs=512 skip=1

	mkdir clam/main_clam/

	tar -xzf main_clam.tar.gz --directory clam/main_clam/

	sudo chown -R blade:blade clam/main_clam/*.*
	sudo chmod -R 775 clam/main_clam/*

fi

echo "Virus name,Path,file,md5" > /tmp/clam/main_clam.csv


mkdir clam/main_clam/maindatabase/
split --lines 5000 -d "clam/main_clam/main.mdb" "clam/main_clam/maindatabase/main.db."

sed -i 's/:/ : /g' clam/main_clam/maindatabase/main.db.00

while read LINE; do $LINE  | awk {'print $6'} > ; done < databases/clam/main_clam/main.db.*


# Known Good Software
mkdir "main_clam/whitelist/"
mv main_clam/*.fp main_clam/whitelist/
sed -i 's/:/ : /g' main_clam/whitelist/main.fp

echo -n "Known Good Software: " > main_clam/whitelist/main.info
wc -l main_clam/whitelist/main.fp | awk {'print $1'} >> main_clam/whitelist/main.info

# known malicious programs
mkdir "main_clam/malicious/"
mv main_clam/*.hdb main_clam/malicious/
sed -i 's/:/ : /g' main_clam/malicious/main.hdb

echo -n "Known malicious Software: " > main_clam/malicious/main.info
wc -l main_clam/malicious/main.hdb | awk {'print $1'} >> main_clam/malicious/main.info

split --lines 5000 "main_clam/malicious/main.hdb" "main_clam/malicious/main.hdb_5000"


# MD5 of the PE sections in known malicious programs
mkdir "main_clam/main/"
mv main_clam/*.mdb main_clam/main/
sed -i 's/:/ : /g' main_clam/main/main.mdb

echo -n "MD5 of the PE sections in known malicious programs: " > main_clam/main/main.info
wc -l main_clam/main/main.mdb | awk {'print $1'} >> main_clam/main/main.info

split --lines 5000 "main_clam/main/main.mdb" "main_clam/main/main.mdb_5000"

# hexadecimal signatures
mkdir "main_clam/hexadecimal_signatures/"
mv main_clam/*.ndb main_clam/hexadecimal_signatures/
sed -i 's/:/ : /g' main_clam/hexadecimal_signatures/main.ndb

echo -n "Hexadecimal Signatures: " > main_clam/hexadecimal_signatures/main.info
wc -l main_clam/hexadecimal_signatures/main.ndb | awk {'print $1'} >> main_clam/hexadecimal_signatures/main.info

split --lines 5000 "main_clam/hexadecimal_signatures/main.ndb" "main_clam/main/main.ndb_5000"


# Updating trid:
mkdir "utilities"
cd "utilities"
wget --timestamping "http://mark0.net/download/trid_linux.zip"
unzip -o trid_linux.zip

wget --timestamping "http://goo.gl/Bnw1"
mv "Bnw1" "mBnw1.zip"
unzip -o "mBnw1.zip"
cd ../
