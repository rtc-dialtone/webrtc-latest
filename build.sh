#!/bin/bash
set -ev
uname | grep 'MSYS'
curl -L -o vs_buildtools.exe https://aka.ms/vs/15/release/vs_buildtools.exe
./vs_builtools.exe --quiet --norestart --add Microsoft.VisualStudio.Workload.NativeDesktop --add Microsoft.VisualStudio.Component.VC.ATLMFC --includeRecommended
curl -o depot_tools.zip https://storage.googleapis.com/chrome-infra/depot_tools.zip
unzip depot_tools.zip -d depot_tools
rm depot_tools.zip
export _PREV_PATH=$PATH
export PATH=$(which bash | sed s/bash//):$(which powershell | sed s/powershell//):/C/Windows/system32:$(which git | sed s/git//):$PWD/depot_tools
git clone https://webrtc.googlesource.com/src src
cd src
export DEPOT_TOOLS_WIN_TOOLCHAIN=0
export vs2017_install="C:\Program Files (x86)\Microsoft Visual Studio\2017"
gclient sync
gn gen out/x64/Debug --args="is_clang=false is_debug=true rtc_include_tests=false target_cpu=\"x64\""
cd out/x64/Debug
autoninja
ls -alR
