#!/bin/bash

source /etc/openshift/node.conf

NAME="myapp"
NAMESPACE="mydomain"
UUID="cbc0e3a95a90adf633aacf1a212e37d8"
CART="diy-0.1"

set -x


/usr/bin/runcon 'unconfined_u:system_r:openshift_initrc_t:s0-s0:c0.c1023' \
    oo-app-destroy \
    --with-app-uuid "$UUID" \
    --with-container-uuid "$UUID" \
    --with-app-name "$NAME" \
    --with-namespace "$NAMESPACE" \
    --with-container-name "$NAME"

