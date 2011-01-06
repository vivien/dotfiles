#!/bin/bash

if [ ! $UID -eq 0 ]; then
    echo "You must be root."
    exit
fi

USER=
PASSWORD=
IF=wlan0

    URL=https://securelogin.arubanetworks.com/auth/index.html/u

    while getopts "u:p:i:" OPT ; do
        case $OPT in
            u) USER=$OPTARG ;;
        p) PASSWORD=$OPTARG ;;
    i) IF=$OPTARG ;;
esac
done

if [ -z $IF ] ; then
    echo -n "interface: "
    read IF
fi

if [ -z $USER ] ; then
    echo -n "user: "
    read USER
fi

if [ -z $PASSWORD ] ; then
    echo -n "$USER's password: "
    read -s PASSWORD
    echo
fi

# activate wifi
ifconfig $IF | grep UP > /dev/null
if [ $? -eq 1 ] ; then
    echo "activating wifi interface..."
    ifconfig $IF up
    sleep 1
else
    echo "$IF already activated."
fi

# scan UNIVMED
iwlist $IF scan | grep UNIVMED > /dev/null
if [ $? -eq 1 ] ; then
    echo "UNIVMED is not available."
    exit
else
    echo "UNIVMED available."
fi

#TODO bug si connecter a un autre reseau
# connect to UNIVMED
iwconfig $IF | grep UNIVMED > /dev/null
if [ $? -eq 1 ] ; then
    echo "connecting to UNIVMED..."
    iwconfig $IF essid UNIVMED
    sleep 2
else
    echo "already connected to UNIVMED."
fi

# get an ip from UNIVMED
echo "getting an ip from UNIVMED..."
if [ -z `which dhcpcd 2>/dev/null` ] ; then
    dhclient $IF
    if [ ! $? -eq 0 ] ; then
        echo "cannot get an IP."
        exit
    fi
else
    dhcpcd $IF #> /dev/null
    #TODO test for error
fi

#TODO test connection (ping doesn't work under UNIVMED)

# authenticate to UNIVMED
echo "logging to UNIVMED..."
curl -d "user=$USER" -d "password=$PASSWORD" -d "fqdn=u2" $URL &> /dev/null
case $? in
    0) echo "OK." ;;
6) echo "resolution problem" ;;
    *) echo "Authentication error." ;;
esac

exit
