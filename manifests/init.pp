# This module is distributed under the GNU Affero General Public License:
# 
# Monkeysphere module for puppet
# Copyright (C) 2009 Sarava Group
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
# 
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

#
# Class for monkeysphere management
#
class monkeysphere {
  # The needed packages
  package { monkeysphere: ensure => installed, }

  $ssh_port = $monkeysphere_ssh_port ? {
    ''      => '',
    default => ":$monkeysphere_ssh_port",
  }

  $key = "ssh://${fqdn}{$ssh_port}"

  # Server host key publication
  case $monkeysphere_publish_key {
    false: {
             exec { "/usr/sbin/monkeysphere-host import-key /etc/ssh/ssh_host_rsa_key $key":
               unless  => "/usr/bin/gpg --homedir /var/lib/monkeysphere/host --list-keys '=$key' &> /dev/null",
               user    => "root",
               require => Package["monkeysphere"],
             }
           }
    default: {
            exec { "/usr/sbin/monkeysphere-host import-key /etc/ssh/ssh_host_rsa_key $key && \
                    /usr/sbin/monkeysphere-host publish-key":
              unless  => "/usr/bin/gpg --homedir /var/lib/monkeysphere/host --list-keys '=$key' &> /dev/null",
              user    => "root",
              require => Package["monkeysphere"],
            }
          }
  }
}
