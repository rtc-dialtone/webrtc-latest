#!/bin/bash
set -ev
uname | grep 'MSYS'
curl -o depot_tools.zip https://storage.googleapis.com/chrome-infra/depot_tools.zip
unzip depot_tools.zip -d depot_tools
rm depot_tools.zip
export _PREV_PATH=$PATH
export PATH=$(which bash | sed s/bash//):/C/Windows/system32:$(which git | sed s/git//):$PWD/depot_tools
git clone https://webrtc.googlesource.com/src src
cd src
export DEPOT_TOOLS_WIN_TOOLCHAIN=0
gclient sync
gn gen out/x64/Debug --args="is_clang=false is_debug=true rtc_include_tests=false target_cpu=\"x64\""
cd out/x64/Debug
autoninja
ls -alR
