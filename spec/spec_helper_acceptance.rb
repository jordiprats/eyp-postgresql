require 'beaker-rspec'
require 'tmpdir'
require 'yaml'
require 'simp/beaker_helpers'
include Simp::BeakerHelpers

hosts.each do |host|
  # Install Puppet
  install_puppet
end

RSpec.configure do |c|
  module_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  module_name = module_root.split('-').last

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(:source => module_root, :module_name => module_name)
    hosts.each do |host|
      on host, puppet('module', 'install', 'puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'puppetlabs-concat'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'eyp-eyplib'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'eyp-python'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'eyp-apt'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'eyp-nrpe'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'eyp-systemd'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'eyp-lvm'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'eyp-epel'), { :acceptable_exit_codes => [0,1] }
    end
  end
end
