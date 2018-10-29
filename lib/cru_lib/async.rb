module CruLib
  module Async

    def with_shoryuken?
      self.class.included_modules.include?(Shoryuken::Worker)
    end

    # This will be called by a worker when a job needs to be processed
    #
    # The method needs to handle both
    # 1. Sidekiq interface - just parameters as enqueued
    # 2. Shoryuken interface - first parameter is SQS message and the rest are enqueued
    #
    def perform(*args)
      if with_shoryuken?
        args = args.last
      end
      id, method, *rest_args = args
      raw_perform(id, method, *rest_args)
    end

    # This is a common method for both Sidekiq and Shoryuken workers
    #
    def raw_perform(id, method, *args)
      if id
        begin
          self.class.find(id).send(method, *args)
        rescue ActiveRecord::RecordNotFound
          # If the record was deleted after the job was created, swallow it
        end
      else
        self.class.send(method, *args)
      end
    end

    def async(method, *args)
      if with_shoryuken?
        self.class.perform_async([id, method] + args)
      else
        Sidekiq::Client.enqueue(self.class, id, method, *args)
      end
    end
  end
end

