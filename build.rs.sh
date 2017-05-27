#!/bin/sh -eu

# This is the outer build script, which spawns the actual build job in the container.

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
BUILDER_UID=`id -u`
BUILDER_GID=`id -g`
echo "Building rust project at $SRC";
echo "Artifacts will be placed in $DEST";
# docker pull $BUILD_RS_IMAGE
docker run --rm --user $BUILDER_UID:$BUILDER_GID -v $SRC/:/rust:ro -v$DEST/:/target:z $BUILD_RS_IMAGE "$@"
