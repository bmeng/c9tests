#!/bin/bash

# Check the first and last 20 apps to be sure they are reachable.

source /etc/openshift/node.conf

DIY="${CARTRIDGE_BASE_PATH}/diy-0.1/info/hooks"

RC="runcon -u unconfined_u -r system_r -t openshift_initrc_t -l s0-s0:c0.c1023"

( grep ":${GEAR_GECOS}:" /etc/passwd | tail -20 | cut -f 1 -d : ; \
    grep ":${GEAR_GECOS}:" /etc/passwd | head -20 | cut -f 1 -d :  ) | \
    while read uuid
do
    ( 
        echo "Trying: $uuid"
        for f in ${GEAR_BASE_DIR}/${uuid}/.env/*
        do
            source $f
        done
        OPENSHIFT_APP_DOMAIN=`echo $OPENSHIFT_APP_DNS | cut -f 1 -d . | cut -f 2 -d -`
        $RC ${DIY}/start  "$OPENSHIFT_GEAR_NAME" "$OPENSHIFT_APP_DOMAIN" "$uuid"
        sleep 1
        curl -s -f -H "Host: ${OPENSHIFT_GEAR_DNS}" http://localhost/ &>/dev/null
        if [ $? -ne 0 ]
        then
            echo "FAILED: $uuid"
        else
            echo "PASSED: $uuid" 
        fi
        $RC ${DIY}/stop  "$OPENSHIFT_GEAR_NAME" "$OPENSHIFT_APP_DOMAIN" "$uuid"
    )
done
