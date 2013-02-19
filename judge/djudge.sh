#! /bin/bash

if [ ! -f $1 ]; then
	echo "$1 does not exist";
	exit;
fi;
if [ ! -f $2 ]; then
	echo "$2 does not exist";
	exit;
fi;

if ( diff -wB $1 $2 --brief ); then
	echo "YES";
else
	echo "NO";
fi

