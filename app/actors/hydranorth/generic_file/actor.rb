module Hydranorth
  module GenericFile
    class Actor < Sufia::GenericFile::Actor
      include Hydranorth::ManagesEmbargoesActor

      attr_reader :attributes, :generic_file, :user

      def initialize(generic_file, user, input_attributes)
        @generic_file = generic_file
        @user = user
        @attributes = input_attributes

      end

      delegate :visibility_changed?, to: :generic_file

      def create_metadata(batch_id)
      generic_file.apply_depositor_metadata(user)
      time_in_utc = DateTime.now.new_offset(0)
      generic_file.date_uploaded = time_in_utc
      generic_file.date_modified = time_in_utc
      generic_file.creator = [user.name]
      Rails.logger.debug "InsideActor #{generic_file.inspect}"

      if batch_id
        generic_file.batch_id = batch_id
      else
        ActiveFedora::Base.logger.warn "unable to find batch to attach to"
      end
      yield(generic_file) if block_given?
    end



      def create_metadata_with_resource_type(batch_id, resource_type)
        create_metadata(batch_id)
        if resource_type
          generic_file.resource_type = [resource_type]
        else
          ActiveFedora::Base.logger.warn "unable to find the resource type it belongs to"
        end
        yield(generic_file) if block_given?
        Rails.logger.debug "InsideActor #{generic_file.inspect}"

    end


      def update_metadata(attributes, visibility)
        interpret_visibility  
        update_visibility(attributes[:visibility]) if attributes.key?(:visibility)
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
