module VagrantPlugins
  module Haipa
    module Action
      class WaitForIpAddress
        include Vagrant::Util::Retryable

        def initialize(app, env)
          @app = app
          @machine = env[:machine]
          @logger = Log4r::Logger.new('vagrant::haipa::wait_for_ip_address')
        end

        def call(env)
          # get machine state from driver and output ip address
          retryable(:tries => 20, :sleep => 10) do
            next if env[:interrupted]

            haipa_machine =  @machine.provider.driver.machine('Networks')
            addresses = haipa_machine.networks.map{|x| x.ip_v4addresses}.flatten
            addresses.reject! { |s| s.nil? || s.strip.empty? }
            address = addresses.first
            raise 'not ready' unless address
            
            env[:machine_ip] ||= address

          end          
          @app.call(env)
        end
      end
    end
  end
end
