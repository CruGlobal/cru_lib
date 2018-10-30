
# Mock ActiveRecord::RecordNotFound
#
module ActiveRecord
  class RecordNotFound < StandardError
  end
end

# ActiveRecord-ish - a mocked ActiveRecord that behaves like a model class with id
#
class ActiveRecordIsh
  attr_accessor :id

  def self.find(id)
    obj = self.new
    obj.id = id
    obj
  end
end
