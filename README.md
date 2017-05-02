# ffmpeg-build
[![Build Status](https://travis-ci.org/martinr92/ffmpeg-build.svg?branch=master)](https://travis-ci.org/martinr92/ffmpeg-build)

## download
If you not want to compile ffmpeg on yourself, download a successful build from [https://ffmpeg.martin-riedl.de/build/osx/](https://ffmpeg.martin-riedl.de/build/osx/).

## ffmpeg build for OSX
This repository builds ffmpeg, ffprobe and ffserver for Mac OSX using
- [cmake 3.8.0](https://cmake.org/)
- [pkg-config 0.29.2](https://www.freedesktop.org/wiki/Software/pkg-config/)
- [x264](http://www.videolan.org/developers/x264.html)
- [x265 2.4](http://x265.org/)
- [YASM 1.3.0](http://yasm.tortall.net/)

## archive
The created archive contains following data:
- bin (binary files like ffmpeg, ffprobe and ffserver)
- include (header files)
- lib (libraries like libavcodec.a, libavfilter.a and libavformat.a)
- share (documentation and sample code)
- ffmpeg_codecs.txt
```
Codecs:
 D..... = Decoding supported
 .E.... = Encoding supported
 ..V... = Video codec
 ..A... = Audio codec
 ..S... = Subtitle codec
 ...I.. = Intra frame-only codec
 ....L. = Lossy compression
 .....S = Lossless compression
```
- ffmpeg_formats.txt
```
File formats:
 D. = Demuxing supported
 .E = Muxing supported
```
- ffmpeg_info.txt
```
==============
=== FFMPEG ===
==============
ffmpeg version x.x [...]
==============
=== x264  ===
==============
x264 x.x.x [...]
[....]
```

## execution
Following environment variables must be set before executing:
- FF_ROOT = empty directory for the whole content
- FF_VERSION = ffmpeg version (e.g. 3.3 or snapshot)

After the build you find the FF_ROOT folder a ffmpeg-VERSION-DATE.zip file with all the compiled content (including binary files and libraries).

Example
```
export FF_ROOT=/Users/martinriedl/Downloads/ffmpeg
export FF_VERSION=3.3
./build.sh
```

## Codec missing?
Open an issue if you need a missing codec and I will add them soon.
