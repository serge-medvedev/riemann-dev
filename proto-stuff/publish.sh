#!/bin/bash

set -e

MSG_BIN=msg.bin
PAYLOAD=payload

protoc --encode=Msg proto.proto< msg > $MSG_BIN

PAYLOAD=$(cat $MSG_BIN | base64 -w 0)
ROUTING_KEY=${1:-""}
DATA=$(printf '{"properties":{"reply_to":"queries"},"routing_key":"%s","payload":"%s","payload_encoding":"base64"}' $ROUTING_KEY $PAYLOAD)

rm $MSG_BIN

curl -u guest:guest -XPOST -H "Content-Type: application/json" http://127.0.0.1:15672/api/exchanges/%2F/riemann/publish -d "$DATA"

