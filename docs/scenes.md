# Scenes and Modes

  - Off
  - Manual

# Actions
  - On any change to scene 


# To Do

  - Aliases for warm and cosy

1. Party night, user overrides lights
  Set Party at night => lights on low
  User turns lights off => reverts to manual

1. Party night, user overrides heating
  Set Party at night => lights on low
  User sets thermostat => reverts to manual.
  Shouldn't revert to manual.
   -> should set thermostat mode to manual.
      Do generic thermostats have manual mode?
  Should we store user intent for lights and thermostat separately?
  Keep memory of user setting?

  For each mood, thermostat input_slider
  Generic thermostat updates input slider for current mode.
  input_select sets generic thermostat from input_slider value.

  Too much state to be useful?

  Reset mode setpoints at 3am?

  ! Setting thermostat and mode at nearly the same time will set the wrong thermostat
  ! Have a holdoff time for thermostat set?
    * Updates the generic_thermostat immediately
    * Delays the mode setpoint slider





1. input_select.room_mode
  Sets the mode
  Updates lights, appliances, etc
  Triggers reevaluation of lights, appliances, etc

2. Decide which light script to trigger based on time of day.
  Reactive.
  trigger input_select
  sun below horizon as condition?
  Also sun:

  lights
  if is_state("input_select.room_mode") %}


Can scripts have conditions?
  Probably not.

Can scripts have templates?


# Use Cases

## Ballroom
Seems each mode needs its own logic?

How to retain user intent despite automations?

Only UI state changes should set manual mode.

1. Set Party during the day.
  Lights are off, lights turn on before sunset, lights turn off again at dawn.

  trigger:: sun
    below horizon - 30
    {% if is_state(input_select.room_mode, "Off") %}
      scene.room_lights_off
    {%-else is_state(input_select.room_mode, "Party") %}
      scene.room_lights_party
    #{%-elif is_state(input_select.room_mode, "Movie") %}
    #  scene.room_lights_movie
    {%-elif is_state(input_select.room_mode, "Bright") %}
      scene.room_lights_bright
    {% else %}
      None
    {% endif %}

  trigger:: sun
    below_horizon for 30:
      lights_{{mood}}
    above_horizon for 30:

  off -> party [lights=off] -> off []
  party -> sunset [lights=on] -> sunrise [lights=off]
  off -> sunset [] ->  party []



   Off  <----+
    ^        |
    |        |
    v        |
  Party -> Sunset -> Sunrise
             V

