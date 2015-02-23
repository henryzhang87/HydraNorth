require 'resque/server'
Hydranorth::Application.routes.draw do
  
  blacklight_for :catalog
  devise_for :users

  Hydra::BatchEdit.add_routes(self)

  mount BrowseEverything::Engine => '/browse'
  mount Hydra::Collections::Engine => '/'
  mount Sufia::Engine => '/'
  mount HydraEditor::Engine => '/'
  mount Resque::Server.new => '/resque'
  root to: "homepage#index"
end
