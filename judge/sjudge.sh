#! /bin/bash

##
#	Usage:
#           SOURCE IN OUT TYPE	COMPILATION	EXECUTION	TL	ML
# sjudge.sh a.cpp  in out 1   \
#'g++ -Wall -O2 -static -pipe -o $SOURCE.BIN $SOURCE' \
#'$SRUN -F10 -t$TL -T$RTL -i$INFILE -o$SOURCE.OUT -e$SOURCE.ERR -U$jailu -G$jailg -n0 -C. -f20000 -d512000 -m512000 ./$SOURCE' \
# 1 250
#
# E.g:
# COMPILATION		g++ -Wall -O2 -static -pipe -o a.BIN a.cpp
# EXECUTION			/usr/bin/safeexec -F10 -t2 -iexample/a.in -oexample/a.OUT -eexample/a.ERR -n0 -C. -f20000 -d512000 -m512000 example/a
##


#log of events
t=$0
arr=(${t//./ })
slog=${arr[0]}.log
echo "" > $slog

# To know utpjudgejail id
basename=utpjudgejail
#umask 0022
id -u $basename >/dev/null 2>/dev/null
if [ $? == 0 ]; then
  jailu=`id -u $basename`
  jailg=`id -g $basename`
  #chown $basename.nogroup .
else
  jailu=`id -u nobody`
  jailg=`id -g nobody`
  #chown nobody.nogroup .
fi

if [ "$jailu" == "" -o "$jailg" == "" ]; then
	echo "Error finding user to run script" >> $slog;
	exit;
fi

# This script makes use of $COMMNAME to execute the code with less privilegies
COMMNAME=safeexec
SRUN=/usr/bin/$COMMNAME

if [ ! -x $SRUN ]; then
  echo "$SRUN not found or it's not executable" >> $slog;
  exit;
fi

SOURCE=$1
INFILE=$2
OUTFILE=$3
TYPE=$4
COMPILATION=$5
EXECUTION=$6
TL=$7
ML=$8
RTL=30


if [ ! -f $SOURCE ]; then
  echo "$SOURCE does not exist" >> $slog;
  exit;
fi;

if [ ! -f $INFILE ]; then
  echo "$INFILE does not exist" >> $slog;
  exit;
fi;

if [ ! -f $OUTPUT ]; then
  echo "$OUTFILE does not exist" >> $slog;
  exit;
fi;

# Set values by default
if [ "$TL" == "" ]; then
  TL=5;
fi
let RTL=$TL+30	# Set the real time limit

if [ "$ML" == "" ]; then
  ML=131072;
fi

if [ "$TYPE" == "" ]; then
  echo "The value for TYPE is required" >> $slog;
  exit;
fi

if [ "$TYPE" == "1" ]; then
  if [ "'$COMPILATION'" == "" -o "'$EXECUTION'" == "" ]; then
    echo "For the TYPE=1 'COMPILATION' and 'EXECUTION' are required" >> $slog;
    exit;
  fi
elif [ "$TYPE" == "2" ]; then
  if [ "$EXECUTION" == "" ]; then
    echo "For the TYPE=2 command 'EXECUTION' is required" >> $slog;
    exit;
  fi
else
  echo "Unknown value '$TYPE' for TYPE" >> $slog;
  exit;
fi

t=$(basename $SOURCE)
arr=(${t//./ })
EXECNAME=${arr[0]}
path=protected/submissions

#To replace string '$VAR' by the value of each variable
COMPILATION="${COMPILATION//'SOURCE.BIN'/$path/$EXECNAME}"
COMPILATION="${COMPILATION//'SOURCE'/$SOURCE}"
[ "$TYPE" == "1" ]; EXECUTION="${EXECUTION//'SOURCE.BIN'/$EXECNAME}"
EXECUTION="${EXECUTION//'SOURCE'/$(basename $SOURCE)}"
EXECUTION="${EXECUTION//'INFILE'/$(basename $INFILE)}"
EXECUTION="${EXECUTION//'SRUN'/$SRUN}"
EXECUTION="${EXECUTION//'TL'/$TL}"
EXECUTION="${EXECUTION//'ML'/$ML}"
EXECUTION="${EXECUTION//'jailu'/$jailu}"
EXECUTION="${EXECUTION//'jailg'/$jailg}"
EXECUTION="${EXECUTION//'SRUN'/$SRUN}"

# Path absolute to execute programs
PRUNNING=/$basename/RUNS
# Path into jail
PRUN=/RUNS

#To compilation
if [ "$TYPE" == "1" ]; then
  echo "Compiling .." >> $slog;
  eval $COMPILATION 2>> $slog;	#Compilation
  if [ $? == 0 ]; then
    #ulimit  -t $TL -m $ML
    echo "Executing .." >> $slog;
    #eval $EXECUTION #Execution
    cdir=$PRUNNING
    # Coping infile and .BIN into jail
    cp $INFILE $PRUNNING
    cp $path/$EXECNAME $PRUNNING
    chmod +x $PRUNNING/$EXECNAME

    cat <<EOF > $PRUNNING/run.sh
#!/bin/bash
[ -f /proc/cpuinfo ] || /bin/mount -t proc proc /proc
[ -d /sys/kernel ] || /bin/mount -t sysfs sysfs /sys
cd $PRUN
eval $EXECUTION
echo \$? > run.retcode
/bin/umount /proc 2>/dev/null
/bin/umount /sys 2>/dev/null
EOF

    chmod 755 $PRUNNING/run.sh
    chroot /$basename $PRUN/run.sh

    if [ $? != 0 ]; then
      cat run.retcode | echo;
      exit;
    fi;
  else
    echo "Compilation error";
    exit;
  fi;

#No compilation
elif [ "$TYPE" == "2" ]; then
  #ulimit  -t $TL -m $ML
  #eval $EXECUTION
  cdir=$PRUNNING
  # Coping infile and .BIN into jail
  cp $INFILE $PRUNNING
  cp ${SOURCE} $PRUNNING
  chmod +x $PRUNNING/$(basename $SOURCE)

  cat <<EOF > $PRUNNING/run.sh
#!/bin/bash
[ -f /proc/cpuinfo ] || /bin/mount -t proc proc /proc
[ -d /sys/kernel ] || /bin/mount -t sysfs sysfs /sys
cd $PRUN
eval $EXECUTION
echo \$? > run.retcode
/bin/umount /proc 2>/dev/null
/bin/umount /sys 2>/dev/null
EOF

  chmod 755 $PRUNNING/run.sh
  chroot /$basename $PRUN/run.sh
fi;

ret=`cat $PRUNNING/run.retcode`
echo "** $ret" >> $slog
if [ "$ret" == "0" ]; then
  # The output file is in /utpjudgejail/RUNS/{NAME}.OUT
  sname=`basename "$SOURCE" .OUT`
  SOURCE="$PRUNNING/$sname"

  # This presentation error only checks white spaces and newlines
  DIFF=`diff -wB $OUTFILE ${SOURCE}.OUT`
  if [ $? == 0 ]; then
    DIFF2=`diff $OUTFILE ${SOURCE}.OUT`
    if [ $? == 0 ]; then
      echo "YES";
    else
      echo "NO - Presentation error";
    fi
  else
    echo "NO";
  fi
elif [ "$ret" == "1" ]; then
  echo "NO - Compile error";
elif [ "$ret" == "2" -o "$ret" == "9" ]; then
  echo "NO - Runtime error";
elif [ "$ret" == "3" ]; then
  echo "NO - Timelimit exceeded";
elif [ "$ret" == "7" ]; then
  echo "NO - Memory limit exceeded";
else 
  echo "Unknown error";
fi;

