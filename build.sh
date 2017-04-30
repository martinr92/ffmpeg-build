# set some paths and environment variables
echo "use FF_ROOT = $FF_ROOT"
export FF_SOURCE="$FF_ROOT/ffsource"
mkdir "$FF_SOURCE"
export FF_OUT="$FF_ROOT/ffout"
mkdir "$FF_OUT"

# override ff-version for snapshot build
if [ "$TRAVIS_EVENT_TYPE" = "cron" ] then
    export FF_VERSION=snapshot
    echo "set snapshot version"
fi

# download and install yasm
echo "start downloading yasm..."
export FF_OUT_YASM="$FF_OUT/yasm"
cd "$FF_SOURCE"
curl -O http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
tar -vzxf yasm-1.3.0.tar.gz
cd "yasm-1.3.0"
./configure --prefix="$FF_OUT_YASM"
make
make install
export PATH="$FF_OUT_YASM/bin:$PATH"

# download ffmpeg
echo "start downloading ffmpeg..."
cd "$FF_SOURCE"
curl -O https://ffmpeg.org/releases/ffmpeg-$FF_VERSION.tar.bz2
bunzip2 ffmpeg-$FF_VERSION.tar.bz2
tar -vxf ffmpeg-$FF_VERSION.tar
export FFMPEG_SOURCE="$FF_SOURCE/ffmpeg-$FF_VERSION"

# build ffmpeg
echo "start build process..."
cd "$FFMPEG_SOURCE"
./configure --prefix="$FF_OUT"
make
make install

# pack data
zip -9 -r "$FF_ROOT/ffmpeg-$FF_VERSION.zip" "$FF_OUT"
