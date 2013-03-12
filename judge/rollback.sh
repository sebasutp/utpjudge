basename=utpjudgejail
homejail=/home/$basename
COMMNAME=safeexec

rm -rf /usr/bin/$COMMNAME
rm -rf $homejail
rm -rf /$basename
rm -rf /etc/schroot/chroot.d/$basename.conf
deluser $basename
delgroup g$basename

