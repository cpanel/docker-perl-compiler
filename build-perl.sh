#!/bin/sh -l

#echo "Hello $1"
echo "Start container"

rpm -qf /etc/redhat-release

#time=$(date)
#echo ::set-output name=time::$time

echo "Runing from: "
pwd

tar xvzf v5.30.0.tar.gz
cd perl5-5.30.0

echo "."
echo "*********************************"
echo "** Applying custom patches"
echo "*********************************"

for p in $(ls ../patches/*.patch); do 
	patch -p3 -i $p && touch $p.done
done

export PERL_VERSION=5.30.0
export PERL_MAJOR_VERSION=530
export PREFIX=/usr/local/cpanel/3rdparty/perl/${PERL_MAJOR_VERSION}
export PERL_LIB_ROOT=/usr/local/cpanel/3rdparty/perl/${PERL_MAJOR_VERSION}/lib/perl5

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
   -Dsiteprefix=/opt/cpanel/perl5/${PERL_MAJOR_VERSION} \
   -Dsitebin=/opt/cpanel/perl5/${PERL_MAJOR_VERSION}/bin \
   -Dsitelib=/opt/cpanel/perl5/${PERL_MAJOR_VERSION}/site_lib \
   -Dusevendorprefix=true \
   -Dvendorbin=${PREFIX}/bin \
   -Dvendorprefix=${PERL_LIB_ROOT} \
   -Dvendorlib=${PERL_LIB_ROOT}/cpanel_lib \
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
