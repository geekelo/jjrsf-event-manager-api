class Api::V1::EventFeedbacksController < ApplicationController
  before_action :authenticate_user!, except: [:create]
  before_action :set_event, except: [:create]
  before_action :set_feedback, only: [:update, :destroy]

  def index
    feedbacks = @event.event_feedbacks
    render json: feedbacks, each_serializer: EventFeedbackSerializer, status: :ok
  end

  def create
    event = FoundationEvent.find(params[:event_id])
    if event.nil?
      render json: { error: 'Event not found' }, status: :not_found
      return
    end

    feedback = event.event_feedbacks.new(feedback_params)

    if feedback.save
      render json: { message: 'Feedback created successfully', feedback: EventFeedbackSerializer.new(feedback) }, status: :created
    else
      render json: { errors: feedback.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @feedback.update(feedback_params)
      render json: { message: 'Feedback updated successfully', feedback: EventFeedbackSerializer.new(@feedback) }, status: :ok
    else
      render json: { errors: @feedback.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @feedback.destroy
      render json: { message: 'Feedback deleted successfully' }, status: :ok
    else
      render json: { errors: @feedback.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_feedback
    @feedback = @event.event_feedbacks.find_by(id: params[:id])
    return render json: { error: 'Feedback not found' }, status: :not_found unless @feedback
  end

  def feedback_params
    params.require(:event_feedback).permit(:review, :testimony, :name)
  end
end
