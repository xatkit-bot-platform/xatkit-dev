#!/bin/bash

mvn_options=""
build_product=false
build_eclipse=false

for arg in "$@"
do
	shift
	case "$arg" in
		"--skip-tests") 	mvn_options="$mvn_options -DskipTests" ;;
		"--product")		mvn_options="$mvn_options -Pbuild-product"; build_product=true ;;
		"--eclipse")		build_eclipse=true;;
		*) 					echo "Unknown argument $arg"; exit 1
	esac
done

if [ ! -d $XATKIT_DEV ]
then
	echo "XATKIT_DEV environment variable not set, please run the install script"
	exit 1
fi

cd $XATKIT_DEV

if [ $build_product = true ]
then
	if [ -d $XATKIT_DEV/build ]
	then
		rm -rf $XATKIT_DEV/build
	fi

	mkdir -p $XATKIT_DEV/build/plugins/platforms
	mkdir -p $XATKIT_DEV/build/bin
fi

cd $XATKIT_DEV/src/xatkit

echo "Pulling Xatkit"
git pull
echo "Building Xatkit"
mvn clean install $mvn_options
mvn_result=$?
if [ $mvn_result == 0 ]
then
	if [ $build_product = true ]
	then
		echo "Copying created artifacts"
		cp core/target/xatkit-nodep-jar-with-dependencies.jar $XATKIT_DEV/build/bin
	fi
else
	echo "An error occurred when building xatkit, see the maven build log"
	exit 1
fi

if [ $build_eclipse = true ]
then
	if [ -d $XATKIT_DEV/update-site ]
	then
		rm -rf $XATKIT_DEV/update-site
	fi

	mkdir -p $XATKIT_DEV/update-site

	cd $XATKIT_DEV/src/xatkit/eclipse
	echo "Building Xatkit Eclipse Plugins"
	mvn clean install $mvn_options
	mvn_result=$?
	if [ $mvn_result == 0 ]
	then
		echo "Copying update site"
		cp update/com.xatkit.update/target/com.xatkit.update-2.0.0-SNAPSHOT.zip $XATKIT_DEV/update-site
	else
		echo "An error occurred wen building Xatkit Eclipse Plugins, see the maven build log"
		exit 1
	fi
fi

cd $XATKIT_DEV/src/platforms

embedded_platforms=$(ls -d */)

for platform in $embedded_platforms
do
	platform_name=${platform%"-platform/"}

	cd $XATKIT_DEV/src/platforms/$platform
	echo "Pulling $platform"
	git pull

	echo "Building $platform"
	mvn clean install $mvn_options
	mvn_result=$?
	if [ $mvn_result == 0 ]
	then
		if [ $build_product = true ]
		then
			echo "Copying created artifacts"
			mkdir $XATKIT_DEV/build/plugins/platforms/$platform_name
			cp runtime/target/$platform_name-runtime.jar $XATKIT_DEV/build/plugins/platforms/$platform_name
			cp platform/target/$platform_name-platform.zip $XATKIT_DEV/build/plugins/platforms/$platform_name
			unzip $XATKIT_DEV/build/plugins/platforms/$platform_name/$platform_name-platform.zip -d $XATKIT_DEV/build/plugins/platforms/$platform_name
			rm $XATKIT_DEV/build/plugins/platforms/$platform_name/$platform_name-platform.zip
		fi
	else
		echo "An error occurred when building $platform, see the maven build log"
		exit 1
	fi
done

if [ $build_product = true ]
then
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
fi
