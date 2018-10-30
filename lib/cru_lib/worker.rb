
module CruLib
  class Worker < ActiveJob::Base

    def perform(class_name, id, method, *args)
      klass = class_name.constantize
      if id
        begin
          klass.find(id).send(method, *args)
        rescue ActiveRecord::RecordNotFound
          # If the record was deleted after the job was created, swallow it
        end
      else
        klass.send(method, *args)
      end
    rescue NameError
      Rails.logger.warn("CruLib::Worker: Class for a given name (#{class_name}) does not exist")
    end
  end
end