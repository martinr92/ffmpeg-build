# FFmpeg-build
[![Build Status](https://travis-ci.org/martinr92/ffmpeg-build.svg?branch=master)](https://travis-ci.org/martinr92/ffmpeg-build)

## Download
If you not want to compile ffmpeg on yourself, download a successful build from [https://ffmpeg.martin-riedl.de/build/](https://ffmpeg.martin-riedl.de/build/).

## FFmpeg build for Mac OS X and Linux
This repository builds ffmpeg, ffprobe and ffserver for Mac OSX and Linux using
- build
    - [cmake 3.8.2](https://cmake.org/)
    - [nasm 2.13.01](http://www.nasm.us/)
    - [pkg-config 0.29.2](https://www.freedesktop.org/wiki/Software/pkg-config/)
    - [YASM 1.3.0](http://yasm.tortall.net/)
- video codec
    - [x264](http://www.videolan.org/developers/x264.html) for H.264 encoding
    - [x265 2.4](http://x265.org/) for H.265/HEVC encoding
    - [vpx 1.6.1](https://www.webmproject.org/) for VP8/VP9 de/encoding
- audio codec
    - [fdk-aac 0.1.5](https://sourceforge.net/projects/opencore-amr/) for AAC de/encoding
    - [LAME 3.99.5](http://lame.sourceforge.net/) for MP3 encoding
- others
    - [fontconfig 2.12.1](https://www.freedesktop.org/wiki/Software/fontconfig/)
    - [FreeType 2.8](https://www.freetype.org/)
    - [frei0r 1.6.1](https://frei0r.dyne.org/)

## Archive
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
=== FFmpeg ===
==============
ffmpeg version x.x [...]
==============
=== x264  ===
==============
x264 x.x.x [...]
[...]
```

## Execution
Following environment variables must be set before executing:
- FF_ROOT = empty directory for the whole content
- FF_VERSION = ffmpeg version (e.g. 3.3.2 or snapshot)

The following environment variables are optional:
- FF_CPU = number of CPU threads (default: 1)

After the build you find the FF_ROOT folder a ffmpeg-VERSION-DATE.zip file with all the compiled content (including binary files and libraries).

Example
```
export FF_ROOT=/Users/martinriedl/Downloads/ffmpeg
export FF_VERSION=3.3.2
export FF_CPU=2
./build.sh
```

## Codec missing?
Open an issue if you need a missing codec and I will add them soon.
