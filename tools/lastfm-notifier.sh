#!/bin/bash

usage()
{
cat <<EOF
Usage: $0 <args>

Arguments:
    -u, --user         lastfm username
    -s, --scrobbles    scrobbles count to send notification (50000 as default)
    -m, --mp3          specify mp3 file as notification (~/Documents/notify.mp3 as default)
EOF
}

USER="andrewozhegov"
SCROBBLES="50000"
MP3="$HOME/Documents/notify.mp3"

for arg in "$@" ; do
    case $arg in
        -h|--help)      usage; exit 0 ;;
        -u|--user)      shift; USER="$1"; shift ;;
        -s|--scrobbles) shift; SCROBBLES="$1"; shift ;;
        -m|--mp3)       shift; MP3="$1"; shift ;;
    esac
done

for pkg in mpg123 libnotify-bin curl ; do
    dpkg -s $pkg &>/dev/null ||
    echo "Package '$pkg' is required, but not found!"
done

while true
do
    current_count="$(
        curl -sb -H "Accept: application/json" https://www.last.fm/user/$USER | \
        grep -Po '(?<=<a href="/user/'$USER'/library">)(.*)(?=</a></p>)' | \
        sed 's/,//'
    )"

    [ -z "${current_count}" ] && continue

    echo "Scrobbles: ${current_count}"

    if [ "$current_count" -ne "${old_value:-0}" ]; then 
        notify-send "Scrobbles: ${current_count}"
        old_value=$current_scrobbles_count
    fi

    [ "${current_count}" -ge "$SCROBBLES" ] && mpg123 "$MP3"

    sleep 60
done
