#!/bin/sh
while ((1))
do
    for i in lounge_east kitchen bedroom_mark_north guest_room
    do
        dev-scripts/pub-temp.sh $i $((10 + RANDOM % 20))
    done
    sleep 3 ;
done
