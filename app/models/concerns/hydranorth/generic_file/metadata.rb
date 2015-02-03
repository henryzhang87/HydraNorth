module Hydranorth 
  module GenericFile
    module Metadata
      extend ActiveSupport::Concern
      include Sufia::GenericFile::Metadata
      included do
        
        property :temporal, predicate: ::RDF::DC.temporal do |index|
          index.as :stored_searchable, :facetable
        end

        property :spatial, predicate: ::RDF::DC.spatial do |index|
          index.as :stored_searchable, :facetable
	end

      end

    end
  end
end
