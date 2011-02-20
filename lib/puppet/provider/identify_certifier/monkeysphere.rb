##


require 'puppet/provider/package'
require "open3"

Puppet::Type.type(:identity_certifier).provide(:monkeysphere,
                                               :parent => Puppet::Provider::Package) do

  commands :monkeysphereauth => "/usr/sbin/monkeysphere-authentication"

  desc "asdf"
  
  # retrieve the current set of mysql users
  def self.instances
    ids = []

    cmd = "#{command(:monkeysphereauth)} list-id-certifiers"
    execpipe(cmd) do |process|
      process.each do |line|
        m = line.match( "^[0-9A-Z]{32}([0-9A-Z]{8}):" )
        if m
          ids << new( { :ensure => :present, :pgpid => m.group(1) } )
        end
      end
    end
    return ids
  end

  def create
    Open3.popen3("monkeysphere-authentication add-id-certifier #{resource[:pgpid]}") do |i, o, e|
      i.puts( "Y" )
      o.readlines()
    end
  end
  
  def destroy
    Open3.popen3("monkeysphere-authentication remove-id-certifier #{resource[:pgpid]}") do |i, o, e|
      i.puts( "Y" )
      o.readlines()
    end
  end
  
  def exists?

    cil = %x{/usr/sbin/monkeysphere-authentication list-id-certifiers}
    if $? == 0
      cil.lines.each do |line|
        m = line.match( '^[0-9A-Z]*' + resource[:pgpid] + ':' )
        if m
          return true
        end
      end
    end
    return false
  end
end
