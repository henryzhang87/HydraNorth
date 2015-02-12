require "./lib/rdf_vocabularies/dams"

module Hydranorth 
  module GenericFile
    module AdditionalIdMetadata
      extend ActiveSupport::Concern
      include Sufia::GenericFile::Metadata
      include Hydranorth::GenericFile::Metadata
      included do
        
        property :trid, predicate: ::DamsVocabulary.trid do |index|
          index.as :stored_searchable, :sortable
        end
        property :ser, predicate: ::DamsVocabulary.ser do |index|
          index.as :stored_searchable, :sortable
        end

      end

    end
  end
end
