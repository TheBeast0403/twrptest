#!/bin/bash
echo Starting script
cd $HOME && mkdir twrp3
git config --global user.name "The Beast"
git config --global user.email "t.beast0403@gmail.com"
git config --global color.ui false

echo Setting up repo
mkdir -p ~/.bin
PATH="${HOME}/.bin:${PATH}"
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/.bin/repo
chmod a+rx ~/.bin/repo

echo Initializing repo
cd ~/twrp3
repo init --depth=1 -u git://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git -b twrp-11

echo Syncing sources
repo sync -f --force-sync -c --no-clone-bundle --no-tags -j2 >log 2>&1

echo Cloning device tree
git clone --branch device-tree https://github.com/TheBeast0403/twrp_device_Nokia_2_2.git device/hmd/WSP_sprout

echo Preparing for build
source build/envsetup.sh
lunch omni_WSP_sprout-eng

echo Building
mka bootimage

echo ninja test
cd $HOME/twrp3/out/soong/
ninja

echo test
cd $HOME/twrp3/out/target/product/WSP_sprout && tree
mkdir ~/yml
cd ~/yml && zip -r files.zip $HOME/twrp3/out/target/product/WSP_sprout
curl --upload-file files.zip https://transfer.sh/ && echo ""
