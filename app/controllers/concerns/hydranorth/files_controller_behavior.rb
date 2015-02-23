module Hydranorth
  module FilesController
    extend ActiveSupport::Autoload
    include Sufia::FilesController
  end
  module FilesControllerBehavior
    extend ActiveSupport::Concern
    include Sufia::FilesControllerBehavior
    


def create_from_upload(params)
      # check error condition No files
      logger.debug "InsideCreateFromUpload: #{params.inspect}"
      return json_error("Error! No file to save") if !params.has_key?(:files)

      file = params[:files].detect {|f| f.respond_to?(:original_filename) }
      if !file
        json_error "Error! No file for upload", 'unknown file', status: :unprocessable_entity
      elsif (empty_file?(file))
        json_error "Error! Zero Length File!", file.original_filename
      elsif (!terms_accepted?)
        json_error "You must accept the terms of service!", file.original_filename
      else
        process_file(file)
      end
    rescue => error
      logger.error "GenericFilesController::create rescued #{error.class}\n\t#{error.to_s}\n #{error.backtrace.join("\n")}\n\n"
      json_error "Error occurred while creating generic file."
    ensure
      # remove the tempfile (only if it is a temp file)
      file.tempfile.delete if file.respond_to?(:tempfile)
    end

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

    def process_file(file)
      update_metadata_from_upload_screen
      logger.debug "InsideProcessFileResourceType: #{params[:resource_type].inspect}"
      if params[:resource_type].present?
         actor.create_metadata_with_resource_type(params[:batch_id], params[:resource_type]) 
      else
         actor.create_metadata(params[:batch_id])
      end
      logger.debug "InsideProcessFile: #{file.inspect}"
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
      logger.debug "Inside FileControllerBehavior: #{@generic_file.inspect}"
    end

  end

end
