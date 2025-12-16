# Interface for message gateways
# This defines the contract that any message gateway must implement
module Interfaces
  module Gateways
    class MessageGateway
      def send_message(_message)
        raise NotImplementedError, "Subclasses must implement send_message"
      end
    end
  end
end
