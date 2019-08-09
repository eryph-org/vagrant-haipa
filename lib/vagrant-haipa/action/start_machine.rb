module VagrantPlugins
  module Haipa
    module Action
      class StartMachine
        def initialize(app, env)
          @app = app
          @machine = env[:machine]
          @logger = Log4r::Logger.new('vagrant::haipa::start_machine')
        end

        def call(env)
          # submit start machine request

          env[:ui].info I18n.t('vagrant_haipa.info.start_machine') 
          @machine.provider.driver.start(env)

          @app.call(env)
        end
      end
    end
  end
end


