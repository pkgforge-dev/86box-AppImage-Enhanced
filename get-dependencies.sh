#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    cmake          \
    fluidsynth     \
    kvantum        \
    libserialport  \
    libslirp       \
    lxqt-qtplugin  \
	ninja		   \
    openal         \
	pipewire-audio \
    pipewire-jack  \
    qt6ct          \
    rtmidi         \
    sdl2-compat    \
    vde2           \
    vulkan-headers

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano libdecor-mini

#if [ "${DEVEL_RELEASE-}" = 1 ]; then
#    make-aur-package 86box-roms-git
#    package=86box-git
#else
#    make-aur-package 86box-roms
#    package=86box
#fi
#make-aur-package $package
#pacman -Q "$package" | awk '{print $2; exit}' > ~/version
echo "Getting roms and assets..."
echo "---------------------------------------------------------------"
git clone --depth 1 https://github.com/86Box/roms ./roms
git clone --depth 1 https://github.com/86Box/assets ./assets

mkdir -p /usr/share/86Box/roms
mkdir -p /usr/share/86Box/assets
mv -v ./roms/[a-z]* /usr/share/86Box/roms
mv -v ./assets/sounds /usr/share/86Box/assets

echo "Building 86box..."
echo "---------------------------------------------------------------"
REPO="https://github.com/86Box/86Box"
if [ "${DEVEL_RELEASE-}" = 1 ]; then
    echo "Making nightly build of 86box..."
    echo "---------------------------------------------------------------"
    VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
    git clone --depth 1 "$REPO" ./86Box
else
	echo "Making stable build of 86box..."
	VERSION="$(git ls-remote --tags --sort="v:refname" "$REPO" | tail -n1 | sed 's/.*\///; s/\^{}//; s/^v//')"
	git clone --branch v"$VERSION" --single-branch --depth 1 "$REPO" ./86Box
fi
echo "$VERSION" > ~/version

cmake -S ./86Box -B build --preset regular -DCMAKE_INSTALL_PREFIX=/usr -DUSE_QT6=on
cmake --build build -j$(nproc)
cmake --install build

