#!/usr/bin/env bash

#Script developed to do automatic renewal of the ssl certificate
#I have observed that it's not easy to keep track of the ssl certificate renewal process
#######################################################################
#######################################################################
######################### HISP RWANDA  ################################
######################### Joseph MANZI	###############################
#######################################################################
#######################################################################

set -e

# Variable to keep information about the date of execution of the script
date=$(date '+%Y-%m-%d');

# Execute a command to receive the information about certificate expiry date
numberodaysleft=$(lxc exec proxy -- certbot certificates | grep 'Expiry Date' | awk '{gsub(/(\(|\))/, ""); print $6}');

executionstatus=$#;

# Checking the execution status of the previous command
if [ $executionstatus -eq 0 ]
then
	echo "Certificate information successfully retrieved, attempting the renewal process!"
	if [ $numberodaysleft -lt 2 ]
 	then
        	echo "Starting renewal process"
		# The renewal of the ssl certificate starts by stoping the web server (Apache2)
        	$(lxc exec proxy -- systemctl stop apache2);
		# Retrieving the status of the renewal process
        	renewal=$(lxc exec proxy -- certbot renew);
		# Checking the status of the execution of the previous command execution
		if [ $# -eq 0 ]
		then
         		echo "The certificate is renewed successfully";
		else
			echo "The certificate did not renew successfully";
		fi
	else
		echo "It's early to renew the certificate ${numberofdaysleft}"
 	fi	
else
	echo "Error, the command exited with an exception"
fi

echo "******************* The process ended successfully **************";
