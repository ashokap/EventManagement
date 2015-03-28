class Case
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic
  
  
  field :name, type: String
  field :stage, type: String
  field :starting_date, type: Date
  field :ending_date, type: Date
  field :next_hearing, type: Date
  
  validates :name, presence: true
  validates :stage, presence: true
  validates :starting_date, presence: true
  validates :ending_date, presence: true
  validate :ending_greater_than_start_next_date
  
  def ending_greater_than_start_next_date
    #return if any of the date fields are blank
    return if starting_date.blank? || ending_date.blank? || next_hearing.blank?
    
    if ending_date < starting_date
      errors.add(:ending_date, "cannot be before the start date")
    end
    if next_hearing < starting_date
      errors.add(:next_hearing, "cannot be before the start date")
    end
    if ending_date < next_hearing
      errors.add(:ending_date, "cannot be before the next_hearing date")
    end
  end
    
  
end
