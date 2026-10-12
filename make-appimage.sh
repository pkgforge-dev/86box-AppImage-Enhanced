#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=https://raw.githubusercontent.com/86Box/86Box/refs/heads/master/src/unix/assets/256x256/net.86box.86Box.png
export DESKTOP=https://raw.githubusercontent.com/86Box/86Box/refs/heads/master/src/unix/assets/net.86box.86Box.desktop
export STARTUPWMCLASS=net.86box.86Box

# Deploy dependencies
quick-sharun /usr/bin/86Box

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --simple-test ./dist/*.AppImage
