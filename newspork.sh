#!/usr/local/bin/bash

SPORK_SERVER="http://www.sporkhack.com"
SPORK_PATCH="big_fork_patch.diff"
NEW_PATCH="${SPORK_PATCH}.new"
SPORK_DIR="sporkhack"
OLD_DIR="${SPORK_DIR}.old"

[[ -e ${NEW_PATCH} ]] && rm ${NEW_PATCH}
wget ${SPORK_SERVER}/${SPORK_PATCH} -O ${NEW_PATCH}

[[ -e ${SPORK_PATCH} ]] || touch ${SPORK_PATCH}
[[ "$(md5 ${SPORK_PATCH} | cut -f4 -d' ')" == "$(md5 ${NEW_PATCH} | cut -f4 -d' ')" ]] && echo "Patch unchanged" && exit
mv ${NEW_PATCH} ${SPORK_PATCH}

[[ -e ${OLD_DIR} ]] && rm -rf ${OLD_DIR}
mv ${SPORK_DIR} ${OLD_DIR}
mkdir ${SPORK_DIR}
cd ${SPORK_DIR}

tar zxvf ../nethack-343-src.tgz
mv nethack-3.4.3/* .
rmdir nethack-3.4.3

patch -p1 < ../${SPORK_PATCH}
cp ../${OLD_DIR}/include/config.h include/
cp ../${OLD_DIR}/include/config.h include/
cp ../${OLD_DIR}/include/unixconf.h include/
cp ../${OLD_DIR}/sys/unix/Makefile.* sys/unix/
cd sys/unix ; sh setup.sh ; cd ../../
cp ../${OLD_DIR}/Makefile .
cp ../${OLD_DIR}/src/Makefile src
sed -i -e 's/hackplayer/djm/' src/topten.c

diff -urq ../${OLD_DIR}/ ./ | grep -v "[Oo]nly in \.\./sporkhack\.old" | grep -v "\.c" | less

make all && sudo make install

