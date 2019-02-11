#!/usr/bin/env bash
#
# This is a small script that install/updates the game

# Exit when the first command fails
set -e

update_file=/home/steam/last-sandstorm-update

# Avoid updating it when it has been updated on the last 24 hours
if [[ $(( $(date +%s) - $(cat "$update_file") )) -le 86400 ]]; then
  echo "Already updated in the last 24 hours. Skipping..."
  exit 0
fi

# Do the steam update
/home/steam/steamcmd/steamcmd.sh \
  +login anonymous +force_install_dir /srv/sandstorm +app_update 581330 validate +quit

# Write the timestamp of the last update
date +%s > "$update_file"
