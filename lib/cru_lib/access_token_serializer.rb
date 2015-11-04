module CruLib
  class AccessTokenSerializer < ActiveModel::Serializer
    attributes :key_guid, :email, :first_name, :last_name, :token

    def _type
      'access_token'
    end

    def id
      token
    end
  end
end