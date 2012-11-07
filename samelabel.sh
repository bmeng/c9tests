#!/bin/bash

# The app-root directory in each gear must have a unique SELINUX label.

source /etc/openshift/node.conf

declare -A labels
declare -A addrs

grep ":${GEAR_GECOS}:" /etc/passwd | cut -f 6 -d : | \
    while read hd
do
    addr=$(cat "${hd}/.env/OPENSHIFT_INTERNAL_IP")
    if [ "${addrs[$addr]}" ]
    then
        echo "DUPLICATE ADDR: ${addrs[$addr]} $hd"
    else
        addrs["$addr"]="$hd"
    fi

    label=$(getfattr --only-values --absolute-names -n security.selinux "${hd}/app-root")
    if [ "${labels[$label]}" ]
    then
        echo "DUPLICATE LABEL: ${labels[$label]} $hd"
    else
        labels["$label"]="$hd"
    fi

done

