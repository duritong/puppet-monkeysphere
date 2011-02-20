Puppet::Type.newtype(:identity_certifier) do
  @doc = "Manage monkeysphere identity-certifiers"
  
  ensurable
  newparam(:pgpid) do
    desc "The pgp id of the certifier"
    isnamevar
  end

end
