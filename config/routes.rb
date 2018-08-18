Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, format: 'json' do
    resources :stocks do
      collection do
        get 'search', to: 'stocks#search'
      end
    end
   
  end
end
