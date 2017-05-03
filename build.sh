# set some paths and environment variables
echo "use FF_ROOT = $FF_ROOT"
export FF_SOURCE="$FF_ROOT/ffsource"
mkdir "$FF_SOURCE"
if [ $? -ne 0 ]
then
    echo "unable to create source directory!"
    exit 1
fi
export FF_OUT="$FF_ROOT/ffout"
mkdir "$FF_OUT"
if [ $? -ne 0 ]
then
    echo "unable to create output directory!"
    exit 1
fi

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
if [ "$TRAVIS" = "true" ]
then
    echo "travis_fold:start:YASM"
fi
echo "=== START YASM ==="
date
export FF_OUT_YASM="$FF_ROOT/yasm"
cd "$FF_SOURCE"
curl -O http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
if [ $? -ne 0 ]
then
    echo "download of yasm failed!"
    exit 1
fi

# build yasm
tar -zxf yasm-*
cd yasm-*
./configure --enable-silent-rules --prefix="$FF_OUT_YASM"
make -j $FF_CPU
make install
export PATH="$FF_OUT_YASM/bin:$PATH"
date
echo "=== END YASM ==="
if [ "$TRAVIS" = "true" ]
then
    echo "travis_fold:end:YASM"
fi

# download cmake
if [ "$TRAVIS" = "true" ]
then
    echo "travis_fold:start:CMAKE"
fi
echo "=== START CMAKE ==="
date
export FF_OUT_CMAKE="$FF_ROOT/cmake"
cd "$FF_SOURCE"
curl -O https://cmake.org/files/v3.8/cmake-3.8.1.tar.gz
if [ $? -ne 0 ]
then
    echo "download of cmake failed!"
    exit 1
fi

# build cmake
tar -zxf cmake-*
cd cmake-*
./configure --prefix="$FF_OUT_CMAKE" --parallel=$FF_CPU
make -j $FF_CPU
make install
export PATH="$FF_OUT_CMAKE/bin:$PATH"
date
echo "=== END CMAKE ==="
if [ "$TRAVIS" = "true" ]
then
    echo "travis_fold:end:CMAKE"
fi

# download x264
if [ "$TRAVIS" = "true" ]
then
    echo "travis_fold:start:x264"
fi
echo "=== START x264 ==="
date
cd "$FF_SOURCE"
curl -O ftp://ftp.videolan.org/pub/x264/snapshots/last_x264.tar.bz2
if [ $? -ne 0 ]
then
    echo "download of x264 failed!"
    exit 1
fi

# build x264
bunzip2 last_x264.tar.bz2
tar -xf last_x264.tar
cd x264*
./configure --prefix="$FF_OUT" --enable-static
make -j $FF_CPU
make install
date
echo "=== END x264 ==="
if [ "$TRAVIS" = "true" ]
then
    echo "travis_fold:end:x264"
fi

# download x265
if [ "$TRAVIS" = "true" ]
then
    echo "travis_fold:start:x265"
fi
echo "=== START x265 ==="
date
cd "$FF_SOURCE"
curl -O -L https://bitbucket.org/multicoreware/x265/downloads/x265_2.4.tar.gz
if [ $? -ne 0 ]
then
    echo "download of x265 failed!"
    exit 1
fi

# build x265
tar -zxf x265_*
cd x265_*
cmake -DCMAKE_INSTALL_PREFIX:PATH=$FF_OUT -DENABLE_SHARED=NO source
make -j $FF_CPU
make install
# https://mailman.videolan.org/pipermail/x265-devel/2014-April/004227.html
sed -i -e 's/lx265/lx265 -lstdc++/g' $FF_OUT/lib/pkgconfig/x265.pc
date
echo "=== END x265 ==="
if [ "$TRAVIS" = "true" ]
then
    echo "travis_fold:end:x265"
fi

# download pkg-config
if [ "$TRAVIS" = "true" ]
then
    echo "travis_fold:start:pkg-config"
fi
echo "=== START pkg-config ==="
date
export FF_OUT_PKG_CONFIG="$FF_ROOT/pkg-config"
cd "$FF_SOURCE"
curl -O https://pkg-config.freedesktop.org/releases/pkg-config-0.29.2.tar.gz
if [ $? -ne 0 ]
then
    echo "download of pkg-config failed!"
    exit 1
fi

# build pkg-config
tar -zxf pkg-config-*
cd pkg-config-*
./configure --prefix="$FF_OUT_PKG_CONFIG" --with-pc-path="$FF_OUT/lib/pkgconfig" --with-internal-glib
make -j $FF_CPU
make install
export PATH="$FF_OUT_PKG_CONFIG/bin:$PATH"
date
echo "=== END pkg-config ==="
if [ "$TRAVIS" = "true" ]
then
    echo "travis_fold:end:pkg-config"
fi

# download ffmpeg
if [ "$TRAVIS" = "true" ]
then
    echo "travis_fold:start:ffmpeg"
fi
echo "=== START ffmpeg ==="
date
cd "$FF_SOURCE"
curl -O https://ffmpeg.org/releases/ffmpeg-$FF_VERSION.tar.bz2
if [ $? -ne 0 ]
then
    echo "download of ffmpeg failed!"
    exit 1
fi

# build ffmpeg
bunzip2 ffmpeg-$FF_VERSION.tar.bz2
tar -xf ffmpeg-$FF_VERSION.tar
export FF_FLAGS="-L${FF_OUT}/lib -I${FF_OUT}/include" 
export LDFLAGS="$FF_FLAGS" 
export CFLAGS="$FF_FLAGS"
cd ffmpeg*
./configure --prefix="$FF_OUT" --enable-gpl --enable-libx264 --enable-libx265
if [ $? -ne 0 ]
then
    echo "configuration of ffmpeg failed!"
    exit 1
fi
make -j $FF_CPU
make install
date
echo "=== END ffmpeg ==="
if [ "$TRAVIS" = "true" ]
then
    echo "travis_fold:end:ffmpeg"
fi

# create some info files
cd "$FF_OUT/bin"
./ffmpeg -codecs > $FF_OUT/ffmpeg_codecs.txt
./ffmpeg -formats > $FF_OUT/ffmpeg_formats.txt
echo "==============" > $FF_OUT/ffmpeg_info.txt
echo "=== FFMPEG ===" >> $FF_OUT/ffmpeg_info.txt
echo "==============" >> $FF_OUT/ffmpeg_info.txt
./ffmpeg -version >> $FF_OUT/ffmpeg_info.txt
echo "==============" >> $FF_OUT/ffmpeg_info.txt
echo "=== x264  ===" >> $FF_OUT/ffmpeg_info.txt
echo "==============" >> $FF_OUT/ffmpeg_info.txt
./x264 --version >> $FF_OUT/ffmpeg_info.txt
echo "==============" >> $FF_OUT/ffmpeg_info.txt
echo "=== x265  ===" >> $FF_OUT/ffmpeg_info.txt
echo "==============" >> $FF_OUT/ffmpeg_info.txt
./x265 --version >> $FF_OUT/ffmpeg_info.txt 2>&1

# pack data
cd "$FF_OUT"
zip -9 -r "$FF_ROOT/ffmpeg-$FF_VERSION.zip" *
