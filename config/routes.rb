Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api, constraints: { format: 'json' } do
    namespace :v1 do
      namespace :customers do
        mount_devise_token_auth_for 'Customer', at: 'auth'
      end
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'application#home'
  match '*unmatched', to: 'application#not_found_method', via: :all
end
