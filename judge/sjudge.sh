#! /bin/bash

##
#	Usage:
#           SOURCE IN OUT TYPE	COMPILATION	EXECUTION	TL	ML
# sjudge.sh a.cpp  in out 1   \
#'g++ -Wall -O2 -static -pipe -o main.cpp main.cpp' \
#'/usr/bin/safeexec -F10 -t1 -U1012 -G1015 -imain.IN -omain.OUT -emain.ERR -n0 -C. -f20000 -d512000 -m128000 ./main'  1 250
##

# The return code show what happened (according to safeexec):
# 0 ok
# 1 compile error
# 2 runtime error
# 3 timelimit exceeded
# 4 internal error
# 5 parameter error
# 6 internal error
# 7 memory limit exceeded
# 8 security threat
# 9 runtime error

basename=utpjudgejail

#log of events
ROOT=`pwd`
t=$0
arr=(${t//./ })
slog=$ROOT/${arr[0]}.log
echo "" >> $slog

# To know user id
id -u $basename >/dev/null 2>/dev/null
if [ $? == 0 ]; then
  jailu=`id -u $basename`
  jailg=`id -g $basename`
else
  jailu=`id -u nobody`
  jailg=`id -g nobody`
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

#To replace string '$VAR' by the value of each variable
EXECUTION="${EXECUTION//'SRUN'/$SRUN}"
EXECUTION="${EXECUTION//'RTL'/$RTL}"
EXECUTION="${EXECUTION//'jailu'/$jailu}"
EXECUTION="${EXECUTION//'jailg'/$jailg}"

# Path absolute to execute programs
PRUNNING=/$basename/RUNS
# Path into jail
PRUN=/RUNS

# Extension
tmp=(${SOURCE//./ })
ext=${tmp[1]}

# rm all files into $PRUNNING
rm $PRUNNING/*

#To compilation
if [ "$TYPE" == "1" ]; then
  echo "Copying and rename 'source.ext' to 'main.ext' in /$basename/RUNS" >> $slog;
  cp $SOURCE $PRUNNING/main.$ext

  echo "Copying $INFILE in $PRUNNING" >> $slog;
  cp $INFILE $PRUNNING/main.IN

  echo "Copying correct outputfile in $PRUNNING" >> $slog;
  cp $OUTFILE $PRUNNING/correct.OUT

  echo "Change directory to $PRUNNING" >> $slog;
  cd $PRUNNING

  echo "Compiling .." >> $slog;
  eval $COMPILATION 2>> $slog;	#Compilation
  chmod +x main*

  if [ $? == 0 ]; then
    echo "Executing .." >> $slog;
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
  echo "Copying and rename 'source.ext' to 'main.ext' in $PRUNNING" >> $slog;
  cp $SOURCE $PRUNNING/main.$ext

  echo "Copying $INFILE and rename in $PRUNNING" >> $slog;
  cp $INFILE $PRUNNING/main.IN

  echo "Copying correct outputfile in $PRUNNING" >> $slog;
  cp $OUTFILE $PRUNNING/correct.OUT

  echo "Change directory to $PRUNNING" >> $slog;
  cd $PRUNNING
  chmod +x main*

  echo "Executing .." >> $slog;
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
  # This presentation error only checks white spaces and newlines
  DIFF=`diff -wB correct.OUT main.OUT`
  if [ $? == 0 ]; then
    DIFF2=`diff correct.OUT main.OUT`
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

