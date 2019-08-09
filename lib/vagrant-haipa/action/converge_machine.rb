module VagrantPlugins
  module Haipa
    module Action
      class ConvergeMachine

        def initialize(app, env)
          @app = app
          @machine = env[:machine]
          @logger = Log4r::Logger.new('vagrant::haipa::converge')
        end

        def call(env)

          operation_result = @machine.provider.driver.converge(env,env[:generated_name])

          # assign the machine id for reference in other commands
          @machine.id = operation_result.machine_guid

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
          env[:action_runner].run(Actions.action_destroy, destroy_env)
        end
      end
    end
  end
end
