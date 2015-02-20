class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  # GET /events
  # GET /events.json
  def index
    if current_user.account.nil?
      redirect_to new_account_path, :notice => "No Account details found. Please Create one before procedding further"
      
    else
      members=current_user.account.users
      combinedevents=nil
      members.each do |member|
        # combinedevents.add(member.events)
        puts("Member : #{member.email}, events #{member.events.count}")
      end
      #puts("Combined events count: #{combinedevents.count}, members count: #{members.count}")
      @events = current_user.events

      if !params[:search].blank?
        @events = current_user.events.where(title: /.*#{params[:search]}.*/)
        if @events.count > 0
          respond_to do |format|
            format.html { render action: 'searched' }
          end
        else
          redirect_to events_url, :alert => "No events founds"
        end
      else
      # Returs to Events page
      end
    end
  # randomstring=SecureRandom.hex(4)
  # puts("Random string: #{randomstring}")
  end

  #Empty method for Search events
  def searched

  end

  # GET /events/1
  # GET /events/1.json
  def show
  
  end

  # GET /events/new
  def new
    @event = Event.new
    @users = current_user.account.users
      puts("Users count #{@users.count}")
  end

  # GET /events/1/edit
  def edit
    @currentevent = Event.find(params[:id])
    @users=current_user.account.users
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    @users = current_user.account.users
    #Set user reference to current user
    #@event.user=current_user

    respond_to do |format|
      if @event.save
        if current_user.provider == 'google_oauth2'
          #Save the event to google calendar
          client = Google::APIClient.new
          client.authorization.access_token =  current_user.token
          service = client.discovered_api('calendar', 'v3')
          puts("Event start time:#{@event.start_time} end time: #{@event.end_time}")
          tmp_event = {
            'summary' => @event.title,
            'description' => @event.description,
            'location' => 'PaNa',
            'start' => {'dateTime' => @event.start_time.to_datetime.rfc3339},
            'end' => {'dateTime' => @event.end_time.to_datetime.rfc3339},
            'attendees' => [ { "email" => current_user.email } ] }
          result = client.execute(:api_method => service.events.insert,
          :parameters => {'calendarId' => current_user.email, 'sendNotifications' => true},
          :body => JSON.dump(tmp_event),
          :headers => {'Content-Type' => 'application/json'})
          puts("Result from export; #{result.body}")
          #Retrieve the unique record Id created in google and save it for future updates
          @event.google_event_id = result.data.id
          puts("Id from google: #{result.data.id}")
        @event.save
        end
        # format.html { redirect_to @event, notice: 'Event was successfully created.' }
        # format.json { render action: 'show', status: :created, location: @event }
        format.html { redirect_to events_url, :notice => "Event created." }
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

        #Check if the event has any google_id associated with. If so update the record in google calendar as well
        unless (@event.google_event_id.nil? && (current_user.provider != 'google_oauth2'))
          client = Google::APIClient.new
          client.authorization.access_token = current_user.token
          service = client.discovered_api('calendar', 'v3')

          result = client.execute(:api_method => service.events.get, :parameters => {'calendarId' => current_user.email, 'eventId' => @event.google_event_id } )
          puts("Event returned from google: #{result.data}")
          tmpevent = result.data
          tmpevent.summary = @event.title
          tmpevent.start.dateTime = @event.start_time
          tmpevent.end.dateTime = @event.end_time
          tmpevent.description = @event.description
          tmpevent.location = "PaNa"

          result = client.execute(:api_method => service.events.update,
          :parameters => {'calendarId' => current_user.email, 'eventId' =>  @event.google_event_id},
          :body_object => tmpevent,
          :headers => {'Content-Type' => 'application/json'})
          puts("Inside google update")
        end
        puts("Outside google update")

        format.html { redirect_to events_url, :notice => "Event updated." }
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

    #Check and remove the event from google calendar as well
    if @event.destroyed?
      unless @event.google_event_id.nil? && (current_user.provider != 'google_auth2')
        client = Google::APIClient.new
        client.authorization.access_token = current_user.token
        service = client.discovered_api('calendar', 'v3')

        result = client.execute(:api_method => service.events.delete,
        :parameters => {'calendarId' => current_user.email, 'eventId' => @event.google_event_id})
      end
    end

    respond_to do |format|
      format.html { redirect_to events_url, :alert => "Event '#{@event.title}' has been removed" }
      format.json { head :no_content }
    end
  end

  #Imports and external .ICS file, parses the contents
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

  #Parses an incoming .ICS file and stores events into the DB
  def parse
    # Open a file or pass a string to the parser
    cal_file = File.open( Rails.root.join('public', @uploaded_io.original_filename), "r")
    # Parser returns an array of calendars because a single file
    # can have multiple calendars.
    cals = Icalendar.parse(cal_file)
    #puts("All Calendars: #{cals}")
    cals.each do |cal|
    # Now you can access the cal object in just the same way I created it
      cal.events.each do |event|
      # puts "Current event : #{event}"
        @event = Event.new(params[:event])
        #Set user reference to current user
        @event.user=current_user
        #Assign different values parsed from the Event
        @event.assign_attributes(:title => " #{event.summary}", :description => " #{event.description}", :start_time => "#{event.dtstart}" , :end_time => "#{event.dtend}")

        # Check all ready the same event exist at the database, using subject start time and end time.
        # If not exist then the save the event to the local database
        if Event.where(title: @event.title, start_time:@event.start_time, end_time:@event.end_time).exists?
        #Do nothing, move with next event
        else
        @event.save
        end
      #puts "start date-time timezone: #{event.dtstart.ical_params['tzid']}"
      end
    end
  end

  #Exports the events from the DB as an ICS file
  def export
    calendar = Icalendar::Calendar.new
    events=Event.all

    events.each do |e|
      event = Icalendar::Event.new
      event.dtstart = e.start_time
      event.dtend = e.end_time
      event.summary = e.title
      event.description = e.description
      calendar.add_event(event)
    end
    calendar.publish
    filename=current_user.email
    file = File.new("tmp/#{filename}.ics", "w+")
    file.write(calendar.to_ical)
    file.close
    send_file("tmp/#{filename}.ics")
  end

  #Imports events from google calendar
  def importevent
    page_token = nil
    client = Google::APIClient.new
    client.authorization.access_token =  current_user.token
    service = client.discovered_api('calendar', 'v3')

    result = client.execute(:api_method => service.events.list,
    :parameters => {'calendarId' => current_user.email})

    while true
      events = result.data.items
      events.each do |event|
        puts("Start time: #{event.start.date_time}")

        if existingEvent=Event.where(:google_event_id => event.id).first
          existingEvent.title = event.summary
          existingEvent.description = event.description
          existingEvent.start_time = event.start.date_time
          existingEvent.end_time = event.end.date_time
          existingEvent.google_event_id = event.id
          puts("Google Import: Update event")
        existingEvent.save

        elsif Event.where(title: event.summary, start_time:event.start.date_time, end_time:event.start.date_time).exists?
          #Do nothing. Its a duplicate import
          puts("Google Import: Duplicate event")
        else
          @event = Event.new(params[:event])

          #Set user reference to current user
          @event.user=current_user

          #Assign different values parsed from the Event
          @event.assign_attributes(:title => " #{event.summary}", :description => "#{event.description}", :start_time => "#{event.start.date_time}" , :end_time => "#{event.end.date_time}",
          :google_event_id => "#{event.id}")

          puts("Google Import: New event")
        @event.save
        end
      end
      if !(page_token = result.data.next_page_token)
      break
      end
      result = client.execute(:api_method => service.events.list,
      :parameters => {'calendarId' => current_user.email,
        'pageToken' => page_token})
    end
    redirect_to '/events', :notice => "Successfully Imported events from Google calendar"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def event_params
    params.require(:event).permit(:title, :description, :start_time, :end_time, :user)
  end

end
