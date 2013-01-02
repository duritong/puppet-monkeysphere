# collect all the host keys
class monkeysphere::signer {
  include monkeysphere
  File <<| tag == 'monkeysphere-host' |>>
}
