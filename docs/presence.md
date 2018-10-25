# Presence with modes and bayesian sensors

# User states
  - home
  - leaving
  - away
  - extended_away
  - arriving
  - just_arrived

States shouldn't be flickery to avoid triggering automations
  home --> leaving --> away -----------------> arriving --> just_arrived --> home
                           \--> extended_away ---^

Away: 
 - Bedroom Off

Extended away:
 - Bedroom Holiday
 - disable calendar automations




