class monkeysphere::debian {

case $lsbdistcodename {
        lenny: {
          if $monkeysphere_ensure_version == ''
          {
            $monkeysphere_ensure_version = '1.4.10-2~bpo50+1'
          }

          if $gnupg_ensure_version == ''
          {
            $gnupg_ensure_version = '0.31-3~bpo50+1'
          }
        }
    }
}
