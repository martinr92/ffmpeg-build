# set some paths and environment variables
echo "use FF_ROOT = $FF_ROOT"
export FF_SOURCE="$FF_ROOT/ffsource"
mkdir "$FF_SOURCE"
export FF_OUT="$FF_ROOT/ffout"
mkdir "$FF_OUT"

# override ff-version for snapshot build
if [ "$TRAVIS_EVENT_TYPE" = "cron" ]
then
    export FF_VERSION=snapshot
    echo "set snapshot version"
fi

# download and install yasm
echo "start downloading yasm..."
export FF_OUT_YASM="$FF_ROOT/yasm"
cd "$FF_SOURCE"
curl -O http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
tar -zxf yasm-1.3.0.tar.gz
cd "yasm-1.3.0"
./configure --prefix="$FF_OUT_YASM"
make
make install
export PATH="$FF_OUT_YASM/bin:$PATH"

# download and install cmake
echo "start downloading cmake"
export FF_OUT_CMAKE="$FF_ROOT/cmake"
cd "$FF_SOURCE"
curl -O https://cmake.org/files/v3.8/cmake-3.8.0.tar.gz
tar -zxf cmake-*
cd cmake-*
./configure --prefix="$FF_OUT_CMAKE"
make
make install
export PATH="$FF_OUT_CMAKE/bin:$PATH"

# download and build x264
echo "start downloading x264..."
cd "$FF_SOURCE"
curl -O ftp://ftp.videolan.org/pub/x264/snapshots/last_x264.tar.bz2
bunzip2 last_x264.tar.bz2
tar -xf last_x264.tar
cd x264*
./configure --prefix="$FF_OUT" --enable-static
make
make install

# download and build x265
echo "start downloading x265..."
cd "$FF_SOURCE"
curl -O -L https://bitbucket.org/multicoreware/x265/downloads/x265_2.4.tar.gz
tar -zxf x265_*
cd x265_*
cmake -DCMAKE_INSTALL_PREFIX:PATH=$FF_OUT source
make
make install

# download ffmpeg
echo "start downloading ffmpeg..."
cd "$FF_SOURCE"
curl -O https://ffmpeg.org/releases/ffmpeg-$FF_VERSION.tar.bz2
bunzip2 ffmpeg-$FF_VERSION.tar.bz2
tar -xf ffmpeg-$FF_VERSION.tar
export FFMPEG_SOURCE="$FF_SOURCE/ffmpeg-$FF_VERSION"

# build ffmpeg
echo "start build process..."
export FF_FLAGS="-L${FF_OUT}/lib -I${FF_OUT}/include" 
export LDFLAGS="$FF_FLAGS" 
export CFLAGS="$FF_FLAGS"
cd "$FFMPEG_SOURCE"
./configure --prefix="$FF_OUT" --enable-gpl --enable-libx264 --enable-libx265
make
make install

# pack data
cd "$FF_OUT"
zip -9 -r "$FF_ROOT/ffmpeg-$FF_VERSION.zip" *
