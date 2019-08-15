# Xatkit Development Toolkit
The Xatkit Development Toolkit (XDK) aims to ease the installation and development of Xatkit core components, eclipse plugins, and platforms.

# Requirements

**All systems**

- [JDK 8](https://www.java.com/en/download/). XDK requires a JDK to compile the different Xatkit components. Note that the Xatkit engine itself only requires a JRE to run and deploy bots.
- Git
- [Maven](https://maven.apache.org/)
- *(Optional)* Eclipse Modeling Tools to install and edit Xatkit bots. Xatkit is developed on [Eclipse Modeling 4.11](https://www.eclipse.org/downloads/packages/release/2019-03/r/eclipse-modeling-tools).

**Windows**

- A bash interpreter (we recommend the one bundled with [Git for Windows](https://gitforwindows.org/))

The XDK is also tested on *Ubuntu 18.04.2*, other Linux distributions are not officially supported.

# Installation

1- Clone this repository

```bash
git clone https://github.com/xatkit-dev.git
```

2- Setup the environment variables

**Windows**

Execute `xatkit-dev/install-windows.bat` with administrative rights.

**Ubuntu**

Execute `xatkit-dev/install-linux.sh`

*XDK Tip: check your environment variables on Windows*

> Open your bash interpreter and check that `echo $XATKIT_DEV` prints the path of the `xatkit-dev` directory. If the printed value is empty you need to close your interpreter and open it again, the newly created environment variables will be reloaded.

3- Navigate to the xatkit-dev folder and clone the Xatkit repositories

```bash
./init.sh
```

This command will clone several Git repositories under the `xatkit-dev/src` directory:

- `src/xatkit-runtime`: the Xatkit execution engine
- `src/xatkit-eclipse`: the Xatkit Eclipse-based editors
- `src/platforms/*`: the Xatkit platforms bundled with the base distribution

Each Git repository contains a maven project that can be imported in your preferred IDE.

4- Build Xatkit projects

```bash
./build.sh --runtime --eclipse --platforms --skip-tests --product
```

The `build.sh` command provides several options that allows to build part of Xatkit:

- `--runtime`: build `xatkit-runtime`
- `--eclipse`: build `xatkit-eclipse`
- `--platforms`: build all the platforms located in `xatkit-dev/src/platforms` (including custom platforms created from scratch, and platforms not bundled with the base distribution)
- `--platform=<platform directory name>`: build the `<platform directory name>` platform. The provided name must match exactly the name of the platform directory located in `xatkit-dev/src/platforms`
- `--skip-tests`: skip the test execution (similar to maven's `-DskipTests`)
- `--product`: create a *product* version of the bundled artifacts. This option installs the built platforms in `xatkit-dev/build/plugins`, allowing the runtime component to use them. Installed platforms can also be imported in the Eclipse editors.

*XDK Tip: rebuild single platforms*

>Rebuilding a single platform can be done with `./build.sh --platform=<platform directory name> --product`. Your `xatkit-dev/build` directory will be updated with the latest version of the built platform.

After a few minutes, this command creates two directories:

- `xatkit-dev/build`: contains the built artifacts (if `--product` has been specified). The content of this directory is a fully working Xatkit installation (similar to the released bundles available [here](https://github.com/xatkit-bot-platform/xatkit-releases/releases)).
- `xatkit-dev/update-site`: contains a zipped update-site that can be used to install the Xatkit editors in Eclipse (if `--eclipse` has been specified)

5- Setup the local build environment variable

Navigate to `xatkit-dev/build` and setup the environment variable for your local Xatkit build. This variable is used to run bots and resolve platform/libraries imports in the Xatkit Eclipse Plugins.

**Windows**

Execute `install-windows.bat` with administrative rights.

**Ubuntu**

Execute `install-linux.sh`.

*XDK Tip: restart running Eclipse instances*

> You need to restart your Eclipse instance before installing the Xatkit Eclipse Plugins to reload the defined environment variable.

6- Install the update-site in Eclipse

`Help > Install New Software > Add > Archive` and select the zipped update site located in `xatkit-dev/update-site`.

![Eclipse Install Dialog](https://raw.githubusercontent.com/wiki/xatkit-bot-platform/xatkit-dev/img/install-eclipse.png)

