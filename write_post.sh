#!/bin/bash

if [ -z "$1" ]; then
    echo "insert post title as argument"
else
    TITLE="${1// /_}"
    PREFIX=`date +%Y_%m_%d__`
    code "input/journal/$PREFIX$TITLE.html"
fi

exit
