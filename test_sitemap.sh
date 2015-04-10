#!/bin/bash
#
# Usage:
#    $0 [schema://]<domain> <file1> [file2 ...]
#
#    $0 - выполняет обход сайта по списку с url-путями. Результат выводит в виде url и списка HTTP_CODE в одну строку
#
#    domain     - имя домена сайта
#    file       - файл содержит список путей, по одному в строке
#

SITEHOST=$1
shift
FILEPATHS=$@

NO_COLOUR="\033[0;0;39m"
BLINK_RED="\033[5;1;31m"
BLUE="\033[34m"
LIGHT_RED="\033[91m"
LIGHT_GREEN="\033[92m"

for path in `cat $FILEPATHS`; do
    echo -n "$SITEHOST$path"
    for codes in `curl -k -s -L -I $SITEHOST$path | grep HTTP | sed 's/HTTP\/.* \([0-9][0-9][0-9]\) .*/\1/'`; do
        for code in $codes; do
            case "$(echo $code | head -c 1)" in
                2) echo -ne $LIGHT_GREEN;;
                3) echo -ne $BLUE;;
                4) echo -ne $LIGHT_RED;;
                5) echo -ne $BLINK_RED;;
            esac
            echo -n " $codes"
            echo -ne $NO_COLOUR
        done
    done
    echo
done
