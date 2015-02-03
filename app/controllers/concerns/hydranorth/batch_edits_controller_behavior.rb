module Hydranorth
  module BatchEditsControllerBehavior
    extend ActiveSupport::Concern
    include Sufia::Breadcrumbs
    include Sufia::BatchEditsControllerBehavior


    protected


    def terms
      Hydranorth::Forms::BatchEditForm.terms
    end

    def generic_file_params
      Hydranorth::Forms::BatchEditForm.model_attributes(params[:generic_file])
    end


  end
end
