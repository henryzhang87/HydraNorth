module Hydranorth
  module FilesController
    extend ActiveSupport::Autoload
    include Sufia::FilesController
  end
  module FilesControllerBehavior
    extend ActiveSupport::Concern
    include Sufia::FilesControllerBehavior

    protected
    def actor
      @actor ||= Hydranorth::GenericFile::Actor.new(@generic_file, current_user, attributes)
    end
    
    def attributes
      attributes = params
    end
    
    def presenter
     
      if (@generic_file[:resource_type].include?("Computing Science Technical Report") || @generic_file[:resource_type].include?("Strutural Engineering Report"))
        Hydranorth::AdditionalIdPresenter.new(@generic_file)
      else
        Hydranorth::GenericFilePresenter.new(@generic_file)
      end
    end

    def edit_form
       
      if (@generic_file[:resource_type].include?("Computing Science Technical Report")||@generic_file[:resource_type].include("Strutural Engineering Report"))
        Hydranorth::Forms::AdditionalIdEditForm.new(@generic_file) 
      else 
        Hydranorth::Forms::GenericFileEditForm.new(@generic_file)
      end
    end
    def update_metadata
      file_attributes = Hydranorth::Forms::GenericFileEditForm.model_attributes(params[:generic_file])
      actor.update_metadata(file_attributes, params[:visibility])
    end

  end

end
