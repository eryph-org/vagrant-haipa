module VagrantPlugins
    module Haipa
      module Action
        class IsRunning
          def initialize(app, env)
            @app = app
            @machine = env[:machine]
            @logger = Log4r::Logger.new('vagrant::haipa::is_running')
          end
  
          def call(env)
            state = env[:machine].state
            env[:result] = state.id == 'Running'
            @app.call(env)
          end
        end
      end
    end
  end
  