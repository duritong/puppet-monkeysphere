class monkeysphere::sshserverdanger  inherits monkeysphere::sshserver 
{
  augeas { "sshd_config":
    context => "/files/etc/ssh/sshd_config",
    changes => [
                "set AuthorizedKeysFile /var/lib/monkeysphere/authorized_keys/%u"
                ],
    notify => Service[ "ssh" ],
  }

}
