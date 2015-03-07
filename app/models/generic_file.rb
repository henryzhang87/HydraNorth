class GenericFile < ActiveFedora::Base
  include Hydranorth::GenericFile
   property :date_created, predicate: ::RDF::DC.created, multiple: false do |index|
          index.as :stored_searchable
        end
  
end
