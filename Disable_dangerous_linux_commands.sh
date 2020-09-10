#! /bin/bash

#Prevent rm -r

cd /
mkdir /dis
chown root:root /dis
chmod 700 /dis
mv /usr/bin/rm /dis/r_di
chown root:root /dis/r_di
chmod 700 /dis/r_di



#Prevent command> dev/sda

mv /usr/bin/command /dis/c_di
chown root:root /dis/c_di
chmod 700 /dis/c_di

#Prevent fork bomb
ulimit -u 30
ulimit -a
sysctl vm.swappiness=0

