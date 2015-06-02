#!/bin/bash

echo " "
echo "------------------------------"
echo "        GeoBlocked? "
echo "------------------------------"
echo " "
echo "Enter proxy list file name, if not in same directory provide full path:  "
read LIST
echo "Enter URL to see if its being geoblocked"
read URL
echo " "
echo "Checking status of:  $URL This could take some time"
echo " "
echo " "

PROXY="$(< "$LIST")"
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

function url_check()
	{
		 export http_proxy="http://$i"

		 status="$(curl --max-time 15 --connect-timeout 15 -s -o /dev/null -I -w '%{http_code}' $URL)"
		 country="$(curl -s http://whatismycountry.com/ | sed -n 's|.*,\(.*\)</h3>|\1|p')"
		 DOWN="$(echo "${red} $i - URL IS DOWN - $country ${reset}")"
		 UP="$(echo "${green}$i - URL IS UP - $country ${reset}")"
		 TIMEOUT="$(echo "${red}$i - Proxy connection took too long${reset}")"
		
		case "$status" in 
		 	"200") echo "$UP";;
			"201") echo "$UP";;
			"202") echo "$UP";;
			"203") echo "$UP";;
			"204") echo "$UP";;
			"400") echo "$DOWN";;
			"401") echo "$DOWN";;
			"402") echo "$DOWN";;
			"403") echo "$DOWN";;
			"404") echo "$DOWN";;
			"500") echo "$DOWN";;
			"501") echo "$DOWN";;
			"503") echo "$DOWN";;
			*) echo "$TIMEOUT";;
		esac
		unset http_proxy;
	}

for i in $PROXY; do
	url_check $i
done