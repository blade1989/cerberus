#!/bin/bash

#-----------------------------------------------
#	Author	    :   Imri Paloja
#	Email	    :	imri.paloja@gmail.com
#	HomePage    :   www.eurobytes.nl
#	Version	    :   0.0.9
#	Name        :   Cerberus
#   OS          :   Works on Ubuntu 
#   Description :   Powerful but lightweight Malware Scanner
#----------------------------------------------- 

# ---------------   Name explanation:  ---------------
#   Cerberus is - usually - the three headed dog that guards the gates of the underworld
#   Cerberus(.sh - guardian) guards your pc(gates) that leads to the inside of your system(underworld) 
#   ...porn protector 5000 - lets be honest about that :D
# ----------------------------------------------------

# ---------------   Simple explanation  ---------------
#   Cerberus, provides a realtime monitor, and file system scanners,
#   plus, various online malware scanners. 
#   With a malware databse from multiple sources
# ------------------------------------------------------


# ---------------   Version Information  ---------------
#   X.X.0: Design Board - Design Mantion
#   X.X.1: Alpha        - Feature Ville
#   X.1.X: Beta         - Stable Road
#   X.0.0: Stable       - Stable Mable
# ------------------------------------------------------

# ---------------       TODO:           ---------------
#   - compile and checkinstall: osslsigncode

#   - create a cerberus.deb/rpm

#   - Display colorfull data output

#   - Decide a file structure

#   - Add online scanners like: VirusTotal, malwr.com, metascan-online

#   - add proper parameters supports

#   - adapt scripts the hardware infromation: only 2 GB available, splits files per 1000 lines, etc...

#   -

#   -

#   -

# -----------------------------------------------------

# ---------------       Issues:         ---------------
#   - 
#   - 
#   - 
#   - 
#   - 
#   - 
#   - 
#   - 
#   - 
#   - 
# -----------------------------------------------------


# TODO

# enable: http://unix.stackexchange.com/q/269906/54880
# mkdir /tmp/osslsigncode/
# cd /tmp/osslsigncode/
# wget https://sourceforge.net/projects/osslsigncode/files/latest/download -O osslsigncode.tar.gz
# tar xaf /tmp/osslsigncode.tar.gz
# cd osslsigncode-1.7.1

# dep:
# sudo apt-get install libssl-dev libcurl4-gnutls-dev
# ./configure
# make
# sudo make install



# Incorporate color code, see: http://misc.flogisoft.com/bash/tip_colors_and_formatting

# RED
# echo -e "\e[31mFound\e[0m"

# GREEN:
# echo -e "\e[32mGood\e[0m"

#Yellow
# echo -e "\e[33mError\e[0m"



# File Structure

# /usr/share/doc, /usr/share/man

#The "share" word is used because what is under /usr/share is platform independent, and can be shared among several machines across a network filesystem.
# Therefore this is the place for manuals, documentations, examples etc.


# /opt – Optional add-on Applications

#     opt stands for optional.
#     Contains add-on applications from individual vendors.
#     add-on applications should be installed under either /opt/ or /opt/ sub-directory.

# Not all Malware that are in the Clamav DB, are available in the VirusTotal or malwr database

# key use malwr.com
# malwr_api_key=""

# submission disabled. Please come back at a later time, we hope to be able to resume operations soon. We apologize for the inconvenience.
# curl -F api_key=$malwr_api_key -F shared=yes -F file=/tmp/9A0E765EECC5433AF3DC726206ECC56E https://malwr.com/api/analysis/add/

# nmap --script http-virustotal --script-args='apikey="",checksum="/path/cryptowall.bin"'

# VirusTotal=""

# curl -s -X POST 'https://www.virustotal.com/vtapi/v2/file/report' --form apikey="" --form resource="e4736f7f320f27cec9209ea02d6ac695" | sed 's|\},|\}\n|g'

# |awk -F'positives\":' '{print "VirusTotal scanners:" $2}'|awk -F' ' '{print $1$2" "$3$6$7}'|sed 's/["}]//g' && exit

# HashLookup
#https://hashlookup.metascan-online.com/v2/hash/8bca0031f3b691421cb15f9c6e71ce193355d2d8cf2b190438b6962761d0c6bb
# nmap --script http-virustotal --script-args='apikey="",checksum="/tmp/cryptowall.bin"'


# Here comes the boom...



# /usr/lib/cerberus/databases/

# /opt – Optional add-on Applications

# exmaple log entry:
# Mar  10 02:17:01 blade-X550CC CRON[3071]: pam_unix(cron:session): session closed for user root

# example cerberus logs:

# /var/log/cerberus/2016-03-10.log
# Wed Mar 16 16:27:30 CET 2016 - blade-X550CC - Good[564]: not allowed to scan /home/blade/malware_test_files/Winddows.exe
# Wed Mar 16 16:27:45 CET 2016 - blade-X550CC - Error[564]: empty file /home/blade/malware_test_files/binary.exe
# Wed Mar 16 16:27:26 CET 2016 - blade-X550CC - found[564]: Zeus.TrojanWorkmRootkit /home/blade/malware_test_files/binary.exe

# code:$($!)
# $(date) - $(hostname) - scan[$(pgrep $0)]: $(scanned_files)

# Variables
date="$(date +%F)"

# ColorCode:
yellow="\e[33m"
green="e[32m"
red="\e[31m"
EndColor="\e[0m"

