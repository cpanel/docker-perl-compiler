#!/bin/sh -l

echo "Start container"

rpm -qf /etc/redhat-release

echo "Runing from: "
pwd

/usr/local/cpanel/3rdparty/perl/536/bin/perl -V

which perl
ls -l $(which perl)

