has_hostkey = false
pgp_fingerprint = ' '
pgp_id = ' '
ssh_fingerprint = ' '

if File.exist?('/usr/sbin/monkeysphere-host')

  sk = %x{/usr/sbin/monkeysphere-host show-keys}
  if $? == 0
    has_hostkey = true
    sk.lines.each do |line|
      m = line.match('^OpenPGP fingerprint:(.*)$')
      if m
        pgp_fingerprint = m[1].strip
      end
      m = line.match('^uid (.*)$')
      if m
        pgp_id = m[1].strip
      end
      m = line.match('^ssh fingerprint:(.*)$')
      if m
        ssh_fingerprint = m[1].strip
      end
    end
  end
end

Facter.add("monkeysphere_has_hostkey") do
  setcode{ has_hostkey }
end

Facter.add("monkeysphere_pgp_fp") do
  setcode{ pgp_fingerprint }
end

Facter.add("monkeysphere_pgp_id") do
  setcode{ pgp_id }
end

Facter.add("monkeysphere_ssh_fp") do
  setcode{ ssh_fingerprint }
end
