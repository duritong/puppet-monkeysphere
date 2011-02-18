class monkeysphere::sshserver inherits monkeysphere
{

  exec {"import.hostkey":
    command => "/usr/sbin/monkeysphere-host import-key /etc/ssh/ssh_host_rsa_key ssh://${fqdn} && echo Y | /usr/sbin/monkeysphere-host publish-key",
    unless => "/usr/sbin/monkeysphere-host show-key",
    user => root,
    require => [ Package[ "monkeysphere" ] ],
  }

  if $monkeysphere_has_hostkey {
    @@file { "/var/lib/puppet/modules/monkeysphere/hosts/${fqdn}":
      ensure => present,
      content => template("monkeysphere/host.erb" ),
      require => [ Package[ "monkeysphere" ] ],
      tag => 'monkeysphere-host',
    }
  }

  file { "/etc/cron.d/update-monkeysphere-auth":
    ensure => present,
    source => "puppet:///modules/monkeysphere/etc/cron.d/update-monkeysphere-auth",
    require => [ Package[ "monkeysphere" ] ],
    mode => 0644,
    owner => root,
    group => root,
  }

}
