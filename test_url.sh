#!/bin/bash
#
# Usage:
#    $0 <repeat> <url>
#
#    $0 - Обращаемся к странице <repeat> раз и выводим грубую статистику по успешности обращений.
#         Используем эту команду, чтоб протестировать, доехала ли страница до всех серверов за балансером.
#
#    repeat     - число обращений к странице
#    url        - ссылка на страницу
#

REPEAT=$1
URL=$2

NO_COLOUR="\033[0;0;39m"
BLINK_RED="\033[5;1;31m"
BLUE="\033[34m"
LIGHT_RED="\033[91m"
LIGHT_GREEN="\033[92m"

COLOURS=()
COLOURS[2]=$LIGHT_GREEN
COLOURS[3]=$BLUE
COLOURS[4]=$LIGHT_RED
COLOURS[5]=$BLINK_RED

CODES=()

i=$REPEAT
while [ $(( i -=1 )) -ge "0" ]; do
    for codes in `curl -k -s -L -I $URL | grep HTTP | sed 's/HTTP\/.* \([0-9][0-9][0-9]\) .*/\1/'`; do
        for code in $codes; do
            let "CODES[$(echo $code | head -c 1)]++"
            echo -ne ${COLOURS[$(echo $code | head -c 1)]}
            echo -n "+"
            echo -ne $NO_COLOUR
        done
    done
done
echo

for code in 1 2 3 4 5; do
    if [ "x${CODES[$code]}" != "x" ]; then
        let "percentage = ${CODES[$code]} / $REPEAT * 100"
        echo -n "CODE $code"
        echo -e "0x - ${COLOURS[$code]}${CODES[$code]} ($percentage%)$NO_COLOUR"
    fi
done
