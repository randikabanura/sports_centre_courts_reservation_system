Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api, constraints: { format: 'json' } do
    namespace :v1 do
      namespace :customers do
        resources :reservations, only: [:index, :show, :create, :destroy, :update]
      end

      # This can be kept here or move to admin namespace when it is created
      resources :courts, only: [:index, :show, :create, :destroy, :update]
    end
  end

  scope :api, constraints: { format: 'json' } do
    scope :v1 do
      scope :customers do
        mount_devise_token_auth_for 'Customer', at: 'auth'
      end
    end
  end

  root 'application#home'
  match '*unmatched', to: 'application#not_found_method', via: :all
end
