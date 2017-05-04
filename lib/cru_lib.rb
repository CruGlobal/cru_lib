require 'cru_lib/version'
require 'cru_lib/async'
require 'cru_lib/global_registry_methods'
require 'cru_lib/global_registry_relationship_methods'
require 'cru_lib/global_registry_master_person_methods'

module CruLib
  class << self
    attr_accessor :redis_host, :redis_port, :redis_db, :redis_client

    def configure
      yield self
    end

    def redis_host
      @redis_host ||= 'localhost'
    end

    def redis_port
      @redis_port ||= '6379'
    end

    def redis_db
      @redis_db ||= 2
    end

    def redis_client
      Redis.new(:host => CruLib.redis_host, :port => CruLib.redis_port, :db => CruLib.redis_db)
    end
  end
end
