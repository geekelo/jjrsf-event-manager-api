class ApplicationController < ActionController::API
  attr_reader :current_user

  private

  def authenticate_user!
    payload = JsonWebToken.decode(auth_token)
    @current_user = EventUser.find(payload['sub'])
  rescue JWT::DecodeError
    render json: { error: 'Invalid auth token' }, status: :unauthorized
  end

  def auth_token
    @auth_token ||= request.headers['Authorization'].to_s.split.last
  end  

  def set_event
    @event = current_user.foundation_events.find_by(id: params[:event_id])
    return render json: { error: 'Event not found' }, status: :not_found unless @event
  end
end
