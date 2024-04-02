#!/bin/sh

# WAN's power settings are enforced using MDM, and can't be overridden
# in System Settings. This script overrides the power settings as follows:
# - Put the system to sleep after 15 minutes when on charger (from 180 mins)
# - Put the display to sleep after 1 minute when on charger (from 180 mins)

# M1 macs are fine with a 3 hour timeout, but there's no reason to defer
# the lock screen for three whole hours. Not when Touch ID is available.

# This script probably requires sudo to run.

# put the system to sleep after 15 minute(s) when on charger (-c)
pmset -c sleep 15

# put the display to sleep after 1 minute(s) when on charger (-c)
pmset -c displaysleep 1

