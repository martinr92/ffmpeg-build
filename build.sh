#!/bin/bash

# block start
function startBlock {
    if [ "$TRAVIS" = "true" ]
    then
        echo "travis_fold:start:$1"
    fi
    echo "=== START $1 ==="
    date
}

# block end
function endBlock {
    date
    echo "=== END $1 ==="
    if [ "$TRAVIS" = "true" ]
    then
        echo "travis_fold:end:$1"
    fi
}

# check execution status
function checkExecutionStatus {
    if [ $2 -ne 0 ]
    then
        echo "ERROR in step '$1'"
        exit 1
    fi
}

# set some paths and environment variables
echo "use FF_ROOT = $FF_ROOT"
export FF_SOURCE="$FF_ROOT/ffsource"
mkdir "$FF_SOURCE"
checkExecutionStatus "create source directory" $?
export FF_OUT="$FF_ROOT/ffout"
mkdir "$FF_OUT"
checkExecutionStatus "create output directory" $?

# override ff-version for snapshot build
if [ "$TRAVIS_EVENT_TYPE" = "cron" ]
then
    export FF_VERSION=snapshot
    echo "use snapshot version"
fi

# check cpu cores
if [ "$FF_CPU" = "" ]
then
    export FF_CPU=1
fi
echo "use $FF_CPU CPU cores/threads"

# download yasm
startBlock yasm
export FF_OUT_YASM="$FF_ROOT/yasm"
cd "$FF_SOURCE"
curl -O http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
checkExecutionStatus "download of yasm" $?

# build yasm
tar -zxf yasm-*
cd yasm-*
./configure --enable-silent-rules --prefix="$FF_OUT_YASM"
checkExecutionStatus "configuration of yasm" $?
make -j $FF_CPU
checkExecutionStatus "compilation of yasm" $?
make install
checkExecutionStatus "installation of yasm" $?
export PATH="$FF_OUT_YASM/bin:$PATH"
endBlock yasm

# download cmake
startBlock cmake
export FF_CMAKE_VERSION=3.8.1
export FF_OUT_CMAKE="$FF_ROOT/cmake/cmake-${FF_CMAKE_VERSION}"
if [ ! -f $FF_OUT_CMAKE/bin/cmake ]
then
    cd "$FF_SOURCE"
    curl -O https://cmake.org/files/v3.8/cmake-${FF_CMAKE_VERSION}.tar.gz
    checkExecutionStatus "download of cmake" $?

    # build cmake
    tar -zxf cmake-*
    cd cmake-*
    ./configure --prefix="$FF_OUT_CMAKE" --parallel=$FF_CPU
    checkExecutionStatus "configuration of cmake" $?
    make -j $FF_CPU
    checkExecutionStatus "compilation of cmake" $?
    make install
    checkExecutionStatus "installation of cmake" $?
fi
export PATH="$FF_OUT_CMAKE/bin:$PATH"
endBlock cmake

# download x264
startBlock x264
cd "$FF_SOURCE"
curl -O ftp://ftp.videolan.org/pub/x264/snapshots/last_x264.tar.bz2
checkExecutionStatus "download of x264" $?

# build x264
bunzip2 last_x264.tar.bz2
tar -xf last_x264.tar
cd x264*
./configure --prefix="$FF_OUT" --enable-static
checkExecutionStatus "configuration of x264" $?
make -j $FF_CPU
checkExecutionStatus "compilation of x264" $?
make install
checkExecutionStatus "installation of x264" $?
endBlock x264

# download x265
startBlock x265
cd "$FF_SOURCE"
curl -O -L https://bitbucket.org/multicoreware/x265/downloads/x265_2.4.tar.gz
checkExecutionStatus "download of x265" $?

# build x265
tar -zxf x265_*
cd x265_*
cmake -DCMAKE_INSTALL_PREFIX:PATH=$FF_OUT -DENABLE_SHARED=NO source
make -j $FF_CPU
checkExecutionStatus "compilation of x265" $?
make install
checkExecutionStatus "installation of x265" $?
# https://mailman.videolan.org/pipermail/x265-devel/2014-April/004227.html
sed -i -e 's/lx265/lx265 -lstdc++/g' $FF_OUT/lib/pkgconfig/x265.pc
endBlock x265

# download fdk-aac
startBlock fdk-aac
cd "$FF_SOURCE"
curl -O https://netcologne.dl.sourceforge.net/project/opencore-amr/fdk-aac/fdk-aac-0.1.5.tar.gz
checkExecutionStatus "download of fdk-aac" $?

# build fdk-aac
tar -zxf fdk-aac*
cd fdk-aac*
./configure --prefix="$FF_OUT" --enable-shared=no
checkExecutionStatus "configuration of fdk-aac" $?
make -j $FF_CPU
checkExecutionStatus "compilation of fdk-aac" $?
make install
checkExecutionStatus "installation of fdk-aac" $?
endBlock fdk-aac

