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
      logger.debug "Attributes: #{attributes.inspect}"
      logger.debug "Attributes.visibility: #{attributes[:visibility].inspect}"
      @actor ||= Hydranorth::GenericFile::Actor.new(@generic_file, current_user, attributes )
   end
    
    def attributes
      attributes = params.dup
    end


  end

end
