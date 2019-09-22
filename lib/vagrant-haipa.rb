require 'vagrant-haipa/version'
require 'vagrant-haipa/plugin'
require 'vagrant-haipa/errors'
require 'vagrant-haipa/driver'

module VagrantPlugins
  module Haipa
    OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
 
    lib_path = Pathname.new(File.expand_path("../vagrant-haipa", __FILE__))
    autoload :Action, lib_path.join("action")
    autoload :Errors, lib_path.join("errors")

    # This returns the path to the source of this plugin.
    #
    # @return [Pathname]
    def self.source_root
      @source_root ||= Pathname.new(File.expand_path("../../", __FILE__))
    end

    I18n.load_path << File.expand_path('locales/en.yml', source_root)
    I18n.reload!
  end
end
