#!/bin/bash

echo 'Evaluate tests'

echo 'start ' $starttime $STARTTIME
echo 'end' $(endtime)

echo 'Start Keptn quality gate'
echo 'calling out to ' $KEPTN_ENDPOINT

### START THE EVALUTION
json=$(curl -X POST "$KEPTN_ENDPOINT/v1/event" -H "accept: application/json" -H "x-token: $KEPTN_API_TOKEN" -H "Content-Type: application/json" -d "{ \"data\": { \"end\": \"$endtime\", \"project\": \"$KEPTN_PROJECT\", \"service\": \"$KEPTN_SERVICE\", \"stage\": \"$KEPTN_STAGE\", \"start\": \"$starttime\", \"teststrategy\": \"manual\" }, \"type\": \"sh.keptn.event.start-evaluation\", \"source\": \"devops-integration\"}" --insecure)
context=$(echo $json | jq -r '.keptnContext')


echo $context

# EVALUATE THE QUALITY GATE
result=$(curl -X GET "$KEPTN_ENDPOINT/v1/event?keptnContext=$context&type=sh.keptn.events.evaluation-done" -H "accept: application/json" -H "x-token: $KEPTN_API_TOKEN" --insecure)
httpcode=$(echo $result | jq -r '.code')

### WAIT FOR THE QUALITY GATE TO RETURN WITH A RESULT
while [ $httpcode -eq 500 ]
do
  echo "return code is 500, sleeping for 30 seconds"
  sleep 30
  result=$(curl -X GET "$KEPTN_ENDPOINT/v1/event?keptnContext=$context&type=sh.keptn.events.evaluation-done" -H "accept: application/json" -H "x-token: $KEPTN_API_TOKEN" --insecure)
  httpcode=$(echo $result | jq -r '.code')
done

echo $result

### ECHO THE RESULT
decision=$(echo $result | jq -r '.data.evaluationdetails.result')
echo $decision

echo 'Evaluation done'

