module VagrantPlugins
  module Haipa
    module Action
      include Vagrant::Action::Builtin

      # This action is called to bring the box up from nothing.
      def self.action_up
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Call, IsCreated do |env, b2|

            if !env[:result]
              b2.use SetName     
              b2.use ConvergeMachine    
            end
          end

        end
      end


      # This action is called to read the state of the machine. The
      # resulting state is expected to be put into the `:machine_state_id`
      # key.
      def self.action_read_state
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use ReadState
        end
      end      

     # The autoload farm
     action_root = Pathname.new(File.expand_path('../action', __FILE__))
     autoload :ReadState, action_root.join('read_state')
     autoload :IsCreated, action_root.join('is_created')
     autoload :SetName, action_root.join('set_name')
     autoload :ConvergeMachine, action_root.join('converge_machine')
    end
  end
end