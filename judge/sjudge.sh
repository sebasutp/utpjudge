#! /bin/bash

##
#	Usage:
#           SOURCE IN OUT TYPE COMPILATION	                                           EXECUTION                                                  TL ML
# sjudge.sh a.cpp  in out 1   'g++ -Wall -O2 -static -pipe -o ${SOURCE}.BIN ${SOURCE}' '${SOURCE}.BIN < ${INFILE} >${SOURCE}.OUT 2>${SOURCE}.ERR' 1  250
##

SOURCE=$1
INFILE=$2
OUTFILE=$3
TYPE=$4
COMPILATION=$5
EXECUTION=$6
TL=$7
ML=$8

if [ ! -f $SOURCE ]; then
  echo "$SOURCE does not exist";
  exit;
fi;

if [ ! -f $INFILE ]; then
  echo "$INFILE does not exist";
  exit;
fi;

if [ ! -f $OUTPUT ]; then
  echo "$OUTFILE does not exist";
  exit;
fi;

#To replace strings '${SOURCE}' and '${INFILE}' by the value of variables
COMPILATION="${COMPILATION//'${SOURCE}'/$SOURCE}"
EXECUTION="${EXECUTION//'${SOURCE}'/$SOURCE}"
EXECUTION="${EXECUTION//'${INFILE}'/$INFILE}"

#log of events
touch ${SOURCE}.log

#To compilation
if [ $TYPE == 1 ]; then
	echo "Compiling .." >> ${SOURCE}.log
	eval $COMPILATION #Compilation
	if [ $? == 0 ]; then
		ulimit  -t $TL -m $ML
		echo "Executing .." >> ${SOURCE}.log
		eval $EXECUTION #Execution
		if [ $? != 0 ]; then
			echo "Runtime error";
			exit;
		fi;
	else
		echo "Compilation error";
		exit;
	fi;

#No compilation
elif [ $TYPE == 2 ]; then
	ulimit  -t $TL -m $ML
	eval $EXECUTION
	if [ $? != 0 ]; then
		echo "Runtime error";
		exit;
	fi;
fi;


if (diff -wB $OUTFILE ${SOURCE}.OUT); then
  echo "YES";
else
  echo "NO";
fi
