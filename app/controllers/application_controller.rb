class ApplicationController < ActionController::API
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  attr_reader :current_user

  private

  def authenticate_user!
    payload = JsonWebToken.decode(auth_token)
    @current_user = EventUser.find(payload[:sub])
  rescue JWT::DecodeError
    render json: { error: 'Invalid Auth Token' }, status: :unauthorized
  end

  def auth_token
    @auth_token ||= request.headers.fetch('authorization', '').split.last
  end
end
