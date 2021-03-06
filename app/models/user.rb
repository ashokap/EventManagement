class User
  include Mongoid::Document  
  include Mongoid::Timestamps 
  rolify 
  ## Database authenticatable
field :email, :type => String, :default => ""
field :encrypted_password, :type => String, :default => ""
field :provider
field :uid
field :token

## Recoverable
field :reset_password_token, :type => String
field :reset_password_sent_at, :type => Time

## Rememberable
field :remember_created_at, :type => Time

## Trackable
field :sign_in_count, :type => Integer, :default => 0
field :current_sign_in_at, :type => Time
field :last_sign_in_at, :type => Time
field :current_sign_in_ip, :type => String
field :last_sign_in_ip, :type => String

## Confirmable
  field :confirmation_token,   :type => String
  field :confirmed_at,         :type => Time
  field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

field :name, type: String

  has_many :events
  belongs_to :account
  
  #This is a callback after successfully creating a user record to assign defualt role as Admin
  after_create :assign_default_role
  
  def assign_default_role
    add_role :admin  
  end  
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  #Disable :confirmable if you do not wish to receive email notifications during sign_up / reset operations
  devise :database_authenticatable, :registerable,:confirmable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :omniauthable, :omniauth_providers => [:google_oauth2]
   
   def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:provider => access_token.provider, :uid => access_token.uid ).first
    if user
      user.provider = access_token.provider
      user.uid = access_token.uid
      user.token = access_token.credentials.token
      puts("Inside Google User provider")
      user.save
      return user
    else
      registered_user = User.where(:email => access_token.info.email).first
      if registered_user
        registered_user.provider = access_token.provider
        registered_user.uid = access_token.uid
        registered_user.token = access_token.credentials.token
        registered_user.save
        puts("Inside Google User Register")
        return registered_user
      else
        user = User.create(provider:access_token.provider,email: data["email"],uid: access_token.uid ,password: Devise.friendly_token[0,20],token:access_token.credentials.token)
      end
   end
   
  end
  
  def self.switch_role
    if self.has_role :admin
      self.remove_role :admin
      self.add_role :normal
    else
      self.remove_role :normal
      self.add_role :admin
    end
    
  end
end
