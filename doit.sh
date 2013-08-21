#!/bin/bash

for i in {1..40}
do
    echo "Create: $i"
    ./create.sh
    sleep 60
    echo "Restart: $i"
    ./restart.sh
    sleep 60
done

echo "Deleting them all"
./delete.sh
