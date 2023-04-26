class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :configure_permitted_parameters, if: :devise_controller?
  respond_to :json

  def home
    render json: { status: 'success', data: 'We are alive! Let\'s go' }, status: :ok
  end

  def not_found_method
    render json: { status: 'error', message: 'route not found' }, status: :not_found
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :first_name, :last_name])
  end
end
