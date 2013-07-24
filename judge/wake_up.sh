#! /bin/bash

# Check if running as root
if [ "`id -u`" != "0" ]; then
  echo "Must be run as root"
  exit;
fi

control_c(){
    clear
    echo "\nKilling the super server ...\n Thanks for use (: \n"
    kill -9 $PID1 $PID2 $PID3
}

trap control_c SIGINT

PATH_BOT=../judgebot
PATH_SERVER=../judge

cd $PATH_BOT
echo "Rising $PATH_BOT/ruby_srv ... "
ruby ruby_srv.rb &
PID1=$!
echo "Rising $PATH_BOT/rece_vere_ser ... "
ruby rece_vere_ser.rb &
PID2=$1
cd $PATH_SERVER
echo "Rising the super server !! ... "
rails s 
PID3=$!


