#!/bin/bash
# 
# This script configures everything needed to use safeexec
# 

# Check if running as root
if [ "`id -u`" != "0" ]; then
  echo "Must be run as root"
  exit;
fi

COMMNAME=safeexec
basename=utpjudgejail
homejail=/home/$basename
DISTRIB_CODENAME=testing
PRUN=RUNS

# To delete a previous installation, if exists
rm -rf /usr/bin/$COMMNAME
rm -rf $homejail
rm -rf /$basename
rm -rf /etc/schroot/chroot.d/$basename.conf
deluser $basename
delgroup g$basename

# To install all packages needed
LIST_DEBS_JAIL="g++ gcc libstdc++6 sharutils openjdk-6-jdk openjdk-6-jre openjdk-7-jdk openjdk-7-jre \
                python sudo"
LIST_DEBS="quota debootstrap schroot sysstat g++ gcc libstdc++6 makepasswd mii-diag \
					 sharutils openjdk-7-dbg openjdk-7-jdk openjdk-7-jre openjdk-7-doc sysvinit-utils"
echo "Executing: apt-get update ...";
apt-get update > /dev/null 2>/dev/null;
echo "done!";
echo "Executing: apt-get install $LIST_DEBS ...";
apt-get -y install $LIST_DEBS > /dev/null 2>/dev/null;
echo "done!";
echo "Creating commmand: '$COMMNAME' ...";
# To compile and create command $COMMNAME if does not exists
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

# Checks if all commands are found
commands="setquota ln id chown chmod dirname useradd mkdir cp rm mv apt-get dpkg uname debootstrap schroot"
for i in $commands; do
	p=`which $i`
  if [ -x "$p" ]; then
    echo -n "";
  else
    echo "Command "$i" not found";
		echo "All commands are required";
    exit;
  fi
done

# Checks if $homejail/proc/ already mounted
if [ -f $homejail/proc/cpuinfo ]; then
  echo "You seem to have already installed /$basename and the /$basename/proc seems to be mounted";
  chroot $homejail umount /sys >/dev/nul 2>/dev/null;
  chroot $homejail umount /proc >/dev/nul 2>/dev/null;
  echo "To continue you to have remove such mounted point";
  exit;
fi

echo "Creating user and group to jail: utpjudge, gutpjudge ...";
# To create user and group to jail
id -u $basename >/dev/null 2>/dev/null;	# If user does not exist then will be created
if [ $? != 0 ]; then
	groupadd g$basename;
	useradd -m -s /bin/bash -d $homejail -g g$basename $basename;
	if [ $? != 0 ]; then
		echo "Failed to create user $basename";
		exit;
	fi
fi
echo "done!";

setquota -u $basename 0 500000 0 10000 -a;

mkdir -p $homejail/tmp
chmod 1777 $homejail/tmp
ln -s $homejail /$basename


# To configure schroot file
cat <<FIM > /etc/schroot/chroot.d/$basename.conf
[$basename]
description=Jail
directory=$homejail
root-users=root
type=directory
users=$basename,nobody,root
FIM

echo "Installing base system with debootstrap ...";
# Installing base system
debootstrap $DISTRIB_CODENAME $homejail;
if [ $? != 0 ]; then
  echo "'$basename' failed to debootstrap. Trying again";
  debootstrap --no-check-gpg $DISTRIB_CODENAME $homejail;
  if [ $? != 0 ]; then
    echo "'$basename' failed to debootstrap";
    exit;
  fi
else
  # Search $basename in schroot users
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
echo "done!";

# Copying $COMMNAME into jail 
[ -x /usr/bin/$COMMNAME ] && cp -a /usr/bin/$COMMNAME /$basename/usr/bin/

cat <<EOF > /home/$basename/tmp/install.sh
#!/bin/bash
mount -t proc proc /proc
apt-get -y update
apt-get -y install $LIST_DEBS_JAIL
umount /proc
EOF

echo "Creating $homejail/$PRUN and configuring permissions ...";
mkdir $homejail/$PRUN
#chmod -R 700 $homejail # With these permissions is not possible read shared libraries like libtinfo.so.5
chown $basename:g$basename $homejail/$PRUN
chmod -R 755 $homejail/$PRUN

echo "done!";

cat <<EOF > $homejail/etc/apt/sources.list
deb http://ftp.debian.org/debian/ testing main contrib non-free
deb http://ftp.de.debian.org/debian testing main
deb http://security.debian.org/ testing/updates main contrib
EOF

echo "Intalling packages into $homejail";
chmod 755 /home/$basename/tmp/install.sh
cd / ; chroot $homejail /tmp/install.sh
echo "done!";

#To allow userjail mount and umount without pass
hostn=`hostname`
echo "$basename $hostn = (root) NOPASSWD: /bin/mount"  >> /home/$basename/etc/sudoers;
echo "$basename $hostn = (root) NOPASSWD: /bin/umount" >> /home/$basename/etc/sudoers;

