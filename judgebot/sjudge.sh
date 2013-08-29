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


#Directory to running submissions
frun=runs${10}
folder=files/$frun
slog=slog.log
echo "" >> $folder/$slog

# This script makes use of $COMMNAME to execute the code with less privilegies
commname=`which safeexec`

# User to judging
basename=utp
#SRUN=/usr/bin/$COMMNAME

if [ ! -x $commname ]; then
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
PL=$9
RTL=30
# Max number of child process
CP=0
# Max compilation time (in seconds) (1 minute by default)
CT=60


cd $folder

if [ ! -f $SOURCE ]; then
  echo "$SOURCE does not exist" >> $slog;
  exit;
fi;

if [ ! -f $INFILE ]; then
  echo "$INFILE does not exist" >> $slog;
  exit;
fi;

if [ ! -f $OUTFILE ]; then
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

# To know user iddoes not exist
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

#To replace string '$VAR' by the value of each variable
EXECUTION="${EXECUTION//'jailu'/$jailu}"
EXECUTION="${EXECUTION//'jailg'/$jailg}"
EXECUTION="${EXECUTION//'-TRTL'/-T$RTL}"
EXECUTION="${EXECUTION//'-uCP'/-u$CP}"

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


# Extension
tmp=(${SOURCE//./ })
ext=${tmp[1]}

##if [ ! -d "$frun" ]; then
#  echo "mkdir $frun" >> $slog
#  mkdir $frun
##else
##  echo "rm -rf $frun/*" >> $slog
##  rm -rf $frun/*
##fi

#To compilation
if [ "$TYPE" == "1" ]; then
  echo "Copying and rename '$SOURCE' to 'Main.$ext' in $frun" >> $slog;
  cp $SOURCE Main.$ext 2>> $slog;

  echo "Copying $INFILE in $frun" >> $slog;
  cp $INFILE Main.in 2>> $slog;
  chmod 744 Main.in

  echo "Copying correct outputfile in $frun" >> $slog;
  cp $OUTFILE correct.OUT 2>> $slog;
  chmod 700 correct.OUT

  echo "Change directory to $frun" >> $slog;
  cd $frun 2>> $slog;

  # Applying limits
  ulimit -t $CT

  echo "Compiling .. $COMPILATION" >> $slog;
  eval $COMPILATION 2>> $slog;	#Compilation

  if [ $? == 0 ]; then
    echo "Executing .." >> $slog;
    echo "Command: $EXECUTION" >> $slog;
    
    $EXECUTION 2>> $slog
    echo $? > run.retcode
    chmod 700 run.retcode

##    cat <<EOF > $PRUNNING/run.sh
#!/bin/bash
#[ -f /proc/cpuinfo ] || sudo /bin/mount -t proc proc /proc
#[ -d /sys/kernel ] || sudo /bin/mount -t sysfs sysfs /sys
#cd $PRUN
#$EXECUTION
#echo \$? > run.retcode
#sudo /bin/umount /proc 
#sudo /bin/umount /sys 
#EOF

    ## chmod 755 $PRUNNING/run.sh
    #chroot /$basename $PRUN/run.sh
    ## schroot -c $basename -p $PRUN/run.sh
    

    ##if [ $? != 0 ]; then
    ##  cat run.retcode | echo;
    ##  echo "XXX";
    ##  exit;
    ##fi;
  else
    echo "Compilation error";
    exit;
  fi;

#No compilation
elif [ "$TYPE" == "2" ]; then
  echo "Copying and rename '$SOURCE' to 'Main.$ext' in $frun" >> $slog;
  cp $SOURCE Main.$ext 2>> $slog
  
  echo "Copying $INFILE and rename in $frun" >> $slog;
  cp $INFILE Main.in 2>>$slog
  chmod 744 Main.in

  echo "Copying correct outputfile in $frun" >> $slog;
  cp $OUTFILE correct.OUT 2>> $slog
  chmod 700 correct.OUT

  echo "Change directory to $frun" >> $slog;
  cd $frun

  echo "Executing .." >> $slog;
  echo "Command: $EXECUTION" >> $slog;
  eval $EXECUTION
  echo $? > run.retcode 
  chmod 700 run.retcode
fi;

ret=`cat run.retcode`
echo "** $ret" >> $slog

if [ "$ret" == "0" ]; then
  # This presentation error only checks white spaces and newlines
  DIFF=`diff -wB correct.OUT Main.OUT`
  if [ $? == 0 ]; then
    DIFF2=`diff correct.OUT Main.OUT`
    if [ $? == 0 ]; then
      echo "YES";
    else
      echo "NO - Presentation error";
    fi
  else
    echo "NO - Wrong answer";
  fi
elif [ "$ret" == "1" ]; then
  echo "NO - Compile error";
elif [ "$ret" == "2" -o "$ret" == "9" ]; then
  echo "NO - Runtime error";
elif [ "$ret" == "3" ]; then
  echo "NO - Timelimit exceeded";
elif [ "$ret" == "7" ]; then
  echo "NO - Memory limit exceeded";
elif [ "$TYPE" == "2" -a -s Main.ERR ]; then echo "NO - Runtime Error";
else
  [ -s Main.OUT ]
  if [ $? == 0 ]; then
    DIFF=`diff -wB correct.OUT Main.OUT`
    if [ $? == 0 ]; then
      DIFF2=`diff correct.OUT Main.OUT`
      if [ $? == 0 ]; then
        echo "YES";
      else
        echo "NO - Presentation error";
      fi
    else
      echo "NO - Wrong answer";
    fi
  
  else echo "NO - NO OUTPUT";
  fi
fi;
