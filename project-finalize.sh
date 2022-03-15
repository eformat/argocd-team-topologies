#!/bin/bash
if [ -z "$1" ]; then
  echo "pass a namespace" && exit 1
fi
APIURL=$(oc whoami --show-server)
NAMESPACE=${1}
oc get namespace $NAMESPACE -o json |jq '.spec = {"finalizers":[]}' >/tmp/$NAMESPACE.json
curl -k -H "Authorization: Bearer $(oc whoami -t)" -H "Content-Type: application/json" -X PUT --data-binary @/tmp/$NAMESPACE.json "$APIURL/api/v1/namespaces/$NAMESPACE/finalize"

