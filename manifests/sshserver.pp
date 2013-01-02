# include to export your ssh key
class monkeysphere::sshserver {
  include monkeysphere
  if $::monkeysphere_has_hostkey {
    @@file { "/var/lib/puppet/modules/monkeysphere/hosts/${::fqdn}":
      ensure  => present,
      content => template('monkeysphere/host.erb'),
      require => Package['monkeysphere'],
      tag     => 'monkeysphere-host',
    }
  }

  file{'/etc/cron.d/update-monkeysphere-auth':
    ensure  => present,
    source  => 'puppet:///modules/monkeysphere/etc/cron.d/update-monkeysphere-auth',
    require => Package['monkeysphere'],
    mode    => '0644',
    owner   => root,
    group   => root,
  }
}
