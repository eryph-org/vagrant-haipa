module VagrantPlugins
  module Haipa
    class Config < Vagrant.plugin('2', :config)
      attr_accessor :name

      attr_accessor :vm_config
      attr_accessor :provision      
      
      attr_accessor :client_id
      attr_accessor :client_key_file
      attr_accessor :identity_endpoint
      attr_accessor :api_endpoint


      def initialize
 
        @name               = UNSET_VALUE
        @vm_config          = UNSET_VALUE
        @provision          = UNSET_VALUE

        @client_id          = UNSET_VALUE
        @client_key_file    = UNSET_VALUE
        @identity_endpoint  = UNSET_VALUE
        @api_endpoint       = UNSET_VALUE
      end

      def finalize!
        @name               = nil if @name == UNSET_VALUE
        @vm_config          = [] if @vm_config == UNSET_VALUE
        @provision          = [] if @provision == UNSET_VALUE

        @client_id          = nil if @client_id == UNSET_VALUE
        @client_key_file    = nil if @client_key_file == UNSET_VALUE
        @identity_endpoint  = nil if @identity_endpoint == UNSET_VALUE
        @api_endpoint       = nil if @api_endpoint == UNSET_VALUE     
      end

      def validate(machine)
        errors = []
        #errors << I18n.t('vagrant_haipa.config.token') if !@token

        key = machine.config.ssh.private_key_path
        key = key[0] if key.is_a?(Array)
#        if !key
#          errors << I18n.t('vagrant_haipa.config.private_key')
#        elsif !File.file?(File.expand_path("#{key}.pub", machine.env.root_path))
#          errors << I18n.t('vagrant_haipa.config.public_key', {
#            :key => "#{key}.pub"
#          })
       # end

        { 'Haipa Provider' => errors }
      end
    end
  end
end
