#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    kvantum       \
    libdecor      \
    lxqt-qtplugin \
    qt6-base      \
    qt6ct         \
    sdl2

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# If the application needs to be manually built that has to be done down here
if [ "${DEVEL_RELEASE-}" = 1 ]; then
    make-aur-package 86box-roms-git
    package=86box-git
else
    make-aur-package 86box-roms
    package=86box
fi
make-aur-package $package
pacman -Q "$package" | awk '{print $2; exit}' > ~/version