# download lame (mp3)
startBlock lame-mp3
cd "$FF_SOURCE"
curl -O https://netcologne.dl.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
checkExecutionStatus "download of lame-mp3" $?

# build lame
tar -zxf lame*
cd lame*
./configure --prefix="$FF_OUT" --enable-shared=no
checkExecutionStatus "configuration of lame-mp3" $?
make -j $FF_CPU
checkExecutionStatus "compilation of lame-mp3" $?
make install
checkExecutionStatus "installation of lame-mp3" $?
endBlock lame-mp3

# download pkg-config
startBlock pkg-config
export FF_OUT_PKG_CONFIG="$FF_ROOT/pkg-config"
cd "$FF_SOURCE"
curl -O https://pkg-config.freedesktop.org/releases/pkg-config-0.29.2.tar.gz
checkExecutionStatus "download of pkg-config" $?

# build pkg-config
tar -zxf pkg-config-*
cd pkg-config-*
./configure --prefix="$FF_OUT_PKG_CONFIG" --with-pc-path="$FF_OUT/lib/pkgconfig" --with-internal-glib
checkExecutionStatus "configuration of pkg-config" $?
make -j $FF_CPU
checkExecutionStatus "compilation of pkg-config" $?
make install
checkExecutionStatus "installation of pkg-config" $?
export PATH="$FF_OUT_PKG_CONFIG/bin:$PATH"
endBlock pkg-config

# download ffmpeg
startBlock ffmpeg
cd "$FF_SOURCE"
curl -O https://ffmpeg.org/releases/ffmpeg-$FF_VERSION.tar.bz2
checkExecutionStatus "download of ffmpeg" $?

# build ffmpeg
bunzip2 ffmpeg-$FF_VERSION.tar.bz2
tar -xf ffmpeg-$FF_VERSION.tar
export FF_FLAGS="-L${FF_OUT}/lib -I${FF_OUT}/include" 
export LDFLAGS="$FF_FLAGS" 
export CFLAGS="$FF_FLAGS"
cd ffmpeg*
./configure --prefix="$FF_OUT" --enable-gpl --enable-nonfree --enable-libx264 --enable-libx265 --enable-libfdk-aac --enable-libmp3lame
checkExecutionStatus "configuration of ffmpeg" $?
make -j $FF_CPU
checkExecutionStatus "compilation of ffmpeg" $?
make install
checkExecutionStatus "installation of ffmpeg" $?
endBlock ffmpeg

# create some info files
cd "$FF_OUT/bin"
./ffmpeg -codecs > $FF_OUT/ffmpeg_codecs.txt 2> /dev/null
./ffmpeg -formats > $FF_OUT/ffmpeg_formats.txt 2> /dev/null
echo "==================" > $FF_OUT/ffmpeg_info.txt
echo "===   FFMPEG   ===" >> $FF_OUT/ffmpeg_info.txt
echo "==================" >> $FF_OUT/ffmpeg_info.txt
./ffmpeg -version >> $FF_OUT/ffmpeg_info.txt
echo "==================" >> $FF_OUT/ffmpeg_info.txt
echo "===    x264    ===" >> $FF_OUT/ffmpeg_info.txt
echo "==================" >> $FF_OUT/ffmpeg_info.txt
./x264 --version >> $FF_OUT/ffmpeg_info.txt
echo "==================" >> $FF_OUT/ffmpeg_info.txt
echo "===    x265    ===" >> $FF_OUT/ffmpeg_info.txt
echo "==================" >> $FF_OUT/ffmpeg_info.txt
./x265 --version >> $FF_OUT/ffmpeg_info.txt 2>&1
echo "==================" >> $FF_OUT/ffmpeg_info.txt
echo "=== lame (mp3) ===" >> $FF_OUT/ffmpeg_info.txt
echo "==================" >> $FF_OUT/ffmpeg_info.txt
./lame --license | head -1 >> $FF_OUT/ffmpeg_info.txt

# pack data
startBlock zip-content
cd "$FF_OUT"
zip -9 -r "$FF_ROOT/ffmpeg-$FF_VERSION.zip" *
endBlock zip-content

# upload data
if [ "$TRAVIS" = "true" ]
then
    startBlock upload-ftp
    remotePath=build/${TRAVIS_OS_NAME}/${FF_VERSION}/ffmpeg-${FF_VERSION}_`date +%Y%m%d%H%M%S`.zip
    curl --ftp-create-dirs -T "$FF_ROOT/ffmpeg-$FF_VERSION.zip" -u $FTP_USER:$FTP_PASS ftp://$FTP_SERVER/$remotePath
    remotePath=build/${TRAVIS_OS_NAME}/${FF_VERSION}/ffmpeg-latest.zip
    curl --ftp-create-dirs -T "$FF_ROOT/ffmpeg-$FF_VERSION.zip" -u $FTP_USER:$FTP_PASS ftp://$FTP_SERVER/$remotePath
    endBlock upload-ftp
fi
