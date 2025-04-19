class Api::V1::EventNotesController < ApplicationController
  before_action :authenticate_user!, only: [:index, :update, :create]
  before_action :set_event, only: [:index, :update, :create]
  before_action :set_attendee, only: [:create]
  before_action :set_note, only: [:update]

  def index
    notes = @event.event_notes

    render json: notes, each_serializer: EventNoteSerializer, status: :ok
  end

  def create
    note = @attendee.event_notes.new(note_params)

    if note.save
      render json: { message: 'Note created successfully', note: EventNoteSerializer.new(note) }, status: :created
    else
      render json: { errors: note.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @note.update(note_params)
      render json: { message: 'Note updated successfully', note: EventNoteSerializer.new(@note) }, status: :ok
    else
      render json: { errors: @note.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_note
    @note = @attendee.event_notes.find_by(id: params[:id])
    return render json: { error: 'Note not found' }, status: :not_found unless @note
  end

  def set_attendee
    @attendee = @event.event_attendees.find_by(id: params[:event_attendee_id])
    return render json: { error: 'Attendee not found' }, status: :not_found unless @attendee
  end

  def note_params
    params.require(:event_note).permit(
      :content,
      :admin_name
    )
  end
end
