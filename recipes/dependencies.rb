#
# Cookbook Name:: owi-oracle-server
# Recipe:: dependencies
#
# Description:: Install needed packages to support Oracle server
#

package 'compat-libcap1'

package 'compat-libstdc++-33'

package 'libstdc++-devel'

package 'gcc-c++'

package 'libaio-devel'
