#!/bin/bash

exec &>/dev/null
set -x

DB="$(dirname `readlink -e "$0"`)/words.db"
TIMESPAN=300
WORDS_COUNT="$( wc -l "${DB}" | awk '{print $1}' )"
RANGE=15
APSUM=120 #"$(bc <<< " ((2 + ${RANGE} - 1) / 2) * ${RANGE}")"

while true ; do
   
    let "RAND = $RANDOM % $APSUM"
    [ "$RAND" -eq 0 ] && continue
   
    for ((n=2, an=${APSUM}; n <= ${RANGE}; n++)) ; do
        an=`expr $an - ${RANGE} + $n - 2` && [ "${RAND}" -gt "${an}" ] && {
            N=$n
            break
        }
    done

    WORD="$( awk 'NR == '${N}' {print $1}' "${DB}" )"
    ANSW="$( awk 'NR == '${N}' {print $2}' "${DB}" )"

    [ `expr "$RANDOM" % 2` -eq 0 ] && read WORD ANSW <<<"$ANSW $WORD"

    [ "${ANSW}" == "$(kdialog --inputbox "Translate '$WORD':")" ] && { 
        sed -i ''${N}'h;'${N}'d;'`expr $N + 1`'G' "${DB}" 
        sleep ${TIMESPAN}
    }
       
done
