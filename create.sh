#!/bin/bash

STARTGEARS=1
MAXGEARS=15500

if [ "$1" ]; then
    if [ "$1" -le 0 ]; then
        STARTGEARS="$1"
    fi
fi

DIY="/usr/libexec/openshift/cartridges/diy-0.1/info/hooks"

RC="runcon -u unconfined_u -r system_r -t openshift_initrc_t -l s0-s0:c0.c1023"

i="$STARTGEARS"
while [ $i -lt $MAXGEARS ]
do
    name="c${i}"
    domain="$name"
    uuid=`echo "${name}-${domain}" | md5sum - | awk '{ print $1 }'`
    
    (
        [ -e /var/lib/openshift/$uuid ] && exit

        $RC oo-app-create -a "$uuid" -c "$uuid" \
            --with-app-name "$name" \
            --with-namespace "$domain" \
            --with-container-name "$name"
        
        $RC ${DIY}/configure "$name" "$domain" "$uuid"
        
        $RC ${DIY}/stop "$name" "$domain" "$uuid"
    ) &

    m=$(( $i % 50 ))
    if [ $m -eq 0 ]
    then
        wait
        [ -e STOP ] && exit
    fi

    i=$(( $i + 1 ))
done
wait

sleep 10
service httpd stop
sleep 5
pkill -u apache
rm -f /var/log/httpd/*
while ! ( service httpd start )
do
    sleep 5
    pkill -u apache
done
