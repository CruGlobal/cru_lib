module CruLib
  module Async

    # This will be called by a worker when a job needs to be processed
    #
    def perform(_, args)
      id, method, *method_args = *args
      if id
        begin
          self.class.find(id).send(method, *method_args)
        rescue ActiveRecord::RecordNotFound
          # If the record was deleted after the job was created, swallow it
        end
      else
        self.class.send(method, *method_args)
      end
    end

    def async(method, *args)
      self.class.perform_async([id, method] + args)
    end
  end
end

