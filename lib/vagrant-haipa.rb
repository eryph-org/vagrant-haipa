require 'vagrant-haipa/version'
require 'vagrant-haipa/plugin'
require 'vagrant-haipa/errors'
require 'vagrant-haipa/driver'
require 'vagrant-haipa/provider'

module VagrantPlugins
  module Haipa
    lib_path = Pathname.new(File.expand_path("../vagrant-haipa", __FILE__))
    autoload :Action, lib_path.join("action")
    autoload :Errors, lib_path.join("errors")

    # This returns the path to the source of this plugin.
    #
    # @return [Pathname]
    def self.source_root
      @source_root ||= Pathname.new(File.expand_path("../../", __FILE__))
    end
  end
end
