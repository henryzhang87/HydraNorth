require "./lib/rdf_vocabularies/dams"

module Hydranorth 
  module GenericFile
    module CstrMetadata
      extend ActiveSupport::Concern
      include Sufia::GenericFile::Metadata
      include Hydranorth::GenericFile::Metadata
      included do
        
        property :technical_report_id, predicate: ::DamsVocabulary.trid do |index|
          index.as :stored_searchable, :sortable
        end

      end

    end
  end
end
