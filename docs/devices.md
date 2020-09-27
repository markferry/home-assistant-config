# Objectives:
 * avoid restarting the zwave network
   - no names in zwcfg

 * map names
   - wipe out entity registry each time

 * devices can be swapped out easily

 * influx data should not be disrupted
   - should be gathering logical data (washing machine, not greenwave 53)
   - will have to migrate data which was using device names

 * UI should never be used to rename devices.
   - delete 

# Mapping Device names to Logical names

Implies renaming in yaml is reasonable.
Yaml names should be reasonably generic
 -> `bedroom_main2`
 -> `hot tub`

Four levels:
 * zwave IDs
 * zwave device names -> `device_registry`
 * entity names -> delete each time
 * friendly names -> lovelace

Can we map zwave device to logical device in device registry?
e.g.
zwave id: 53
device name: `greenwave_powernode_53`
friendly name: hottub

## Limitations
Some device-specific behaviours still leak out.
e.g. spiritz vs stellaz thermostat entities


## HA zwave
Assume the HA core can be restarted quickly.
Use `core.device_registry`.
Clear `core.entity_registry` before each use?


## zwave2mqtt
Naming convention: `<mqtt_prefix>/<?node_location>/<node_id>/<class_id>/<instance>/<index>`

Has no renaming functionality.

Mapped in HA using mqtt platform.

If discovery is enabled devices are renamed in `device_registry`.
With discovery disabled can create static devices.


## ozwdaemon (HA beta)

Also using the `device_registry`?


# Names

When unused have `<device>_<id>` format

```
1: ZStick Gen 5
2: annex_heating_relay
3: annex_heating_thermostat
4: ? - (was study door)
5: ? Yale smart lock (not in nodes list)  FIXME!
6: front_door_contact (#63)
7: greenwave_powernode_7 (my desk)
8: bedroom_main2_east (SpiritZ)
9: study_door_contact (#65)
10: study_east (#14)
11: stellaz_11 (#43)
12: main_heating_relay
13: ? Thermostat?
14: ? Thermostat?
15: lounge_east (#55)  FIXME!
16: library_east (#25)
17: ballroom_east (#33)
18: hall_east (#24)
19: hall_west (#13)
20: bedroom_mark_south (#29)
21: bedroom_mark_north (#44)
22: guest_room_north (#69)
23: kitchen_west (#34)
24: greenwave_powernode_24 (#62) - Outside Kitchen
25: greenwave_powernode_25 (#64) - Outside ballroom
26: hottub_powernode (#53)
27: washing_machine_powernode (#54)
28: gin_fridge_contact heiman_contact_28 Gin Fridge Door (#66)
29: aeotec_dsb05_multisensor (#3)
30: aeotec_zw100_multisensor
31: bedroom_main3_east (SpiritZ)
32: main_heating_thermostat (#35)
33: bedroom_mark_overhead (#39)
??: Postbox contact
```

