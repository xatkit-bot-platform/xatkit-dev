#!/bin/bash

embedded_platforms=(core xatkit-chat slack discord react giphy github log)
xatkit_org=https://github.com/xatkit-bot-platform

if [ -z "$XATKIT_DEV" ]
then
	echo "XATKIT_DEV environment variable not set, please run the install script"
	exit 1
fi

echo "Initializing Xatkit development environment at $XATKIT_DEV"

cd $XATKIT_DEV

if [ -d $XATKIT_DEV/src/xatkit ]
then
	echo "Cannot initialize Xatkit development toolkit, there are already a xatkit directory in your development environment ($XATKIT/src/xatkit)"
	exit 1
fi


cd $XATKIT_DEV/src

echo "Cloning Xatkit"
git clone $xatkit_org/xatkit.git

if [ $? -ne 0 ]
then
	echo "Cannot clone $xatkit_org/xatkit.git"
	exit 1
fi

if [ -d $XATKIT_DEV/src/platforms ]
then
	echo "Cannot initialize Xatkit development toolkit, there are already platform directories in your development environment ($XATKIT_DEV/src/platforms)"
	exit 1
fi

mkdir -p $XATKIT_DEV/src/platforms

cd $XATKIT_DEV/src/platforms

for platform in "${embedded_platforms[@]}"
do
	project_name="$platform-platform"
	echo "Cloning $project_name"
	git clone $xatkit_org/$project_name.git
	if [ $? -ne 0 ]
	then
		echo "Cannot clone $xatkit_org/$project_name.git"
	fi
done
