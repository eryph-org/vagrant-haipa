module VagrantPlugins
  module Haipa
    class Driver
      
      # @return [String] Machine Id
      attr_reader :machine_id

      def initialize(id)
        @machine_id = id
      end
      
    end
  end
end
      