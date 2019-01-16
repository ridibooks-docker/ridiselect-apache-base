# ridiselect-apache-base
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- Install [Blackfire](https://blackfire.io) for profiling

## [2.0.3] - 2018-12-28
### Changed
- Disable other-vhosts-access-log.conf
- Remove PID files pre-existing when container starts

## [2.0.2] - 2018-12-28
### Changed
- Set symbolic links to stdout and stderr for Apache log files

## [2.0.1] - 2018-12-20
### Fixed
- Set missing default value of XDebug remote host

## [2.0] - 2018-12-19
### Changed
- Update PHP to 7.2
- Update the base image to ubuntu:bionic

### Removed
- Removed following PHP extentions
    - apcu
    - bcmath
    - mcrypt
    - xml
    - zip
