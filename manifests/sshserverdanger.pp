# use this to authenticate with monkeysphere on ssh
# you should not manage the sshd config as a whole
# or at least put there the same key.
class monkeysphere::sshserverdanger {
  include monkeysphere::sshserver
  augeas{'sshd_config':
    context => '/files/etc/ssh/sshd_config',
    changes => [ 'set AuthorizedKeysFile /var/lib/monkeysphere/authorized_keys/%u' ],
    notify  => Service['ssh'],
  }
}
