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
     
      if @generic_file[:resource_type].include?("Computing Science Technical Report") 
        Hydranorth::CstrPresenter.new(@generic_file)
      elsif @generic_file[:resource_type].include?("Structural Engineering Report")
        Hydranorth::SerPresenter.new(@generic_file)
      else
        Hydranorth::GenericFilePresenter.new(@generic_file)
      end
    end

    def edit_form
       
      if @generic_file[:resource_type].include?("Computing Science Technical Report")
        Hydranorth::Forms::CstrEditForm.new(@generic_file) 
      elsif @generic_file[:resource_type].include?("Structural Engineering Report") 
        Hydranorth::Forms::SerEditForm.new(@generic_file)
      else
        Hydranorth::Forms::GenericFileEditForm.new(@generic_file)
      end
    end
    def update_metadata
      file_attributes = Hydranorth::Forms::GenericFileEditForm.model_attributes(params[:generic_file])
      actor.update_metadata(file_attributes, params[:visibility])
    end

    def process_file(file)
      update_metadata_from_upload_screen
      if params[:resource_type].present?
         actor.create_metadata_with_resource_type(params[:batch_id], params[:resource_type]) 
      else
         actor.create_metadata(params[:batch_id])
      end
      if actor.create_content(file, file.original_filename, datastream_id)
        respond_to do |format|
          format.html {
            render 'jq_upload', formats: 'json', content_type: 'text/html'
          }
          format.json {
            render 'jq_upload'
          }
        end
      else
        msg = @generic_file.errors.full_messages.join(', ')
        flash[:error] = msg
        json_error "Error creating generic file: #{msg}"
      end
    end
    def update_metadata_from_upload_screen
      # Relative path is set by the jquery uploader when uploading a directory
      @generic_file.relative_path = params[:relative_path] if params[:relative_path]
      @generic_file.on_behalf_of = params[:on_behalf_of] if params[:on_behalf_of]
      @generic_file.resource_type = ["Computing Science Technical Report"] if params[:resource_type] == "Computing Science Technical Report" 
      @generic_file.resource_type = ["Structural Engineering Report"] if params[:resource_type] == "Structural Engieering Report"
    end

  end

end
