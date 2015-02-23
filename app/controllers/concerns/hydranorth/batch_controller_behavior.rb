module Hydranorth
  module BatchControllerBehavior
    extend ActiveSupport::Concern
    include Sufia::BatchControllerBehavior
   
    
    def edit
      @batch = Batch.find_or_create(params[:id])
      @form = edit_form
      logger.debug "BatchEdit: #{@batch.generic_files.map(&:resource_type).inspect}"
      @form[:resource_type] = @batch.generic_files.map(&:resource_type).flatten
      logger.debug "Inside the batch controller: #{@form[:resource_type].inspect}"
    end 
    def update
      authenticate_user!
      @batch = Batch.find_or_create(params[:id])
      @batch.status = ["processing"]
      @batch.save
      logger.debug "Update_Batch #{@batch.inspect}"
      file_attributes = Hydranorth::Forms::BatchEditForm.model_attributes(params[:generic_file])
      logger.debug "FileAttributes #{file_attributes.inspect}"
      Sufia.queue.push(BatchUpdateJob.new(current_user.user_key, params[:id], params[:title], params[:trid], params[:ser], file_attributes, params[:visibility]))
      flash[:notice] = 'Your files are being processed by ' + t('sufia.product_name') + ' in the background. The metadata and access controls you specified are being applied. Files will be marked <span class="label label-danger" title="Private">Private</span> until this process is complete (shouldn\'t take too long, hang in there!). You may need to refresh your dashboard to see these updates.'
      if uploading_on_behalf_of? @batch
        redirect_to sufia.dashboard_shares_path
      else
        redirect_to sufia.dashboard_files_path
      end
    end
    
    protected
    
    def edit_form
      generic_file = ::GenericFile.new(creator: [current_user.name], title: @batch.generic_files.map(&:label))
      logger.debug "EditForm: #{generic_file.inspect}" 
      logger.debug "EditForm: #{@batch.inspect}"
      logger.debug "EditForm: #{@batch.generic_files.inspect}"
      Hydranorth::Forms::BatchEditForm.new(generic_file)
    end
    def update_batch_from_upload_screen
       
      # Relative path is set by the jquery uploader when uploading a directory
      @generic_file.relative_path = params[:relative_path] if params[:relative_path]
      @generic_file.on_behalf_of = params[:on_behalf_of] if params[:on_behalf_of]
    end
  end
end
