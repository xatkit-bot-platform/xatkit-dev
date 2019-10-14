#!/bin/bash

embedded_platforms=(xatkit-core xatkit-chat xatkit-slack xatkit-discord xatkit-react xatkit-giphy xatkit-github xatkit-log xatkit-twitter xatkit-alexa xatkit-zapier)
embedded_libraries=(xatkit-core)
xatkit_org=https://github.com/xatkit-bot-platform

if [ -z "$XATKIT_DEV" ]
then
	echo "XATKIT_DEV environment variable not set, please run the install script"
	exit 1
fi

echo "Initializing Xatkit development environment at $XATKIT_DEV"

cd $XATKIT_DEV

if [ -d $XATKIT_DEV/src/xatkit-releases ]
then
	echo "Skipping initialization of Xatkit Releases, there is already a xatkit-releases directory in your development environment ($XATKIT_DEV/src/xatkit-releases)"
else
	cd $XATKIT_DEV/src

	echo "Cloning Xatkit Releases"
	git clone $xatkit_org/xatkit-releases.git

	if [ $? -ne 0 ]
	then
		echo "Cannot clone $xatkit_org/xatkit-releases.git"
		exit 1
	fi
fi

if [ -d $XATKIT_DEV/src/xatkit-metamodels ]
then
	echo "Skipping initialization of Xatkit Metamodels, there is already a xatkit-releases directory in your development environment ($XATKIT_DEV/src/xatkit-metamodels)"
else
	cd $XATKIT_DEV/src

	echo "Cloning Xatkit Metamodels"
	git clone $xatkit_org/xatkit-metamodels.git

	if [ $? -n 0 ]
	then 
		echo "Cannot clone $xatkit_org/xatkit-metamodels.git"
		exit 1
	fi
fi


if [ -d $XATKIT_DEV/src/xatkit-runtime ]
then
	echo "Skipping initialization of Xatkit Runtime, there is already a xatkit-runtime directory in your development environment ($XATKIT_DEV/src/xatkit-runtime)"
else
	cd $XATKIT_DEV/src

	echo "Cloning Xatkit"
	git clone $xatkit_org/xatkit-runtime.git

	if [ $? -ne 0 ]
	then
		echo "Cannot clone $xatkit_org/xatkit.git"
		exit 1
	fi
fi

if [ -d $XATKIT_DEV/src/xatkit-eclipse ]
then
	echo "Skipping initialization of Xatkit Eclipse, there is already a xatkit-eclipse directory in your development environment ($XATKIT_DEV/src/xatkit-eclipse)"
else 
	echo "Cloning Xatkit Eclipse Plugins"
	git clone $xatkit_org/xatkit-eclipse.git

	if [ $? -ne 0 ]
	then
		echo "Cannot clone $xatkit_org/xatkit-eclipse.git"
		exit 1
	fi
fi

if [ -d $XATKIT_DEV/src/xatkit-examples ]
then
	echo "Skipping initialization of Xatkit Examples, there is already a xatkit-examples directory in your development environment ($XATKIT_DEV/src/xatkit-examples)"
else
	echo "Cloning Xatkit Examples"
	git clone $xatkit_org/xatkit-examples

	if [ $? -ne 0 ]
	then
		echo "Cannot clone $xatkit_org/xatkit-examples"
		exit 1
	fi
fi

if [ ! -d $XATKIT_DEV/src/platforms ]
then
	echo "Creating $XATKIT_DEV/src/platforms directory"
	mkdir -p $XATKIT_DEV/src/platforms
fi

cd $XATKIT_DEV/src/platforms

echo "Initializing platforms"

for platform in "${embedded_platforms[@]}"
do
	project_name="$platform-platform"
	if [ -d $XATKIT_DEV/src/platforms/$project_name ]
	then
		echo "Skipping initialization of $project_name, the directory already exists"
	else 
		echo "Cloning $project_name"
		git clone $xatkit_org/$project_name.git
		if [ $? -ne 0 ]
		then
			echo "Cannot clone $xatkit_org/$project_name.git"
		fi
	fi
done

mkdir -p $XATKIT_DEV/src/libraries

cd $XATKIT_DEV/src/libraries

for library in "${embedded_libraries[@]}"
do
	project_name="$library-library"
	if [ -d $XATKIT_DEV/src/libraries/$project_name ]
	then
		echo "Skipping initialization of $project_name, the directory already exists"
	else
		echo "Cloning $project_name"
		git clone $xatkit_org/$project_name.git
		if [ $? -ne 0 ]
		then
			echo "Cannot clone $xatkit_org/$project_name.git"
		fi
	fi
done
