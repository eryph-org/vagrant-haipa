module VagrantPlugins
  module Haipa
    class HaipaError < Vagrant::Errors::VagrantError
      error_namespace("vagrant_haipa.errors")
    end

  end
end
    