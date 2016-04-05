# Todo and idea's


- Maybe: Remove all but the neccesary hash algorythms, and use ssdeep as your main scanning tool.
- DONE:	compile and checkinstall: osslsigncode
- DONE:	Display colorfull data output - might further implement 'colorful data' further then currently implemented

- Almost: Decide a file structure
- ALMOST: create a cerberus.deb/rpm - after the file structure is done.

- Add online scanners like: VirusTotal, malwr.com, metascan-online:


	 - VirusTotal:  The following table is a summary your API key's properties. 

>	Privileges 		public key
>	Request rate	4 requests/minute
>	Daily quota		5760 requests/day
>	Monthly quota	178560 requests/month
>	Status 			Key enabled

	SOURCE: https://www.virustotal.com/nl/user/NAME/apikey/

	- malwr.com:

		Malwr provides an API interface that allows some automated interaction with the submission system, the analysis results and the website as a whole.

	SOURCE: https://malwr.com/account/profile/

	metascan-online:

		Free API keys obtained through the OPSWAT Portal allow 25 file scans, 1500 hash lookups, and 25 IP address or URL scans per hour. To extend your key to allow additional usage, please contact OPSWAT sales.

	SOURCE: https://www.metadefender.com/public-api#!/about


- add proper parameters supports
- adapt script to the hardware information: only 2 GB available, splits files per 1000 lines, etc...
- use PlayOnLinux to monitor the file, like malwr.com
- Add a Virus Database

	Read the clam av database, get the md5, make a folder using the md5 a folder name, the rest of the information output as text in the folder. 
	compress the folder as .tar, and the entire database dir as .gz. You can read tar.gz files. 

	Code to make the md5sum to a folder, and extract the information to that folder.

		while read -r LINE; do mkdir $(echo $LINE | awk {'print $3'}); echo $LINE | awk {'print $1" - "$5'} >> $(echo $LINE | awk {'print $3'})/info.txt ; done < all.db

	After that get more data regarding the md5s via the Online Virus Signatures site.
