# This module is distributed under the GNU Affero General Public License:
#
# Monkeysphere module for puppet
# Copyright (C) 2009-2010 Sarava Group
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
class monkeysphere(
  $ssh_port       = '',
  $publish_key    = false,
  $ensure_version = 'installed'
) {
  # The needed packages
  package{'monkeysphere':
    ensure => $ensure_version,
  }

  $port = $monkeysphere::ssh_port ? {
    ''      => '',
    default => ":${monkeysphere::ssh_port}",
  }

  $key = "ssh://${::fqdn}${port}"

  common::module_dir { [ 'monkeysphere', 'monkeysphere/hosts', 'monkeysphere/plugins' ]: }
  file {
    '/usr/local/sbin/monkeysphere-check-key':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0755',
      content => "#!/bin/bash\n/usr/bin/gpg --homedir /var/lib/monkeysphere/host --list-keys '=${key}' &> /dev/null || false",
  }

  # Server host key publication
  Exec{
    unless  => '/usr/local/sbin/monkeysphere-check-key',
    user    => 'root',
    require => [ Package['monkeysphere'], File['/usr/local/sbin/monkeysphere-check-key'] ],
  }
  case $monkeysphere::publish_key {
    false: {
      exec { "/usr/sbin/monkeysphere-host import-key /etc/ssh/ssh_host_rsa_key ${key}": }
    }
    'mail': {
      $mail_loc = $::operatingsystem ? {
        'centos' => '/bin/mail',
        default => '/usr/bin/mail',
      }
      exec { "/usr/sbin/monkeysphere-host import-key /etc/ssh/ssh_host_rsa_key ${key} && \
          ${mail_loc} -s 'monkeysphere host pgp key for ${::fqdn}' root < /var/lib/monkeysphere/host_keys.pub.pgp":
      }
    }
    default: {
      exec { "/usr/sbin/monkeysphere-host import-key /etc/ssh/ssh_host_rsa_key ${key} && \
          echo Y | /usr/sbin/monkeysphere-host publish-key":
      }
    }
  }
}
