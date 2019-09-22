module VagrantPlugins
  module Haipa
    module Action
      class StopMachine

        def initialize(app, env)
          @app = app
          @machine = env[:machine]
          @logger = Log4r::Logger.new('vagrant::haipa::stop_machine')
        end

        def call(env)
          # submit stop machine request

          env[:ui].info I18n.t('vagrant_haipa.info.stop_machine') 
          @machine.provider.driver.stop(env)

          @app.call(env)
        end
      end
    end
  end
end


