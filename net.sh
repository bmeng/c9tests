#!/bin/bash

source /etc/openshift/node.conf

last_uuid=$( grep ":${GEAR_GECOS}:" /etc/passwd | cut -f 1 -d : | tail -1 )
last_uid=$( grep ":${GEAR_GECOS}:" /etc/passwd | cut -f 3 -d : | tail -1 )

grep ":${GEAR_GECOS}:" /etc/passwd | cut -f 1,3 -d : | tr : ' ' | \
    while read uuid uid
do
    (
        source  ${GEAR_BASE_DIR}/${uuid}/.env/OPENSHIFT_INTERNAL_IP
        
        mcs=`oo-get-mcs-level $uid`
        last_mcs=`oo-get-mcs-level $last_uid`
        
        # Test 1: Can bind to the right address
        runuser --shell /bin/bash "$uuid" -c "runcon -u system_u -r system_r -t openshift_t -l $mcs nc -l $OPENSHIFT_INTERNAL_IP 8080 </dev/null &>/dev/null &"
        sleep 1
        nc $OPENSHIFT_INTERNAL_IP 8080 </dev/null &>/dev/null
        [ $? -eq 0 ] || echo "ERROR: Cannot bind to the right address: $uuid"
        
        # Test 2: Can't bind to the wrong address
        runuser --shell /bin/bash "$last_uuid" -c "runcon -u system_u -r system_r -t openshift_t -l $last_mcs nc -l $OPENSHIFT_INTERNAL_IP 8080 </dev/null &>/dev/null &"
        sleep 1
        nc $OPENSHIFT_INTERNAL_IP 8080 </dev/null &>/dev/null
        [ $? -eq 0 ] && echo "ERROR: Can bind to the wrong address: $uuid"
        
        # Test 3: Can connect to the right address
        nc -l $OPENSHIFT_INTERNAL_IP 8080 </dev/null &>/dev/null &
        sleep 1
        runuser --shell /bin/bash "$uuid" -c "runcon -u system_u -r system_r -t openshift_t -l $mcs nc $OPENSHIFT_INTERNAL_IP 8080 </dev/null &>/dev/null"
        [ $? -eq 0 ] || echo "ERROR: Cannot connect to the right address: $uuid"
        nc $OPENSHIFT_INTERNAL_IP 8080 </dev/null &>/dev/null
        
        # Test 4: Cannot connect to the wrong address
        nc -l $OPENSHIFT_INTERNAL_IP 8080 </dev/null &>/dev/null &
        sleep 1
        runuser --shell /bin/bash "$last_uuid" -c "runcon -u system_u -r system_r -t openshift_t -l $last_mcs nc $OPENSHIFT_INTERNAL_IP 8080 </dev/null &>/dev/null"
        [ $? -eq 0 ] && echo "ERROR: Can connect to the wrong address: $uuid"
        nc $OPENSHIFT_INTERNAL_IP 8080 </dev/null &>/dev/null

        # Test 5: polydir works
        runuser --shell /bin/bash "$uuid" -c "runcon -u system_u -r system_r -t openshift_t -l $mcs touch /tmp/$uuid"
        runuser --shell /bin/bash "$uuid" -c "runcon -u system_u -r system_r -t openshift_t -l $mcs test -e /tmp/$uuid"
        [ $? -eq 0 ] || echo "ERROR: Something weird happened with polydir: $uuid"

        # Test 5: polydir is isolated
        runuser --shell /bin/bash "$uuid" -c "runcon -u system_u -r system_r -t openshift_t -l $mcs touch /tmp/$uuid"
        runuser --shell /bin/bash "$last_uuid" -c "runcon -u system_u -r system_r -t openshift_t -l $last_mcs test -e /tmp/$uuid"
        [ $? -eq 0 ] && echo "ERROR: Polydir is not isolated: $uuid"

        # Test 6: cgroups
        [ -e /cgroup/all/openshift/"$uuid" ] || echo "ERROR: No cgroups for: $uuid"

    )
    [ -e STOP ] && exit

    last_uuid="$uuid"
    last_uid="$uid"
done
