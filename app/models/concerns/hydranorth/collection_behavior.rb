module Hydranorth
  module CollectionBehavior
    extend ActiveSupport::Concern
    include Sufia::CollectionBehavior

    def terms_for_display
      terms_for_editing - [:title, :description]
    end

    def terms_for_editing
      [:resource_type, :title, :identifier, :creator, :description, 
        :rights, :date_created] 
        
    end
  end
end
