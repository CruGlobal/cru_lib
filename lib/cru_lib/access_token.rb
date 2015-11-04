require 'securerandom'

module CruLib
  class AccessToken < ActiveModelSerializers::Model
    attr_accessor :key_guid, :email, :first_name, :last_name, :token

    class << self
      def redis_key(token)
        ['cru_lib:access_token', token].join(':')
      end

      def read(token)
        json = exist?(token)
        if json
          attributes = Oj.load(json)
          attributes['token'] = token
          access_token = new(attributes)
          access_token.write
          access_token
        end
      end

      def exist?(token)
        redis_client.get(redis_key(token))
      end

      def redis_client
        @redis_client ||= CruLib.redis_client
      end
    end


    def generate_access_token
      loop do
        attributes[:token] = SecureRandom.uuid.gsub(/\-/, '')
        break unless self.class.exist?(attributes[:token])
      end
      write

      self
    end


    def write
      self.class.redis_client.setex(self.class.redis_key(token), 30.minutes.to_i, to_json)
    end
    private
  end
end