class Account
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name, type: String
  field :company, type: String
  
  has_many :users
  
  validates :name, presence: true
  validates :company, presence: true
  
end
