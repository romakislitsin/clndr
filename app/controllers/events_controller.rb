class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:show, :edit, :update]
  before_action :set_user, only: [:edit, :create, :update]

  def index
    if params[:user_id]
      @events = current_user.events
    else
      @events = Event.all
    end
    @calendar_events = @events.flat_map{ |e| e.calendar_events(params.fetch(:start_date, Time.zone.now).to_date ) }
  end

  def show
    redirect_to edit_user_event_path(@event) if @event.user == current_user
  end

  def new
    @event = Event.new
  end

  def edit
  end

  def create
    @event = @user.events.build(event_params)
    respond_to do |format|
      if @event.save
        format.html { redirect_to user_events_path(user_id: current_user.id), notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to user_events_path(user_id: current_user.id), notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def set_event
      @event = Event.find(params[:id])
    end

    def set_user
      @user = current_user
    end

    def event_params
      params.require(:event).permit(:name, :start_time, :recurring)
    end
end
