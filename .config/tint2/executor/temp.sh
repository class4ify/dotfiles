#!/usr/bin/env sh

# Get hardware temperature for tint2 panel.
# https://github.com/owl4ce/dotfiles

export LANG='POSIX'
exec 2>/dev/null
. "${HOME}/.joyfuld"

LINUX_THERMAL='/sys/devices/virtual/thermal'

TEMPERATURE_DEVICE="${LINUX_THERMAL}/${TEMP_DEV}"

if [ -f "${TEMPERATURE_DEVICE}/temp" ]; then
    IFS= read -r TEMP <"${TEMPERATURE_DEVICE}/temp"
    echo "$((TEMP/1000))˚C"
else
    echo "Invalid ${TEMPERATURE_DEVICE} interface!"
fi

exit ${?}
