#! /bin/bash

SOURCE=$1
INPUTFILE=$2
OUTFILE=$3

COMPILATION="g++ -Wall -O2 -static -pipe -o ${SOURCE}.BIN $SOURCE"
EXECUTION="./${SOURCE}.BIN < $INPUTFILE > ${SOURCE}.OUT 2> ${SOURCE}.ERR"

if [ ! -f $SOURCE ]; then
  echo "$SOURCE does not exist";
  exit;
fi;

if [ ! -f $INPUTFILE ]; then
  echo "$INPUTFILE does not exist";
  exit;
fi;

if [ ! -f $OUTPUT ]; then
  echo "$OUTFILE does not exist";
  exit;
fi;

## Code temporal
`$COMPILATION` #Compilation
if [ $? == 0 ]; then
#	`$EXECUTION` #Execution (Dont works)
	./${SOURCE}.BIN < $INPUTFILE > ${SOURCE}.OUT 2> ${SOURCE}.ERR
	if [ $? != 0 ]; then
		echo "Runtime error";
	fi
else
	echo "Compilation error";
	exit;
fi;

if (diff -wB $OUTFILE ${SOURCE}.OUT); then
  echo "YES";
else
  echo "NO";
fi
