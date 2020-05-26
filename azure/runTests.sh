#!/bin/bash

echo 'Save start time'
starttime=$(date +%FT%T+00:00)
echo "##vso[task.setvariable variable=starttime;isOutput=true;]$starttime"
echo $starttime

cartsUrl=$SERVICE_URL
numofreqs=$NUM_OF_REQUESTS
echo "Hit the service with $numofreqs requests"
curl --silent --output /dev/null "$cartsUrl/carts/[1-$numofreqs]/items"

echo 'Tests finished'
echo 'Save end time'
endtime=$(date +%FT%T+00:00)
echo "##vso[task.setvariable variable=endtime;isOutput=true;]$endtime"
