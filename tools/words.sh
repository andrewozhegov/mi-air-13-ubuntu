#!/bin/bash

exec &>/dev/null
set -x

DB="$(dirname `readlink -e "$0"`)/words.db"
DB_DONE="$(dirname `readlink -e "$0"`)/done.db"
TIMESPAN=5

function update_conf
{
    WORDS_COUNT="$( wc -l "${DB}" | awk '{print $1}' )"
    VALUES_SUM="$( cat "${DB}" | awk '{sum += $1} END {print sum}' )"
    sort -nr -k 1 -o "${DB}" "${DB}"
}

function ask_word
{
    WORD="$( awk 'NR == '$1' {print $2}' "${DB}" )"
    ANSW="$( awk 'NR == '$1' {print $3}' "${DB}" )"

    [ `expr "$RANDOM" % 2` -eq 0 ] && read WORD ANSW <<<"$ANSW $WORD"
    [ "${ANSW}" == "$(kdialog --inputbox "Translate '$WORD':")" ]
}

while true
do
    update_conf

    let "RAND = $RANDOM % $VALUES_SUM"
    [ "$RAND" -eq 0 ] && continue

    for ((N=1, PRIORITY_N=0, PRIORITY_FULL=0; N <= ${WORDS_COUNT}; N++)) ; do
        PRIORITY_N="$( awk 'NR == '${N}' {print $1}' "${DB}" )"
        PRIORITY_FULL=`expr $PRIORITY_FULL + $PRIORITY_N`
        [ "$RAND" -le "$PRIORITY_FULL" ] && break
    done

    ask_word "$N" && {
        sed -i ''$N's/'$PRIORITY_N'/'`expr $PRIORITY_N - 1`'/' "${DB}"
        [ "$PRIORITY_N" -eq 1 ] && {
            awk 'NR == '$N' {print $0}' "${DB}" >> "${DB_DONE}"
            sed -i ''$N'd' "${DB}"
        }
        sleep "$TIMESPAN"
    } || sed -i ''$N's/'$PRIORITY_N'/'`expr $PRIORITY_N + 4`'/' "${DB}"
done
