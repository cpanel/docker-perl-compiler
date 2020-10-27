#!/bin/sh -l

#echo "Hello $1"
echo "Start container"

rpm -qf /etc/redhat-release

#time=$(date)
#echo ::set-output name=time::$time

echo "Runing from: "
pwd

/usr/local/cpanel/3rdparty/perl/532/bin/perl -V

which perl
ls -l $(which perl)

# echo "sleeping forever"
# while true; do sleep 1000; done
# echo "done"
