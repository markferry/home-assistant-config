# Room Mode

 - Allows the user to select from a small set of modes
 - Each mode sets thermostat setpoints and lights
 - Provides an Off setting for minimal energy consumption
 - Reverts to Manual mode when room devices are customized
 - Each room has an independent set of modes
 - Provides a settings screen for selecting per-mode climate defaults
 - Hides the settings screen by default

## Modes

Typically at least
 - Off
 - Cosy
 - Bright
 - Manual

## Components

 1. `input_select.room_mode`
 1. `input_number.room_temperature_mode`
   * per-room, per-mode setting
 1. `sensor(template).room_setpoint`
   * breaks setpoint out of `climate.room_thermostat`
 1. `automation.room_mode`
 1. `automation.room_revert_to_manual`
 1. `script.set_mode` (generic)


## Interaction

### Mode selection

 1. The user selects a mode and the `room_mode` automation triggers calling the generic `set_mode` script
   * args are room name and new state
 1. The `set_mode` script:
   1. Disables the `revert_to_manual` automation for the room
   1. Sets the room scene
   1. Sets the room thermostat to the value of `input_number.room_temperature_mode`
   1. Reenables the `revert_to_manual` automation

### Mode customization

 1. The user changes the state of a room component triggering the `revert_to_manual` automation
 1. The `revert_to_manual` automation selects `input_select.room_manual`
 1. `input_select.room_manual` triggers the `room_mode` automation which triggers the `set_mode` script
 1. The `set_mode` script behaves as above setting room scenes and temperatures to manual if those settings exist.


