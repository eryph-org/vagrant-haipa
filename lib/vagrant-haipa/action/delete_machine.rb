module VagrantPlugins
  module Haipa
    module Action
      class DeleteMachine
        def initialize(app, env)
          @app = app
          @machine = env[:machine]
          @logger = Log4r::Logger.new('vagrant::haipa::delete_Machine')
        end

        def call(env)
          # submit delete machine request
          env[:ui].info I18n.t('vagrant_haipa.info.destroying')
          operation_result = @machine.provider.driver.delete(env)

          # set the machine id to nil to cleanup local vagrant state
          @machine.id = nil

          @app.call(env)
        end
      end
    end
  end
end
