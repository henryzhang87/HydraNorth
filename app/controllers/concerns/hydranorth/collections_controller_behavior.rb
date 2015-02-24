module Hydranorth
  module CollectionsControllerBehavior
  extend ActiveSupport::Concern
  include Sufia::CollectionsControllerBehavior

  protected

    def presenter_class
      Hydranorth::CollectionPresenter
    end

    def collection_params
      params.require(:collection).permit(:title, :description, :members, part_of: [],
        creator: [], rights: [], resource_type: [], identifier: [])
    end

    def form_class
      Hydranorth::Forms::CollectionEditForm
    end
  end
end
