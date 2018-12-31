#!/bin/sh

#
# Publish mqtt test values for testing heating-on-demand
#  includes the json timestamp to trigger updates, even when the temperature
#  value doesn't change.
#

#mosquitto_pub -h localhost -t ha/mock/$1/temperature/state -m "{\"temperature\": $2, \"ts\": $(date +%s)}"
#mosquitto_pub -h localhost -t ha/mock/$1/temperature/state -m $2
mosquitto_pub -h localhost -t ha/raw/sensor.$1_temperature/state -m $2

