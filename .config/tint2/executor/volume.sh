#!/usr/bin/env sh

# Get status or control audio-volume via `amixer`.
# https://github.com/owl4ce/dotfiles

# shellcheck disable=SC2016,SC2086,SC2166

export LANG='POSIX'
exec 2>/dev/null
. "${HOME}/.joyfuld"

[ -x "$(command -v amixer)" ] || exec echo 'Install `alsa-utils`!'

[ -z "$AUDIO_DEVICE" ] || ARGS="-D ${AUDIO_DEVICE}"

case "${1}" in
    +) exec amixer ${ARGS} sset Master "${AUDIO_VOLUME_STEPS:-5}%+" on -q
    ;;
    -) exec amixer ${ARGS} sset Master "${AUDIO_VOLUME_STEPS:-5}%-" on -q
    ;;
    0) exec amixer ${ARGS} sset Master 1+ toggle -q
    ;;
esac

AUDIO_VOLUME="$(amixer ${ARGS} sget Master)"
AUDIO_MUTED="${AUDIO_VOLUME##*\ \[on\]}"
AUDIO_VOLUME="${AUDIO_VOLUME#*\ \[}" \
AUDIO_VOLUME="${AUDIO_VOLUME%%\]\ *}"

if [ "${AUDIO_VOLUME%\%}" -eq 0 -o -n "$AUDIO_MUTED" ]; then
    [ -z "$AUDIO_MUTED" ] || MUTED='Muted'
    ICON=''
elif [ "${AUDIO_VOLUME%\%}" -lt 30 ]; then
    ICON=''
elif [ "${AUDIO_VOLUME%\%}" -lt 70 ]; then
    ICON=''
else
    ICON=''
fi

case "${1}" in
    icon) echo "${ICON:-?}"
    ;;
    per*) echo "${MUTED:-${AUDIO_VOLUME}}"
    ;;
esac

exit ${?}
