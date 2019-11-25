# Changelog

All notable changes for the Xatkit Development Toolkit (XDK) will be documented in this file.

Note that there is no changelog available for the initial release of the XDK (1.0.0), you can find the release notes [here](https://github.com/xatkit-bot-platform/xatkit-dev/releases).

The changelog format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/v2.0.0.html)

## Unreleased

### Changed

- Eclipse plugins are now built before the runtime component. The runtime component now loads execution models using their `.execution` file. This implies to first build the eclipse plugins to  make sure that the latest versions of the parsers is used to resolve runtime's dependencies.

### Fixed

- `rm` error messages ([#8]( https://github.com/xatkit-bot-platform/xatkit-dev/issues/8 )) and `export` command not executed ([#10]( https://github.com/xatkit-bot-platform/xatkit-dev/issues/10 )) in *xatkit-install-linux.sh* (thanks [@abelgomez]( https://github.com/abelgomez) for your [pull request](https://github.com/xatkit-bot-platform/xatkit-dev/pull/11)!)

## [1.0.0] - 2019-10-09 

See the release notes [here](https://github.com/xatkit-bot-platform/xatkit-dev/releases).

