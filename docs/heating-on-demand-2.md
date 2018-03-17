# Setpoints

 - `n` real thermostats per room
 - 1 `group.g_room_thermostat([all real_thermostats])`
 - 1 `climate.room_thermostat` generic thermostat per room for UI
 - 1 setpoint automation: `climate.room_thermostat(setpoint) -> group.g_room_thermostat(setpoint)`
   - templated to make `room` generic, used by all heating-on-demand-2 packages
 - 1 `switch.room_demand` per room mqtt switch
   - part of the boiler demand group


# Temperatures

 - `n` real temperature sensors per room
 - optional: `n` sensors for temperature filtering: `sensor(platform=mqtt, expire_after=1800).{n}_current_temperature`
   - `expire_after` setting filters out old temperature readings
 - 1 `sensor(platform=min_max, type=max).room_temperature` per room
 - automation: for real temperature `sensors -> input_number`
 - `sensor.statistics(mean, input_number, number of temp sensors)` per room to even out flickering

