# set some environment variables
export FF_SOURCE="$FF_ROOT/ffsource"
export FF_OUT="$FF_ROOT/ffout"

# download ffmpeg
mkdir "$FF_SOURCE"
cd "$FF_SOURCE"
curl -O https://ffmpeg.org/releases/ffmpeg-3.3.tar.gz
tar -zxf ffmpeg-3.3.tar.gz
export FFMPEG_SOURCE="$FF_SOURCE/ffmpeg-3.3"

# build ffmpeg
cd "$FFMPEG_SOURCE"
./configure --prefix="$FF_OUT"
make
make install
