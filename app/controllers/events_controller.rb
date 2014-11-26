class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    @events = Event.all
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render action: 'show', status: :created, location: @event }
      else
        format.html { render action: 'new' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end
  
  
   def import
    @uploaded_io = params[:file]

    if params[:file].blank?
      redirect_to '/events', :notice => "Please select a file to import."
    elsif @uploaded_io.content_type == "text/calendar"
      #puts("File Name: #{@uploaded_io.original_filename}")
      tmpfile=File.open(Rails.root.join('public', @uploaded_io.original_filename), 'wb') do |file|
        file.write(@uploaded_io.read)
      end
      redirect_to '/events', :notice => "Import successful."
    self.parse
    else
      redirect_to '/events', :notice => "Please select .ics file."
    end
  end

  def parse
    # Open a file or pass a string to the parser
    cal_file = File.open( Rails.root.join('public', @uploaded_io.original_filename), "r")
    # Parser returns an array of calendars because a single file
    # can have multiple calendars.
    cals = Icalendar.parse(cal_file)
    #puts("All Calendars: #{cals}")
    cals.each do |cal|
    # Now you can access the cal object in just the same way I created it
    # puts("Current Calendar: #{cal}")
      cal.events.each do |event|
      # puts "Current event : #{event}"
        @event = Event.new(params[:event])
        @event.assign_attributes(:title => " #{event.summary}", :description => " #{event.description}", :start_time => "#{event.dtstart}" , :end_time => "#{event.dtend}")
        
        # Check all ready the same event exist at the database, using subject start time and end time.
        # If not exist then the save the event to the local database
        if Event.exists?(title: @event.title, start_time:@event.start_time, end_time:@event.end_time)
        else 
        @event.save
        end
      #puts "start date-time timezone: #{event.dtstart.ical_params['tzid']}"
      end
    end
  end

  def export
    calendar = Icalendar::Calendar.new
    events=Event.all

    events.each do |e|
      event = Icalendar::Event.new
      event.dtstart = e.start_time
      event.dtend = e.end_time #datetime.strftime("%Y%m%dT%H%M%S%Z")
      event.summary = e.title
      event.description = e.description
      calendar.add_event(event)
    #puts("Current Event: #{event}")
    end
    calendar.publish
    file = File.new("tmp/sample.ics", "w+")
    file.write(calendar.to_ical)
    file.close
    send_file("tmp/sample.ics")
  end    
  
  
  
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:title, :description, :start_time, :end_time)
    end
    
    
    
   
   
end
