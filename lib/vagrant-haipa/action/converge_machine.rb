module VagrantPlugins
  module Haipa
    module Action
      class ConvergeMachine

        def initialize(app, env)
          @app = app
          @machine = env[:machine]
          @logger = Log4r::Logger.new('vagrant::haipa::converge_machine')
        end

        def call(env)        

          # terminate only if machine has been created by this action
          if @machine.id.nil?
            env[:converge_cleanup] = true
          end

          operation_result = @machine.provider.driver.converge(env)                  
          @machine.id = operation_result.machine_guid if @machine.id.nil?
          

          @app.call(env)
        end

        def recover(env)
          return if env['vagrant.error'].is_a?(Vagrant::Errors::VagrantError)
          terminate(env) if @machine.state.id != :not_created && env[:converge_cleanup] == true
        end

        def terminate(env)
          destroy_env = env.dup
          destroy_env.delete(:interrupted)
          destroy_env[:config_validate] = false
          destroy_env[:force_confirm_destroy] = true
          env[:action_runner].run(Action.action_destroy, destroy_env)
        end
      end
    end
  end
end
