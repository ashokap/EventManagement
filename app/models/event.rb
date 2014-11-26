class Event < ActiveRecord::Base
  
  validates :title, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  # def start_must_be_before_end_time
  # return unless startTime and endTime
  # errors.add(:startTime, "must be before end time") unless startTime < endTime
  # end
  #
  def end_time_is_after_start_time

    logger.debug "This is from debug"
    logger.info "This is from info"

    return if end_time.blank? || start_time.blank?
    if end_time < start_time
      errors.add(:end_time, "cannot be before the start time")
    end
  end

end
