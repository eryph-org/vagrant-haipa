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
          b.use action_start
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
      
      def self.action_start
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Call, IsRunning do |env, b2|
            # If the machine is running, run the necessary provisioners
            if env[:result]
              b2.use action_provision
              next
            end
            
            b2.use action_boot
          end
        end
      end

      def self.action_stop
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate

          b.use Call, IsCreated do |env, b2|
            unless env[:result]
              b2.use MessageNotCreated
              next
            end
            
            b2.use StopMachine
          end
        end
      end

      def self.action_boot
        Vagrant::Action::Builder.new.tap do |b|
          b.use Provision
          b.use SyncedFolderCleanup
          b.use SyncedFolders
          b.use StartMachine
        end
      end

      # This action is called when `vagrant provision` is called.
      def self.action_provision
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Call, IsCreated do |env, b2|
            unless env[:result]
              b2.use MessageNotCreated
              next
            end

            b2.use Provision
            b2.use SyncedFolderCleanup
            b2.use SyncedFolders
          end
        end
      end      

      # This action is called to SSH into the machine.
      def self.action_ssh
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Call, IsCreated do |env, b2|
            unless env[:result]
              b2.use MessageNotCreated
              next
            end

            b2.use SSHExec
          end
        end
      end

      def self.action_ssh_run
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Call, IsCreated do |env, b2|
            unless env[:result]
              b2.use MessageNotCreated
              next
            end

            b2.use SSHRun
          end
        end
      end

      def self.action_ssh_ip
        Vagrant::Action::Builder.new.tap do |b|
          b.use Call, ConfigValidate do |env, b2|
            b2.use WaitForIpAddress
          end
        end
      end

      # This action is called to terminate the remote machine.
      def self.action_destroy
        Vagrant::Action::Builder.new.tap do |b|
          b.use Call, DestroyConfirm do |env, b2|
            if env[:result]
              b2.use ConfigValidate
              b2.use Call, IsCreated do |env2, b3|
                unless env2[:result]
                  b3.use MessageNotCreated
                  next
                end

                b3.use ProvisionerCleanup, :before if defined?(ProvisionerCleanup)
                b3.use DeleteMachine
              end
            else
              b2.use MessageWillNotDestroy
            end
          end
        end
      end      

      def self.action_reload
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Call, IsCreated do |env, b2|
            unless env[:result]
              b2.use MessageNotCreated
              next
            end

            b2.use action_stop
            b2.use ConvergeMachine
            b2.use action_up
          end
        end
      end

      # The autoload farm
      action_root = Pathname.new(File.expand_path('../action', __FILE__))
      autoload :ReadState, action_root.join('read_state')
      autoload :IsCreated, action_root.join('is_created')
      autoload :IsRunning, action_root.join('is_running')
      autoload :SetName, action_root.join('set_name')
      autoload :ConvergeMachine, action_root.join('converge_machine')
      autoload :DeleteMachine, action_root.join('delete_machine')
      autoload :StartMachine, action_root.join('start_machine')      
      autoload :StopMachine, action_root.join('stop_machine')      
      autoload :WaitForIpAddress, action_root.join('wait_for_ip_address')
      
      autoload :MessageAlreadyCreated, action_root.join('message_already_created')      
      autoload :MessageNotCreated, action_root.join('message_not_created')
      autoload :MessageWillNotDestroy, action_root.join('message_will_not_destroy')

    end
  end
end