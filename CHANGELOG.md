# OWI Oracle Server CHANGELOG

## 0.0.9
- [isuftin@usgs.gov] - Add recipe to update the /etc/default/useradd file
- [isuftin@usgs.gov] - Add recipe to mount an external filesystem

## 0.0.8
- [isuftin@usgs.gov] - Rubocop fixes
- [isuftin@usgs.gov] - Created a recipe that installs only the Oracle client
- [isuftin@usgs.gov] - Updated Kitchen to use CentOS 6.8

## 0.0.7
- [isuftin@usgs.gov] - Making sure execute block fires

## 0.0.6
- [isuftin@usgs.gov] - Fix directory permissions for Oracle base

## 0.0.5
- [isuftin@usgs.gov] - No longer expiring the oracle account

## 0.0.4
- [isuftin@usgs.gov] - Switched Oracle user from being a system account to allow AD login

## 0.0.3
- [isuftin@usgs.gov] - Updated the timeout on long running commands
- [isuftin@usgs.gov] - Updated the README to reflect current state of cookbook
- [isuftin@usgs.gov] - Updated test coverage for Serverspec and Chefspec

## 0.0.2
- [isuftin@usgs.gov] - Fixed a copy flag which broke under certain circumstances
- [isuftin@usgs.gov] - Added start/stop scripting as well as fixed up installation issues

## 0.0.1
- [isuftin@usgs.gov] - Initial release of owi-oracle-server
