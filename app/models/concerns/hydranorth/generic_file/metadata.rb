require "./lib/rdf_vocabularies/dams"

module Hydranorth 
  module GenericFile
    module Metadata
      extend ActiveSupport::Concern

      included do      
        property :license, predicate: ::RDF::DC.license, multiple: false do |index|
          index.as :stored_searchable
        end
      end

    end
  end
end
