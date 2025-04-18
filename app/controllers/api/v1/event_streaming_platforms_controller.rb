class Api::V1::EventStreamingPlatformsController < ApplicationController
  before_action :authenticate_user!

  def index
    platforms = current_user.foundation_events.event_streaming_platforms

    render json: platforms, each_serializer: EventStreamingPlatformSerializer, status: :ok
  end

  def create
    platform = EventStreamingPlatform.new(platform_params)

    if platform.save
      render json: { message: 'Platform created successfully', platform: EventStreamingPlatformSerializer.new(platform) }, status: :created
    else
      render json: { errors: platform.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    platform = current_user.event_users.event_streaming_platforms.find_by(id: params[:id])
    if platform.nil?
        render json: { error: 'Platform not found' }, status: :not_found
        return
    end
    # First, permit all platform_updates keys
    if platform.update(platform_update_params)
      render json: { message: 'Platform updated successfully', platform: EventStreamingPlatformSerializer.new(platform) }, status: :ok
    else
      render json: { errors: platform.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    platform = current_user.event_users.event_streaming_platforms.find_by(id: params[:id])
    if platform.nil?
        render json: { error: 'Platform not found' }, status: :not_found
        return
    end
    if platform.destroy
        render json: { message: 'Platform deleted successfully' }, status: :ok
    else
        render json: { errors: platform.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
  
  def platform_params
    params.require(:event_streaming_platform).permit(:platform_name, :embed_code, :embed_link, :visit_link)
  end

  def platform_update_params
    params.require(:platform_updates).permit(:platform_name, :embed_code, :embed_link, :visit_link)
  end
end
