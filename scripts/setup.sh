#!/bin/bash 

# download and unzip PIA configuration
curl -OLk https://www.privateinternetaccess.com/openvpn/openvpn.zip 
unzip -qq openvpn.zip

# some basic checks

if [ `ls *.ovpn | wc -l` -lt 20 ]; then 
	echo "Openvpn config files missing after extraction."
	exit 1 
fi

if [ `ls *.pem | wc -l` -ne 1 ]; then 
	echo "Openvpn pem file missing after extraction."
	exit 1
fi

if [ `ls *.crt | wc -l` -ne 1 ]; then 
	echo "Openvpn crt file missing after extraction."
	exit 1
fi

# change credentials, provide absolute paths

sed -i 's/\(auth-user-pass\)/\1 USER PW/g' *.ovpn
sed -i 's/\(crl[a-zA-Z0-9.]*pem\)/\/etc\/openvpn\/\1/g' *.ovpn
sed -i 's/\(ca[a-zA-Z0-9.]*crt\)/\/etc\/openvpn\/\1/g' *.ovpn

# copy openvpn config files 

for f in *.ovpn; do 
	cp -v "$f" "/etc/openvpn/${f// /_}" || exit 1
done

# copy certificate files

cp -v *.pem /etc/openvpn || exit 1
cp -v *.crt /etc/openvpn || exit 1

# basic checks again

if [ `ls /etc/openvpn/*.ovpn | wc -l` -lt 20 ]; then 
	echo "Openvpn config files missing after copy."
	exit 1 
fi

if [ `ls /etc/openvpn/*.pem | wc -l` -ne 1 ]; then 
	echo "Openvpn pem file missing after copy."
	exit 1
fi

if [ `ls /etc/openvpn/*.crt | wc -l` -ne 1 ]; then 
	echo "Openvpn crt file missing after copy."
	exit 1
fi
