#!/bin/sh
#
# Set ozwdaemon polling intensity for Eurotronic StellaZ ZWave TRVs
#
# Usage: ./stellaz-poll.sh [NODE_ID]...
#
# Environment vars:
#   PRETEND
#   MQTT_SERVER
#
# Formatting:
#   shfmt -i 4 -bn
#
set -e

#MY_NODE_IDS="10 11 15 16 17 18 19 20 21 23"
#value_ids=(
#    ["10"]="281475149479954"
#    ["11"]="281475166257170"
#    ["15"]="281475233366034"
#    ["16"]="281475250143250"
#    ["17"]="281475266920466"
#    ["18"]="281475283697682"
#    ["19"]="281475300474898"
#    ["20"]="281475317252114"
#    ["21"]="281475334029330"
#    ["23"]="281475367583762"
#)

PRETEND=${PRETEND:+echo}

MQTT_SERVER=${MQTT_SERVER:-localhost}
MQTT_TIMEOUT=5

# StellaZ multilevel sensor for air temperature
AIR_TEMPERATURE_CLASS=49

# intensity 10 ~= 1 minute
# wakeup is 480s ~ 8min so poll every 7mins
INTENSITY=70

get_value_id() {
    node_id=$1
    mosquitto_sub -W $MQTT_TIMEOUT -C 1 -h $MQTT_SERVER -t "OpenZWave/1/node/$node_id/instance/1/commandclass/$AIR_TEMPERATURE_CLASS/value/#" \
        | python -c "import sys,json; j = json.load(sys.stdin); print(j['ValueIDKey'])"
}

enable_polling() {
    value_id=$1
    payload='{"ValueIDKey": '$value_id', "Intensity": '$INTENSITY'}'
    ${PRETEND} mosquitto_pub -h $MQTT_SERVER -t "OpenZWave/1/command/enablepoll/" -m "$payload"
}

for node_id in $@; do # $MY_NODE_IDS
    value_id=$(get_value_id $node_id)
    enable_polling $value_id
done
