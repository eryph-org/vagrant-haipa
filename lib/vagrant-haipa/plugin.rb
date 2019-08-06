module VagrantPlugins
  module Haipa
    class Plugin < Vagrant.plugin("2")
      name "Haipa provider"
      description <<-DESC
      This plugin installs a provider that allows Vagrant to manage
      machines in Haipa.
      DESC
    end
  end
end
    