# File paths:

logs="/var/log/"
opt="/opt/cerberus/"
var="/var/log/"


pathtocerberus="$PWD/$(basename $0)"
# Checks cerberus for syntax errors
if [ "$(bash -n $pathtocerberus)" = "" ]; then
    echo "" > /dev/null
else 
	echo "$0 has the following errors"
	bash -n $0
	exit
fi

# Check if root user is using this:
if [ $(id -u) = "0" ]; then
    echo "" > /dev/null
else 
	echo "This scripts needs root permissions"
	exit
fi

# checks if there is input to play with.
if [ "$1" = "" ]; then
    echo "I need some input to play with"
    exit
else 
    echo "" > /dev/null
fi

# Checks if the input is a directory
if [ "$(file $1 | awk {'print $2'})" = "directory" ]; then
    echo "At the moment directories are not supported"
    exit
else 
	#echo "input ($1) received"
    echo "" > /dev/null
fi

# Checks if the input is an existing file
if [ "$(file $1 | awk {'print $2'})" = "ERROR:" ]; then
    file "$1"
    exit
else
	#echo "input ($1) received"
    echo "" > /dev/null
fi

# Display file type (.exe/.doc/.bin)
exiftool $1 | grep "File Type Extension" | awk {'print $5'} > /tmp/extensions


# Checks if the file type could be read
if [ "$(cat /tmp/extensions)" = "" ]; then

    echo "File type could not be determined"
else 

    echo "Scanning metadata for extensions"
    
    echo "Type of file: "$(cat /tmp/extensions)" "
    
    file "$1"

fi

# for user in $(cut -f1 -d: /etc/passwd); do echo $user; crontab -u $user -l; done

workingdir=$(mktemp -d)

#echo "scanning /home/blade/malware_test_files"

scanning="find /home/blade/malware_test_files -type f -name "*" -exec md5sum {} +"
timestamp="$(date) - $HOSTNAME - scan[$!]"

# echo $scan $timestamp  tee -a /tmp/scanning.txt | awk {'print $2'}

# find /home/blade/malware_test_files -type f -name "*" -exec md5sum {} + | tee -a /tmp/scanning.txt | awk {'print $2'}

# pgrep $0?

echo -n "$timestamp" >> /tmp/scanning.txt

md5sum $1 | tee -a /tmp/scanning.txt | awk {'print $2'}

./trid $1 | tail -n +7

# $(date) - $(hostname) - scan[456$($!)]: /home/blade/malware_test_files/cryptowall.bin

#cat /tmp/scanning.txt | awk {'print $1'} > /tmp/scanned_files.txt

cat opt/cerberus/databases/clam/main_clam/maindb/main.db.* | awk {'print $3'} > /tmp/virus_hash.txt

split -d --lines 5000 "/tmp/virus_hash.txt" "$workingdir/virus_hash."

echo "" > /tmp/found.txt
for i in `ls $workingdir`; do {

    #echo database :$i

    fgrep -x -f /tmp/scanned_files.txt "$workingdir/$i" >> /tmp/found.txt

    # fgrep -x -f $(cat /tmp/scanning.txt | awk {' print $1'}) $(cat databases/clam/main_clam/maindb/$i | awk {'print $3'}) >> /tmp/found.txt
};

done;

echo done

echo "$(wc -l /tmp/found.txt | awk {'print $1'}) virusses found"
echo ""
# 


while read -r LINE; do grep $LINE databases/clam/main_clam/maindb/main.db.* | awk {'print " -" $5'} ; done < /tmp/found.txt

# while read -r LINE; do grep $LINE /tmp/found.txt ; done < /tmp/scanning.txt

# cat /tmp/scanning.txt | grep b269894f434657db2b15949641a67532


# while read -r LINE; do grep $($LINE | awk {'print $2'}) /tmp/found.txt ; done < /tmp/scanning.txt

# grep b269894f434657db2b15949641a67532 /tmp/scanning.txt



# databases/clam/main_clam/maindb/main.db.*

#while read -r LINE; do $LINE | awk {'print $3'} ; done < databases/clam/main_clam/maindb/main.db.*



# fgrep -x -f $(cat /tmp/scanning.txt | awk {' print $1'}) $(cat databases/clam/main_clam/maindb/main.db.9173 | awk {'print $3'}) >> /tmp/found.txt


#     while read -r line; do echo "$line" done < databases/clam/main_clam/maindb/main.db.*





# fgrep -x -f $(cat /tmp/scanning.txt | head -1) $(cat databases/clam/main_clam/maindb/main.db.9173 | head -1 }) >> /tmp/found.txt


# sed -i 's/:/ : /g' databases/clam/main_clam/maindb/main.db.*




# fi


# "$1"

# (printf "File VirusName directory md5 sha256 sha512 ssdeep "; ls -l | sed 1d) | column -t

# echo "scanning $1"
# echo ""

# echo "md5sum"
# md5sum "$1"
# echo ""

# echo "sha256sum"
# sha256sum "$1"
# echo ""

# echo "sha512sum"
# sha512sum "$1"
# echo ""

# echo "ssdeep"
# ssdeep "$1"
# echo ""


# echo "File Information:"
#file "$1"

# echo ""
# exiftool "$1"

# Folders
#find /home/blade/malware_test_files/ -type f -name "*.*" -exec md5sum {} + > docs.txt

