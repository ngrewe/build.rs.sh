#!/bin/sh -eu
BASEDIR=$(dirname "$0")
: ${BUILD_RS_IMAGE:="ngrewe/build.rs:latest"}
if [ "$#" -eq 0 ]; then
	SRC=`pwd`
else
	SRC=$1
	shift
fi
if [ "$#" -eq 0 ]; then
	DEST=$SRC/out
else
	DEST=$1
	shift
fi
if [ ! -d "$SRC" ]; then
	echo "Source directory $SRC does not exist";
	exit 1;
fi
SRC=`realpath $SRC`
mkdir -p $DEST
DEST=`realpath $DEST`
PERM=`stat -c%a $DEST`
chmod o+rwx $DEST
trap 'chmod $PERM $DEST' EXIT
echo "Building rust project at $SRC";
echo "Artifacts will be placed in $DEST";
echo -e "\e[91mWarn: $DEST will be world-readable during the build.\e[39m";
docker pull $BUILD_RS_IMAGE
docker run --rm -v $SRC/:/rust:ro -v$DEST/:/target:z $BUILD_RS_IMAGE "$@"
