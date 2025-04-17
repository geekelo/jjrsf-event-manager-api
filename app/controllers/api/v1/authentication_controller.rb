class Api::V1::AuthenticationController < ApplicationController
  def create
    user = EventUser.find_by(email: login_params[:email])
    if user&.authenticate(login_params[:password])
      render json: { 
        message: 'Login successful',
        user: EventUserSerializer.new(user),
        token: JsonWebToken.encode(sub: user.id)
        }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  private

  def login_params
    params.require(:user).permit(:email, :password)
  end
end
