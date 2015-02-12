module Hydranorth
  module GenericFile
    extend ActiveSupport::Concern
    include Sufia::GenericFile
    include Hydra::AccessControls::Embargoable
    include Hydra::AccessControls::WithAccessRight
    include Hydranorth::GenericFile::Metadata    
    include Hydranorth::GenericFile::AdditionalIdMetadata

  end
end
