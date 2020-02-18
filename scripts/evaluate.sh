#!/bin/bash

KEPTN_ENDPOINT=
KEPTN_API_TOKEN=
KEPTN_PROJECT=sockshop
KEPTN_STAGE=preprod
KEPTN_SERVICE=carts

json=$(curl -X POST "$KEPTN_ENDPOINT/v1/event" -H "accept: application/json" -H "x-token: $KEPTN_API_TOKEN" -H "Content-Type: application/json" -d "{ \"data\": { \"end\": \"2020-02-18T19:00:00.000Z\", \"project\": \"$KEPTN_PROJECT\", \"service\": \"$KEPTN_SERVICE\", \"stage\": \"$KEPTN_STAGE\", \"start\": \"2020-02-18T18:55:00.000Z\", \"teststrategy\": \"manual\" }, \"type\": \"sh.keptn.event.start-evaluation\"}" --insecure)
context=$(echo $json | jq -r '.keptnContext')

echo $context

sleep 5

curl -X GET "$KEPTN_ENDPOINT/v1/event?keptnContext=$context&type=sh.keptn.events.evaluation-done" -H "accept: application/json" -H "x-token: $KEPTN_API_TOKEN" --insecure
