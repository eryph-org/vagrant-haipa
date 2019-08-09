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

          name = env[:generated_name]
          unless @machine.id.nil?
            haipa_machine = @machine.provider.driver.machine
            name = haipa_machine.name
          end
          
          operation_result = @machine.provider.driver.converge(env, name)                  
          @machine.id = operation_result.machine_guid if @machine.id.nil?
          

          @app.call(env)
        end

        # Both the recover and terminate are stolen almost verbatim from
        # the Vagrant AWS provider up action
        def recover(env)
          return if env['vagrant.error'].is_a?(Vagrant::Errors::VagrantError)
          terminate(env) if @machine.state.id != :not_created
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
