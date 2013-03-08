#!/bin/bash

source /etc/openshift/node.conf

NAME="myapp"
NAMESPACE="mydomain"
UUID="cbc0e3a95a90adf633aacf1a212e37d8"
CART="diy-0.1"

echo "127.0.0.1 ${NAME}-${NAMESPACE}.${CLOUD_DOMAIN}" >> /etc/hosts

set -x

/usr/bin/runcon 'unconfined_u:system_r:openshift_initrc_t:s0-s0:c0.c1023' \
    oo-app-create \
    --with-app-uuid "$UUID" \
    --with-container-uuid "$UUID" \
    --with-app-name "$NAME" \
    --with-namespace "$NAMESPACE" \
    --with-container-name "$NAME" \
    --with-uid 16000

/usr/bin/runcon 'unconfined_u:system_r:openshift_initrc_t:s0-s0:c0.c1023' \
    ${CARTRIDGE_BASE_PATH}/${CART}/info/hooks/configure "${NAME}" "${NAMESPACE}" "${UUID}"

