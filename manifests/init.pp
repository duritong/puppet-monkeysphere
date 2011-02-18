# monkeysphere module
class monkeysphere {
  module_dir { [ "monkeysphere", "monkeysphere/hosts", "monkeysphere/plugins" ]: }

    case $operatingsystem {
        debian: { include monkeysphere::debian }
    }

    if $monkeysphere_ensure_version == ''
    {
      $monkeysphere_ensure_version = 'installed'
    }

    if $gnupg_ensure_version == ''
    {
      $gnupg_ensure_version = 'installed'
    }

  package {"gnupg": ensure => $gnupg_ensure_version, }
  package {"monkeysphere": ensure => $monkeysphere_ensure_version, require => [ Package["gnupg"] ] }

}
