# frozen_string_literal: true

module CruLib
  class Railtie < Rails::Railtie
    initializer 'crulib_railtie.configure_rollbar' do
      if Module::const_defined? :Rollbar
        ::Rollbar.configure do |config|
          config.exception_level_filters.merge!('CruLib::NoGlobalRegistryIdError' => 'ignore',
                                                'CruLib::NoGlobalRegistryMasterPersonError' => 'ignore')
        end
      end
    end
  end
end
