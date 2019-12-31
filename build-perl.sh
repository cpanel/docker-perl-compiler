#!/bin/sh -l

set -e

echo "*********************************"
echo "** Start container: $0"
echo "*********************************"

####################################
## Enviornment Variables          ##
####################################

PERL_VERSION=5.30.0
PERL_MAJOR_VERSION=530
PERL_TAG=v${PERL_VERSION}

PREFIX=/usr/local/cpanel/3rdparty/perl/${PERL_MAJOR_VERSION}
PERL_LIB_ROOT=${PREFIX}/lib/perl5

SITE_PREFIX=/opt/cpanel/perl5/${PERL_MAJOR_VERSION}

####################################

rpm -qf /etc/redhat-release
echo -n "# Runing from: "
pwd

echo "."
echo "*********************************"
echo "** Cloning Perl Git Repository"
echo "*********************************"


git clone https://github.com/Perl/perl5.git
cd perl5
git checkout $PERL_TAG

echo "."
echo "*********************************"
echo "** Applying custom patches"
echo "*********************************"

for p in $(ls ../patches/*.patch); do 
	patch -p3 -i $p && ( echo "# Applied patch $p"; touch $p.done )
done

echo "."
echo "*********************************"
echo "** Configure"
echo "*********************************"

sh Configure -des \
   -Dusedevel \
   -Dcc='/usr/bin/gcc' \
   -Dcpp='/usr/bin/cpp' \
   -Dusemymalloc='n' \
   -DDEBUGGING=none \
   -Doptimize='-g3' \
   -Accflags='-m64' \
   -Dccflags='-DPERL_DISABLE_PMC -fPIC -DPIC' \
   -Duseshrplib \
   -Duselargefiles=yes \
   -Duseposix=true \
   -Dhint=recommended \
   -Duseperlio=yes \
   -Dprefix=${PREFIX} \
   -Dsiteprefix=${SITE_PREFIX} \
   -Dsitebin=${SITE_PREFIX}/bin \
   -Dsitelib=${SITE_PREFIX}/site_lib \
   -Dusevendorprefix=true \
   -Dvendorbin=${PREFIX}/bin \
   -Dvendorprefix=${PERL_LIB_ROOT} \
   -Dvendorlib=${PERL_LIB_ROOT}/vendor_lib \
   -Dprivlib=${PERL_LIB_ROOT}/${PERL_VERSION} \
   -Dman1dir=none \
   -Dman3dir=none \
   -Dscriptdir=${PREFIX}/bin -Dscriptdirexp=${PREFIX}/bin \
   -Dsiteman1dir=none \
   -Dsiteman3dir=none \
   -Dinstallman1dir=none \
   -Dversiononly=no \
   -Dinstallusrbinperl=no \
   -DDB_File=true \
   -Ud_dosuid \
   -Uuserelocatableinc \
   -Umad \
   -Uusethreads \
   -Uusemultiplicity \
   -Uusesocks \
   -Uuselongdouble \
   -Duse64bitint -Uuse64bitall

echo "."
echo "*********************************"
echo "** Make"
echo "*********************************"

TEST_JOBS=4 make -j4

make install

# this will be in our PATH by default
echo "create symlink"
ln -s ${PREFIX}/bin/perl /usr/local/bin/perl

echo "."
echo "*********************************"
echo "** Check"
echo "*********************************"

${PREFIX}/bin/perl -v

echo "."
echo "*********************************"
echo "** Installing cpm"
echo "*********************************"

curl -fsSL --compressed https://git.io/cpm > /usr/bin/cpm
chmod +x /usr/bin/cpm
/usr/bin/cpm --version

echo "."
echo "*********************************"
echo "** Installing dependencies"
echo "*********************************"

${PREFIX}/bin/perl /usr/bin/cpm install -g --no-test --cpanfile /build-perl/cpanfile

echo "."
echo "*********************************"
echo "** Done"
echo "*********************************"
echo ""
