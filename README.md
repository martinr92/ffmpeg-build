# FFmpeg-build
## Download
Download the latest release directly from [GitHub](https://github.com/martinr92/ffmpeg-build/releases).
All builds are also availabe in my archive [https://ffmpeg.martin-riedl.de/build/](https://ffmpeg.martin-riedl.de/build/).

## FFmpeg build for Mac OS X and Linux
This repository builds ffmpeg, ffprobe and ffserver for Mac OSX and Linux using
- build tools
    - [cmake 3.12.4](https://cmake.org/)
    - [nasm 2.13.03](http://www.nasm.us/)
    - [pkg-config 0.29.2](https://www.freedesktop.org/wiki/Software/pkg-config/)
    - [YASM 1.3.0](http://yasm.tortall.net/)
- video codecs
    - [x264](http://www.videolan.org/developers/x264.html) for H.264 encoding
    - [x265 2.9](http://x265.org/) for H.265/HEVC encoding
    - [vpx 1.7.0](https://www.webmproject.org/) for VP8/VP9 de/encoding
- audio codecs
    - [fdk-aac 0.1.6](https://sourceforge.net/projects/opencore-amr/) for AAC de/encoding
    - [LAME 3.100](http://lame.sourceforge.net/) for MP3 encoding
- others
    - [fontconfig 2.13.0](https://www.freedesktop.org/wiki/Software/fontconfig/)
    - [FreeType 2.9.1](https://www.freetype.org/)
    - [frei0r 1.6.1](https://frei0r.dyne.org/)
    - [zlib 1.2.11](https://zlib.net/)

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
- FF_VERSION = ffmpeg version (e.g. 4.1 or snapshot)

The following environment variables are optional:
- FF_CPU = number of CPU threads (default: 1)

After the build you find the FF_ROOT folder a ffmpeg-VERSION-DATE.zip file with all the compiled content (including binary files and libraries).

Example
```
export FF_ROOT=/Users/martin/Downloads/ffmpeg
export FF_VERSION=4.1
export FF_CPU=2
./build.sh
```

## Codec missing?
Open an issue if you need a missing codec and I will add them soon.
