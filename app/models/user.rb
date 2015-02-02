class User < ActiveRecord::Base
  rolify 
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
      user.save
      return user
    else
      registered_user = User.where(:email => access_token.info.email).first
      if registered_user
        registered_user.provider = access_token.provider
        registered_user.uid = access_token.uid
        registered_user.token = access_token.credentials.token
        registered_user.save
        return registered_user
      else
        user = User.create(provider:access_token.provider,email: data["email"],uid: access_token.uid ,password: Devise.friendly_token[0,20],token:access_token.credentials.token)
      end
   end
   
  end
  
end
