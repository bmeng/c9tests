#!/bin/bash

# This is a stunt; try to start all 15k gears.

source /etc/openshift/node.conf

DIY="${CARTRIDGE_BASE_PATH}/diy-0.1/info/hooks"

RC="runcon -u unconfined_u -r system_r -t openshift_initrc_t -l s0-s0:c0.c1023"

grep ":${GEAR_GECOS}:" /etc/passwd  |  cut -f 1,3 -d : | tr : ' ' | \
    while read uuid uid
do
    ( 
        echo "Trying: $uuid"
        for f in ${GEAR_BASE_DIR}/${uuid}/.env/*
        do
            source $f
        done
        OPENSHIFT_APP_DOMAIN=`echo $OPENSHIFT_APP_DNS | cut -f 1 -d . | cut -f 2 -d -`
        $RC ${DIY}/start  "$OPENSHIFT_GEAR_NAME" "$OPENSHIFT_APP_DOMAIN" "$uuid"
    ) &

    [ $(( $uid % 10 )) -eq 0 ] && wait
done
wait
