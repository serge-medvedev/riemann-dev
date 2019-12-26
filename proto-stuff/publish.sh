#!/bin/bash

set -e

MSG_BIN=msg.bin
PAYLOAD=payload

protoc --encode=Msg proto.proto< msg > $MSG_BIN

PAYLOAD=$(cat $MSG_BIN | base64)
DATA=$(printf '{"properties":{},"routing_key":"","payload":"%s","payload_encoding":"base64"}' $PAYLOAD)

rm $MSG_BIN

curl -u guest:guest -XPOST -H "Content-Type: application/json" http://127.0.0.1:15672/api/exchanges/%2F/riemann/publish -d "$DATA"
