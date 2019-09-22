module VagrantPlugins
    module Haipa
      module Action
        class ReadState
          def initialize(app, env)
            @app = app
            @machine = env[:machine]
            @logger = Log4r::Logger.new('vagrant::haipa::read_state')
          end
  
          def call(env)
            env[:machine_state_id] = @machine.provider.driver.read_state
            @app.call(env)
          end
        end
      end
    end
  end
  