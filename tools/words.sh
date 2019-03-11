#!/bin/bash

exec &>"$(dirname `readlink -e "$0"`)/words.log"
set -x

DB="$(dirname `readlink -e "$0"`)/words.db"
DB_DONE="$(dirname `readlink -e "$0"`)/done.db"
DB_QUEUE="$(dirname `readlink -e "$0"`)/queue.db"
TIMESPAN=300
INVOLVED_WORDS_N=20

function ask_word
{
    WORD="$( awk 'NR == '$1' {print $2}' "${DB}" )"
    ANSW="$( awk 'NR == '$1' {print $3}' "${DB}" )"

    [ `expr "$RANDOM" % 2` -eq 0 ] && read WORD ANSW <<<"$ANSW $WORD"
    [ "${ANSW}" == "$(kdialog --inputbox "Translate '$WORD':")" ]
}

function get_priority
{
    echo $( awk 'NR == '$1' {print $1}' "${DB}" )
}

function increase_priority
{
    local PRIORITY_N=`get_priority "$1"`
    sed -i ''$1's/'$PRIORITY_N'/'`expr $PRIORITY_N + $2`'/' "${DB}"
}

function add_from_queue
{
    cat "${DB_QUEUE}" | awk 'NR == 1' >> ${DB}
    sed -i '1d' "${DB_QUEUE}"
}

function update_conf
{
    while true ; do
        WORDS_COUNT="$( wc -l "${DB}" | awk '{print $1}' )"
        [ "$WORDS_COUNT" -ge "$INVOLVED_WORDS_N" ] && break
        add_from_queue
    done

    VALUES_SUM="$( cat "${DB}" | awk '{sum += $1} END {print sum}' )"
    sort -nr -k 1 -o "${DB}" "${DB}"
}

while true
do
    update_conf

    let "RAND = $RANDOM % $VALUES_SUM"
    [ "$RAND" -eq 0 ] && continue

    for ((N=1, PRIORITY_N=0, PRIORITY_FULL=0; N <= ${WORDS_COUNT}; N++)) ; do
        PRIORITY_N=`get_priority "$N"`
        PRIORITY_FULL=`expr $PRIORITY_FULL + $PRIORITY_N`
        [ "$RAND" -le "$PRIORITY_FULL" ] && break
    done

    ask_word "$N" && {
        increase_priority "$N" "-1"
        [ "$PRIORITY_N" -eq 1 ] && {
            awk 'NR == '$N' {print $0}' "${DB}" >> "${DB_DONE}"
            sed -i ''$N'd' "${DB}"
        }
        sleep "$TIMESPAN"
    } || increase_priority "$N" "4"
done
