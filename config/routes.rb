Rails.application.routes.draw do
  resources :contacts
  resources :import
  match '/history', to: 'contacts#history', via: :get
  root to: 'contacts#index'
  resources :contacts do
    collection do
      post :import
    end
  end
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
