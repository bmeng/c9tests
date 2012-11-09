#!/bin/bash


source /etc/openshift/node.conf
MAXUID=16000

RC="runcon -u unconfined_u -r system_r -t openshift_initrc_t -l s0-s0:c0.c1023"

grep ":${GEAR_GECOS}:" /etc/passwd | cut -f 1,3 -d : | tr : ' ' | \
    while read uuid uid
do
    [ $uid -le $MAXUID ] && continue

    (
        source "${GEAR_BASE_DIR}/${uuid}/.env/OPENSHIFT_APP_NAME"
        source "${GEAR_BASE_DIR}/${uuid}/.env/OPENSHIFT_GEAR_NAME"
        source "${GEAR_BASE_DIR}/${uuid}/.env/OPENSHIFT_APP_DNS"
        OPENSHIFT_APP_DOMAIN=`echo $OPENSHIFT_APP_DNS | cut -f 1 -d . | cut -f 2 -d -`
        echo "Destroying: $uid $uuid"
        $RC oo-app-destroy -a "$uuid" -c "$uuid" \
            --with-app-name "$OPENSHIFT_APP_NAME" \
            --with-namespace "$OPENSHIFT_APP_DOMAIN" \
            --with-container-name "$OPENSHIFT_GEAR_NAME"
    )
done

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
