module Hydranorth
  class GenericFilePresenter
    include Hydra::Presenter
    self.model_class = ::GenericFile
    # Terms is the list of fields displayed by app/views/generic_files/_show_descriptions.html.erb
    self.terms = [:resource_type, :title, :license, :creator, :contributor, :description, :tag, :rights,
       :publisher, :date_created, :subject, :language, :identifier, :based_near, :related_url]

    # Depositor and permissions are not displayed in app/views/generic_files/_show_descriptions.html.erb
    # so don't include them in `terms'.
    delegate :depositor, :permissions, to: :model

  end
end
