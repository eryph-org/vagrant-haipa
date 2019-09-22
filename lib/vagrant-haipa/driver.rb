require 'haipa_compute'
require 'time'

module VagrantPlugins
  module Haipa
    class Driver
      include Vagrant::Util::Retryable
      
      @@compute_api = nil

      def initialize(machine)
        @machine = machine
        @logger = Log4r::Logger.new('vagrant::haipa::driver')
 
      end

      # @return [::Haipa::Client::Compute::ApiConfiguration] Haipa Compute API
      def compute_api
        # If already connected to Haipa, just use it and don't connect
        # again.
        return @@compute_api if @@compute_api

        config = @machine.provider_config
        

        @@compute_api = ::Haipa::Client::Compute.new({
          client_id: config.client_id,
          client_key_file: config.client_key_file,
          identity_endpoint: config.identity_endpoint,
          api_endpoint: config.api_endpoint
        })

        @@compute_api

      end

      
      def read_state
        return :not_created if @machine.id.nil?

        haipa_machine = nil
        begin
          haipa_machine = compute_api.client.machines.get(@machine.id)
        rescue ::Haipa::Client::HaipaOperationError => ex
          if haipa_machine.nil?
            # The machine can't be found
            @logger.info('Machine not found or terminated, assuming it got destroyed.')
            return :not_created
          end
        end

        # Return the state
        haipa_machine.status
      end
      
      def machine(expand = nil)
        compute_api.client.machines.get(@machine.id, :expand => expand)
      end

      def machine_name
        unless @machine.provider_config.name.nil?
          @machine.provider_config.name
        else
          @machine.name
        end        
      end

      def converge(env)

        machine_config_hash = {
          :name => machine_name, 
          :id =>  @machine.id,                         
          :vm => @machine.provider_config.vm_config,
          :provisioning => @machine.provider_config.provision   
        }

        # this will convert all symbols to strings as required by deserialize
        machine_config_string_hash = JSON.parse(machine_config_hash.to_json)
        
        machine_config = compute_api.deserialize(:MachineConfig, machine_config_string_hash)
        operation = compute_api.client.machines.update_or_create(:config => machine_config)

        wait_for_operation(env,operation) 
      end

      def start(env)
        operation = compute_api.client.machines.start(@machine.id)
        wait_for_operation(env,operation)
      end

      def stop(env)
        operation = compute_api.client.machines.stop(@machine.id)
        wait_for_operation(env,operation)
      end

      def delete(env)
        operation = compute_api.client.machines.delete(@machine.id)
        wait_for_operation(env,operation)
      end

      protected

      def wait_for_operation(env,operation)
        timestamp = DateTime.parse('2018-09-01T23:47:17.50094+02:00')

        operation_error = nil
        
        # wait for operation to be started
        result = retryable(:tries => 20, :sleep => 5) do
          # stop waiting if interrupted
          next if env[:interrupted]

          result = compute_api.client.operations.get(operation.id)
          yield result if block_given?

          raise 'Operation not started' if result.status == 'Queued'
          result
        end

        if result.status == 'Running' then
         
          result = retryable(:tries => 20, :sleep => 5) do
            # stop waiting if interrupted
            next if env[:interrupted]

            # check action status
            result = compute_api.client.operations.get(operation.id, :expand => "LogEntries($filter=Timestamp gt #{timestamp.iso8601})")

            result.log_entries.each do |entry|
              if timestamp < entry.timestamp     
                env[:ui].info(entry.message) 
                timestamp = entry.timestamp

                # randomized delay for smoother output
                delay = rand(4) * 0.2
                sleep delay
              end
            end

            yield result if block_given?

            raise 'Operation not completed' if result.status == 'Running'
            result            
          end          
        end

        raise "Operation failed: #{result.status_message}" if result.status == 'Failed'   
        
        #write latest log entries
        result = compute_api.client.operations.get(operation.id, :expand => "LogEntries($filter=Timestamp gt #{timestamp.iso8601})")
        result.log_entries.each do |entry|
          env[:ui].info(entry.message) if timestamp < entry.timestamp     
          timestamp = entry.timestamp if timestamp < entry.timestamp
        end

        #refresh operation result
        compute_api.client.operations.get(operation.id)
      end
    end
  end
end
      