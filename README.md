# ffmpeg-build
[![Build Status](https://travis-ci.org/martinr92/ffmpeg-build.svg?branch=master)](https://travis-ci.org/martinr92/ffmpeg-build)

## download
If you not want to compile ffmpeg on yourself, download a successful build from [https://ffmpeg.martin-riedl.de/build/osx/](https://ffmpeg.martin-riedl.de/build/osx/).

## ffmpeg build for OSX
This repository builds ffmpeg, ffprobe and ffserver for Mac OSX using
- [YASM 1.3.0](http://yasm.tortall.net/)
- [x264](http://www.videolan.org/developers/x264.html)

## archive
The created archive contains following data:
- bin (binary files like ffmpeg, ffprobe and ffserver)
- include (header files)
- lib (libraries like libavcodec.a, libavfilter.a and libavformat.a)
- share (documentation and sample code)

## execution
Following environment variables must be set before executing:
- FF_ROOT = empty directory for the whole content
- FF_VERSION = ffmpeg version (e.g. 3.3 or snapshot)

After the build you find the FF_ROOT folder a ffmpeg-VERSION-DATE.zip file with all the compiled content (including binary files and libraries).
