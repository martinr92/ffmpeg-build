# ffmpeg-build
[![Build Status](https://travis-ci.org/martinr92/ffmpeg-build.svg?branch=master)](https://travis-ci.org/martinr92/ffmpeg-build)

## ffmpeg build for OSX
This repository builds ffmpeg for Mac OSX using
- YASM 1.3.0

## execution
Following environment variables must be set before executing:
- FF_ROOT = empty directory for the whole content
- FF_VERSION = ffmpeg version (e.g. 3.3 or snapshot)

After the build you find the FF_ROOT folder a ffmpeg-VERSION-DATE.zip file with all the compiled content (including binary files and libraries).
