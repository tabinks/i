#!/bin/sh
PLIST_BUDDY="/usr/libexec/PlistBuddy"
PROJECT_DIR="./"

git add ./;git commit -m "Update"

# Clean up all the old zips because the changes are addiditive
echo "REMOVING OLD ZIPS..."
rm -rf Issue0.zip Issue1.zip

# Zin them without the top level directory
echo "CREATING NEW ZIPS..."
zip -j Issue0.zip Issue0/*
zip -j Issue1.zip Issue1/*

################################################################################
# Update the overall version number for a quick check of status
FULL_VERSION=$(git describe --always --dirty | sed -e 's/^v//' -e 's/g//')
$PLIST_BUDDY -c "Set :FullVersion ${FULL_VERSION}" Issues.plist

SHORT_VERSION=$(git describe --always --abbrev=0)
$PLIST_BUDDY -c "Set :ShortVersion ${SHORT_VERSION}" Issues.plist

VERSION=$(git rev-list master | wc -l)
$PLIST_BUDDY -c "Set :Version ${VERSION}" Issues.plist

################################################################################
# Update the issue versions
VERSION=$(git log Issue0 | grep commit | wc -l)
$PLIST_BUDDY -c "Set :Issues:0:Version ${VERSION}" Issues.plist

VERSION=$(git log Issue1 | grep commit | wc -l)
$PLIST_BUDDY -c "Set :Issues:1:Version ${VERSION}" Issues.plist

# Push the plist
git add ./;git commit -m "Update after plists"; git push 

#
cp Issue0.zip /Users/tbinkowski/Dropbox/Public/