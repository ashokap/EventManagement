class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, :type => String, :default => ""
  field :start_time, :type => Time, :default => ""
  field :end_time, :type => Time, :default => ""
  field :description
  field :google_event_id
  field :all_day, :type => Boolean
  
  belongs_to :user
  
  validates :title, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

 
  def end_time_is_after_start_time
    logger.debug "This is from debug"
    logger.info "This is from info"

    return if end_time.blank? || start_time.blank?
    if end_time < start_time
      errors.add(:end_time, "cannot be before the start time")
    end
  end

end
