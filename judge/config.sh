#!/bin/bash
# 
# This script configures everything needed to use safeexec
# 

if [ "`id -u`" != "0" ]; then	# Check if running as root
  echo "Must be run as root"
  exit;
fi

# 
# To install all packages needed
#
##LIST_DEBS_JAIL="g++ gcc libstdc++6 sharutils default-jdk default-jre"
LIST_DEBS_JAIL="g++"
##LIST_DEBS="quota debootstrap schroot sysstat g++ gcc libstdc++6 makepasswd mii-diag \
##					 sharutils openjdk-6-dbg default-jdk openjdk-6-doc sysvinit-utils"
LIST_DEBS="g++"

##apt-get update > /dev/null 2>/dev/null;
apt-get -y install $LIST_DEBS > /dev/null 2>/dev/null;

#
# To compile and create command $COMMNAME if does not exists
#
COMMNAME=safeexec
if [ ! -x /usr/bin/$COMMNAME ]; then
	if [ -f $COMMNAME.c ]; then
		gcc -Wall -o $COMMNAME $COMMNAME.c >/dev/null 2>/dev/null;
		if [ $? == 0 ]; then
			mv $COMMNAME /usr/bin/
			echo "Successful create command /usr/bin/$COMMNAME";
		else
			echo "Compilation error -> $COMMNAME.c";
			exit;
		fi
	else
		echo "File not found -> $COMMNAME.c";
		exit;
	fi
fi

#
# To create the utpjudgejail
#
basename=utpjudgejail
homejail=/home/$basename
DISTRIB_CODENAME=testing
PRUN=RUNS

commands="setquota ln id chown chmod dirname useradd mkdir cp rm mv apt-get dpkg uname debootstrap schroot"
for i in $commands; do	# Check if all commands are found
	p=`which $i`
  if [ -x "$p" ]; then
    echo -n "";
  else
    echo "Command "$i" not found";
		echo "All commands are required";
    exit;
  fi
done

if [ -d /$basename/ ]; then	# Check if already exists
  echo "The '/$basename/' already exists";
  exit;
fi

if [ -f $homejail/proc/cpuinfo ]; then
  echo "You seem to have already installed /$basename and the /$basename/proc seems to be mounted";
  chroot $homejail umount /sys >/dev/nul 2>/dev/null;
  chroot $homejail umount /proc >/dev/nul 2>/dev/null;
  echo "To continue you to have remove such mounted point";
  exit;
fi

id -u $basename >/dev/null 2>/dev/null;	# If user does not exist then will be created
if [ $? != 0 ]; then
	groupadd g$basename;
	useradd -m -s /bin/bash -d $homejail -g g$basename $basename;
	if [ $? != 0 ]; then
		echo "Failed to create user $basename";
		exit;
	fi
else
  echo "User '$basename' already exists";
  exit;
fi

setquota -u $basename 0 500000 0 10000 -a;

rm -rf /$basename
mkdir -p $homejail/tmp
chmod 1777 $homejail/tmp
ln -s $homejail /$basename
[ -x /usr/bin/$COMMNAME ] && cp -a /usr/bin/$COMMNAME /$basename/usr/bin/

cat <<FIM > /etc/schroot/chroot.d/$basename.conf
[$basename]
description=Jail
location=$homejail
directory=$homejail
root-users=root
type=directory
users=$basename,nobody,root
FIM

#debootstrap $DISTRIB_CODENAME $homejail;
debootstrap --no-check-gpg $DISTRIB_CODENAME $homejail;
if [ $? != 0 ]; then
  echo "'$basename' failed to debootstrap";
  exit;
else

schroot -l | grep -q $basename;
if [ $? == 0 ]; then
  echo "$basename successfully installed at $homejail";
else
  echo "*** some error has caused $basename not to install properly -- I will try it again with different parameters";
  grep -v "^location" /etc/schroot/chroot.d/$basename.conf > /tmp/.$basename.tmp;
  mv /tmp/.$basename.tmp /etc/schroot/chroot.d/$basename.conf;
  debootstrap $DISTRIB_CODENAME $homejail;
  schroot -l | grep -q $basename;
  if [ $? == 0 ]; then
    echo "*** '$basename' successfully installed at $homejail";
  else
    echo "*** '$basename' failed to install";
    exit;
  fi
fi
fi

echo "*** Intalling packages into $homejail";
cat <<EOF > /home/$basename/tmp/install.sh
#!/bin/bash
mount -t proc proc /proc
##apt-get -y update
apt-get -y install $LIST_DEBS_JAIL
umount /proc
EOF

mkdir $homejail/$PRUN
chown $basename:g$basename $homejail/$PRUN
chmod 755 $homejail/$PRUN
cp -f /etc/apt/sources.list $homejail/etc/apt/
chmod 755 /home/$basename/tmp/install.sh
cd / ; chroot $homejail /tmp/install.sh
