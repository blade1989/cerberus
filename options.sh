#!/bin/bash 

# -----------------------------------------------
#   Author        :   Imri Paloja
#   Email         :   imri.paloja@gmail.com
#   HomePage      :   www.eurobytes.nl
#   Version       :   0.0.9
#   Name          :   Cerberus
#   OS            :   Works on Ubuntu 
#   Description   :   Powerful but lightweight Malware Scanner
# ----------------------------------------------- 

# Checks

# checks if the script is excecuted as root
if [ $(id -u) = "0" ]; then
    echo "" > /dev/null
else 
  echo "This scripts needs root permissions"
  exit
fi

# checks if there is input to play with:
if [ "$1" = "" ]; then
    echo "I need some input to play with"
    exit
else 
    echo "" > /dev/null
fi

# Functions
function MalwareApiKey {
if [ "$(cat /home/blade/scripts/cerberus/etc/cerberus.conf | grep malwarapikey= | grep \# )" = "" ]; then
    
  malwarapikey=$(cat /home/blade/scripts/cerberus/etc/cerberus.conf | grep "malwarapikey=" | sed 's/malwarapikey=//g')
    
else
  
    echo "The malwr.com Key is not enabled" >>/dev/null
fi

}

# Checks if the VirusTotal Key is enabled:
function VirusTotalApiKey {

if [ "$(cat /home/blade/scripts/cerberus/etc/cerberus.conf | grep -x virustotalapikey= | grep \# )" = "" ]; then
    
  virustotalapikey=$(cat /home/blade/scripts/cerberus/etc/cerberus.conf | grep virustotalapikey= | sed 's/virustotalapikey=//g')
    
else
  
    echo "The VirusTotal Key is not enabled" >> /dev/null
fi
}


# case catches the input and tells which option to got through
case $1 in

  -h|--help)
    
    echo "Usage: $0 [options...] [file...]"

    echo "    -f    scan specifically for a file:"

    ;;

  0)
    echo "  "
    ;;
  1)
    echo "-scan"
    ;;
  2)
    echo "-meta"
    ;;
  3)
    echo "Errors selecting input/output files, dirs"
    ;;
  4)
    echo "Option 4"
    ;;


  *)
    echo "$1 is an unknown option. Please run $0 --help"
esac







