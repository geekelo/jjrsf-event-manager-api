class Api::V1::EventStreamingPlatformsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:index, :create]
  before_action :set_platform, only: [:update, :destroy]

  def index
    platforms = @event.event_streaming_platforms

    render json: platforms, each_serializer: EventStreamingPlatformSerializer, status: :ok
  end

  def create
    new_platform = @event.event_streaming_platforms.new(platform_params)

    if new_platform.save
      render json: { message: 'Platform created successfully', platform: EventStreamingPlatformSerializer.new(new_platform) }, status: :created
    else
      render json: { errors: new_platform.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @platform.update(platform_params)
      render json: { message: 'Platform updated successfully', platform: EventStreamingPlatformSerializer.new(@platform) }, status: :ok
    else
      render json: { errors: @platform.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @platform.destroy
        render json: { message: 'Platform deleted successfully' }, status: :ok
    else
        render json: { errors: @platform.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_platform
    @platform = @event.event_streaming_platforms.find_by(id: params[:id])
    return render json: { error: 'Platform not found' }, status: :not_found unless @platform
  end
  
  def platform_params
    params.require(:event_streaming_platform).permit(:platform_name, :embed_code, :embed_link, :visit_link)
  end
end
