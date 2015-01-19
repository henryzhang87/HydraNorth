module Hydranorth 
  module GenericFile
    class Actor < Sufia::GenericFile::Actor
      include Hydranorth::ManagesEmbargoesActor

      attr_reader :attributes, :generic_file, :user, :visibility

      def initialize(generic_file, user, input_attributes)
        
        @generic_file = generic_file
        @user = user
        @attributes = input_attributes.dup.with_indifferent_access
        @visibility = attributes[:visibility]
        Rails.logger.debug "input_attributes from actor: #{input_attributes.inspect}"
Rails.logger.debug "attributes from actor: #{attributes.inspect}"
Rails.logger.debug "global attributes from actor: #{@attributes.inspect}"
Rails.logger.debug "visibility from actor: #{@visibility.inspect}"

      end

      protected :visibility
      delegate :visibility_changed?, to: :generic_file


      def update_metadata(attributes, visibility)
        interpret_visibility  
        generic_file.attributes = generic_file.sanitize_attributes(attributes)
        update_visibility(attributes[:visibility]) if attributes.key?(:visibility)
        Rails.logger.debug "still under_embargo? #{generic_file.under_embargo?}" 
        generic_file.date_modified = DateTime.now
        remove_from_feature_works if generic_file.visibility_changed? && !generic_file.public?
        save_and_record_committer do
          if Sufia.config.respond_to?(:after_update_metadata)
            Sufia.config.after_update_metadata.call(generic_file, user)
          end
        end
      end 


    end
  end
end
