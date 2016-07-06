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
#	- https://zeltser.com/malware-sample-sources/

# https://stackoverflow.com/questions/191364/quick-unix-command-to-display-specific-lines-in-the-middle-of-a-file
# Remove duplicate lines: http://unix.stackexchange.com/q/30173/54880
# https://stackoverflow.com/questions/448005/whats-an-easy-way-to-read-random-line-from-a-file-in-unix-command-line
# https://www.virusbulletin.com/virusbulletin/2015/11/optimizing-ssdeep-use-scale

# New Sourc:

# - https://malwareconfig.com/


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


# if [ $(id -u) = "0" ]; then
#     echo "superuser"
# fi
    
# Downloading the databases

cd clam/

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

	mkdir daily_clam

	tar -xzf daily_clam.tar.gz --directory daily_clam

	sudo chown -R blade:blade daily_clam/*.*
	sudo chmod -R 775 daily_clam/*

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

	mkdir main_clam/

	tar -xzf main_clam.tar.gz --directory main_clam/

	sudo chown -R blade:blade main_clam/*.*
	sudo chmod -R 775 main_clam/*

fi

split --lines 5000 -d "main_clam/main.mdb" "main_clam/main.mdb."
sed -i 's/:/ : /g' main_clam/main.mdb.*

# echo "Virus name,md5,Path,ssdeep,sha256,sha512" > /tmp/virus_database.csv
# cat rest/docs.txt | awk {'print "," $2, "," $1'} >> /tmp/virus_database.csv

# cat /tmp/virus_database.csv | sed -e 's/,,/, ,/g' | column -s, -t | less -#5 -N -S

# while read LINE; do echo $LINE | awk {'print $2', 'print $1'} >> /tmdp/virus_database.csv ; done < rest/docs.txt

# cat rest/docs.txt | awk {'print $2, , $1'}

#echo 'Win.Trojan.Qqpass-1714,6:jWACWQYWXGNz8scUP2eCVXOA6pDiRwGZmRfwpzP:jWANnQGza+ntil01i,"/home/blade/malware-sample-sources/virus.exe",32f0b60a78f632259c16b0e94ae8ebbc,29297b7768696c6528632d2d29725b652863295d3d6b5b635d7c7c652863293b6b3d5b,bd7fda7fa94fe3e31b208a782a31f8fcac9401911c9a43a3eb617b62da1e5c97f68d167687453de506193bef6bda224fa064c6c732999b952f24a2c5844b704f' >> /tmp/virus_database.csv

# 6:jWACWQYWXGNz8scUP2eCVXOA6pDiRwGZmRfwpzP:jWANnQGza+ntil01i,"/home/blade/malware-sample-sources/virus.exe"

# while read LINE; do $LINE awk {'print $6'} > ; done < main_clam/main.db.00

# echo "sleep 300000"
# sleep 300000
# Known Good Software
# mkdir "main_clam/whitelist/"
# mv main_clam/*.fp main_clam/whitelist/
# sed -i 's/:/ : /g' main_clam/whitelist/main.fp

# echo -n "Known Good Software: " > main_clam/whitelist/main.info
# wc -l main_clam/whitelist/main.fp | awk {'print $1'} >> main_clam/whitelist/main.info

# # known malicious programs
# mkdir "main_clam/malicious/"
# mv main_clam/*.hdb main_clam/malicious/
# sed -i 's/:/ : /g' main_clam/malicious/main.hdb

# echo -n "Known malicious Software: " > main_clam/malicious/main.info
# wc -l main_clam/malicious/main.hdb | awk {'print $1'} >> main_clam/malicious/main.info

# split --lines 5000 "main_clam/malicious/main.hdb" "main_clam/malicious/main.hdb_5000"


# # MD5 of the PE sections in known malicious programs
# mkdir "main_clam/main/"
# mv main_clam/*.mdb main_clam/main/
# sed -i 's/:/ : /g' main_clam/main/main.mdb

# echo -n "MD5 of the PE sections in known malicious programs: " > main_clam/main/main.info
# wc -l main_clam/main/main.mdb | awk {'print $1'} >> main_clam/main/main.info

# split --lines 5000 "main_clam/main/main.mdb" "main_clam/main/main.mdb_5000"

# # hexadecimal signatures
# mkdir "main_clam/hexadecimal_signatures/"
# mv main_clam/*.ndb main_clam/hexadecimal_signatures/
# sed -i 's/:/ : /g' main_clam/hexadecimal_signatures/main.ndb

# echo -n "Hexadecimal Signatures: " > main_clam/hexadecimal_signatures/main.info
# wc -l main_clam/hexadecimal_signatures/main.ndb | awk {'print $1'} >> main_clam/hexadecimal_signatures/main.info

# split --lines 5000 "main_clam/hexadecimal_signatures/main.ndb" "main_clam/main/main.ndb_5000"


# # Updating trid:
# mkdir "utilities"
# cd "utilities"
# wget --timestamping "http://mark0.net/download/trid_linux.zip"
# unzip -o trid_linux.zip

# wget --timestamping "http://goo.gl/Bnw1"
# mv "Bnw1" "mBnw1.zip"
# unzip -o "mBnw1.zip"
# cd ../
