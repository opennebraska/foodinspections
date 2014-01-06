#!/bin/bash
echo "Installing Puppet"
wget --quiet --tries=5 --timeout=10 -O "/tmp/puppetlabs.deb" "http://apt.puppetlabs.com/puppetlabs-release-wheezy.deb"
dpkg -i "/tmp/puppetlabs.deb" >/dev/null
apt-get update >/dev/null
apt-get -y install puppet >/dev/null
PUPPET_VERSION=$(puppet help | grep 'Puppet v')
echo "Finished updating puppet to latest version: $PUPPET_VERSION"