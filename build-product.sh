#!/bin/bash

mvn_options=""

for arg in "$@"
do
	shift
	case "$arg" in
		"--skip-tests") 	mvn_options="$mvn_options -DskipTests" ;;
		*) 					echo "Unknown argument $arg"; exit 1
	esac
done

embedded_platforms=(core xatkit-chat slack discord react giphy github log)

if [ ! -d $XATKIT_DEV ]
then
	echo "XATKIT_DEV environment variable not set, please run the install script"
	exit 1
fi

cd $XATKIT_DEV

if [ -d $XATKIT_DEV/build ]
then
	rm -rf $XATKIT_DEV/build
fi

mkdir -p $XATKIT_DEV/build/plugins/platforms
mkdir -p $XATKIT_DEV/build/bin

cd $XATKIT_DEV/src/xatkit

echo "Pulling Xatkit"
git pull
echo "Building xatkit"
mvn clean install -Pbuild-product $mvn_options
mvn_result=$?
if [ $mvn_result == 0 ]
then
	echo "Copying created artifacts"
	cp core/target/xatkit-nodep-jar-with-dependencies.jar $XATKIT_DEV/build/bin
else
	echo "An error occured when building xatkit, see the maven build log"
fi

for platform in "${embedded_platforms[@]}"
do
	project_name="$platform-platform"

	cd $XATKIT_DEV/src/platforms/$project_name
	echo "Pulling $project_name"
	git pull

	echo "Building $project_name"
	mvn clean install -Pbuild-product $mvn_options
	mvn_result=$?
	if [ $mvn_result == 0 ]
	then
		echo "Copying created artifacts"
		mkdir $XATKIT_DEV/build/plugins/platforms/$platform
		cp runtime/target/$platform-runtime.jar $XATKIT_DEV/build/plugins/platforms/$platform
		cp platform/target/$platform-platform.zip $XATKIT_DEV/build/plugins/platforms/$platform
		unzip $XATKIT_DEV/build/plugins/platforms/$platform/$platform-platform.zip -d $XATKIT_DEV/build/plugins/platforms/$platform
		rm $XATKIT_DEV/build/plugins/platforms/$platform/$platform-platform.zip
	else
		echo "An error occurred when building $project_name, see the build log"
		exit 1
	fi
done

echo "Copying Xatkit scripts"
scripts=$(find $XATKIT_DEV/src/scripts -follow -maxdepth 1 \( -name '*.sh' -o -name '*.bat' \))
for script in $scripts
do
	echo "Copying $script"
	cp $script $XATKIT_DEV/build
done

bin_scripts=$(find $XATKIT_DEV/src/scripts/bin -follow -maxdepth 1 \( -name '*.sh' -o -name '*.bat' \))
for script in $bin_scripts
do
	echo "Copying $script"
	cp $script $XATKIT_DEV/build/bin
done
