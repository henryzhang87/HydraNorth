module Hydranorth
  module BatchControllerBehavior
    extend ActiveSupport::Concern
    include Sufia::BatchControllerBehavior
    
    protected
    
    def edit_form
      generic_file = ::GenericFile.new(creator: [current_user.name], title: @batch.generic_files.map(&:label))
      Hydranorth::Forms::BatchEditForm.new(generic_file)
    end
  end
end
