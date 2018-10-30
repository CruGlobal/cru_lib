require 'cru_lib/worker'

module CruLib
  module Async

    def self.included(base)
      base.extend(ClassMethods)
    end

    def async(method, *args)
      CruLib::Worker.
          set(queue: self.class.get_queue_name).
          perform_later(self.class.name, id, method.to_s, *args)
    end

    module ClassMethods
      attr_accessor :queue_name

      def queue_as(queue_name)
        @queue_name = queue_name
      end

      def get_queue_name
        @queue_name
      end
    end
  end
end

