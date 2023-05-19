#!/bin/bash

keepalive="https://gateway.iitk.ac.in:1003/keepalive?080902080a3d09c7"

if [ "$1" == 'd' ] || [ "$1" == 'd' ]
then
	magic_value=$(curl --silent google.com | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | sort -u)
	if [ "$magic_value" == "http://www.google.com/" ]
	then
		logout_request="$(curl -s $keepalive | grep logout | cut -d '=' -f 2 | cut -d '"' -f 2)"
		echo $logout_request
		curl --silent --output /dev/null $logout_request
	else
		echo "Connect first..."
	fi
elif [ "$1" == 'c' ] || [ "$1" == 'C' ]
then
	magic_value=$(curl --silent google.com | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | sort -u)
	
	if [ "$magic_value" == "http://www.google.com/" ]
	then
		echo $keepalive
		while true; do curl --silent --output /dev/null $keepalive ; sleep 500s; done
	else
		magic_value=$(curl --silent `curl --silent google.com | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | sort -u` | grep magic | cut -d '=' -f4 | cut -d '"' -f 2)
		username=''
		password=''
		login_request=$(curl --silent -X POST https://gateway.iitk.ac.in:1003/ --data-urlencode "magic=$magic_value" --data-urlencode "username=$username" --data-urlencode "password=$password" | cut -d '=' -f3 | cut -d '"' -f 2)
	
		echo $login_request
		while true; do curl --silent --output /dev/null $login_request ; sleep 500s; done
	fi
else
	echo "Pass either c to connect or d to disconnect."
fi
