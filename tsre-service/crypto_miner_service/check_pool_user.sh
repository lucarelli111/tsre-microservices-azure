#!/bin/bash

while true; do
    docker exec tsre-shippingservice-1 echo $POOL_USER
    sleep 1800  # 30 minutes = 1800 seconds
done 