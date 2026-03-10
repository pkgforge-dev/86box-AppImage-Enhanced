#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    libdecor \
    qt6-base \
    sdl2

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

# If the application needs to be manually built that has to be done down here
if [ "${DEVEL_RELEASE-}" = 1 ]; then
 	make-aur-package 86box-roms-git
    package=86box-git
    make-aur-package $package
else
 	make-aur-package 86box-roms
    package=86box
    make-aur-package $package
fi
pacman -Q "$package" | awk '{print $2; exit}' > ~/version
