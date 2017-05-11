module CruLib
  module GlobalRegistryMasterPersonMethods
    extend ActiveSupport::Concern
    include CruLib::GlobalRegistryMethods

    included do
      after_commit :retrieve_gr_master_person_id, on: [:create, :update]
    end

    def retrieve_gr_master_person_id
      return unless respond_to?(:gr_master_person_id)
      async(:async_retrieve_gr_master_person_id)
    end

    def async_retrieve_gr_master_person_id
      fail CruLib::NoGlobalRegistryIdError, "Person #{id} has no global_registry_id; will retry" unless global_registry_id
      begin
        person_entity = GlobalRegistry::Entity.find(global_registry_id, 'filters[owned_by]' => 'mdm')
      rescue RestClient::ResourceNotFound
        Rails.logger.info "GR entity #{global_registry_id} for Person #{id} does not exist; will _not_ retry"
        return
      end
      mdm_entity_id = Array.wrap(person_entity.dig('entity', 'person', 'master_person:relationship'))
                          .first # although there should not be more than one
                          .try(:[], 'master_person')
      fail CruLib::NoGlobalRegistryMasterPersonError, "GR entity #{global_registry_id} for Person #{id} has no master_person; will retry" unless mdm_entity_id
      update_columns(gr_master_person_id: mdm_entity_id)
    end

    module ClassMethods
      def skip_fields_for_gr
        super + %w(gr_master_person_id)
      end
    end
  end

  class NoGlobalRegistryIdError < StandardError; end

  class NoGlobalRegistryMasterPersonError < StandardError; end
end
