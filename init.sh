#!/bin/bash

embedded_platforms=(xatkit-core xatkit-chat xatkit-slack xatkit-discord xatkit-react xatkit-giphy xatkit-github xatkit-log)
embedded_libraries=(xatkit-core)
xatkit_org=https://github.com/xatkit-bot-platform

if [ -z "$XATKIT_DEV" ]
then
	echo "XATKIT_DEV environment variable not set, please run the install script"
	exit 1
fi

echo "Initializing Xatkit development environment at $XATKIT_DEV"

cd $XATKIT_DEV

if [ -d $XATKIT_DEV/src/xatkit-runtime ]
then
	echo "Cannot initialize Xatkit development toolkit, there are already a xatkit-runtime directory in your development environment ($XATKIT/src/xatkit-runtime)"
	exit 1
fi

cd $XATKIT_DEV/src

echo "Cloning Xatkit"
git clone $xatkit_org/xatkit-runtime.git

if [ $? -ne 0 ]
then
	echo "Cannot clone $xatkit_org/xatkit.git"
	exit 1
fi

if [ -d $XATKIT_DEV/src/xatkit-eclipse ]
then
	echo "Cannot initialize Xatkit development toolkit, there are already a xatkit-eclipse directory in your development environment ($XATKIT/src/xatkit-eclipse)"
	exit 1
fi

echo "Cloning Xatkit Eclipse Plugins"
git clone $xatkit_org/xatkit-eclipse.git

if [ $? -ne 0 ]
then
	echo "Cannot clone $xatkit_org/xatkit-eclipse.git"
	exit 1
fi

if [ -d $XATKIT_DEV/src/platforms ]
then
	echo "Cannot initialize Xatkit development toolkit, there are already platform directories in your development environment ($XATKIT_DEV/src/platforms)"
	exit 1
fi

echo "Cloning Xatkit Examples"
git clone $xatkit_org/xatkit-examples

if [ $? -ne 0 ]
then
	echo "Cannot clone $xatkit_org/xatkit-examples"
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

mkdir -p $XATKIT_DEV/src/libraries

cd $XATKIT_DEV/src/libraries

for library in "${embedded_libraries[@]}"
do
	project_name="$library-library"
	echo "Cloning $project_name"
	git clone $xatkit_org/$project_name.git
	if [ $? -ne 0 ]
	then
		echo "Cannot clone $xatkit_org/$project_name.git"
	fi
done
