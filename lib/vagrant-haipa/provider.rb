

module VagrantPlugins
  module Haipa
    class Provider < Vagrant.plugin("2", :provider)

      # @return (VagrantPlugins::Haipa::Driver) current driver
      attr_reader :driver

      def initialize(machine)
        @machine = machine
        @logger = Log4r::Logger.new("vagrant::haipa::provider")

        @driver = Driver.new(@machine)
      end

      # This method is called if the underying machine ID changes. Providers
      # can use this method to load in new data for the actual backing
      # machine or to realize that the machine is now gone (the ID can
      # become `nil`). No parameters are given, since the underlying machine
      # is simply the machine instance given to this object. And no
      # return value is necessary.
      def machine_id_changed        
      end

      def state
        state_id = nil
        state_id = :not_created if !@machine.id

        if !state_id
          # Run a custom action we define called "read_state" which does
          # what it says. It puts the state in the `:machine_state_id`
          # key in the environment.
          env = @machine.action(:read_state)
          state_id = env[:machine_state_id]
        end

        # Get the short and long description
        short = state_id.to_s
        long  = ""

        # If we're not created, then specify the special ID flag
        if state_id == :not_created
          state_id = Vagrant::MachineState::NOT_CREATED_ID
        end

        # Return the MachineState object
        Vagrant::MachineState.new(state_id, short, long)
      end

      def action(name)
        # Attempt to get the action method from the Action class if it
        # exists, otherwise return nil to show that we don't support the
        # given action.
        action_method = "action_#{name}"
        return Action.send(action_method) if Action.respond_to?(action_method)
        nil
      end          
    end
  end
end
  