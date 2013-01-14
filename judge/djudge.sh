#! /bin/bash

if (diff -wB $1 $2 > $3); then
    echo "YES"
else
    echo "WA"
fi
