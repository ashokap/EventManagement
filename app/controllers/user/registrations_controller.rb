class User::RegistrationsController < Devise::RegistrationsController
  #rolify
# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    super
    
  end

  # POST /resource
  def create
    # logic to cater to recaptcha verification
    puts("Inside registration controller create")
    if session[:omniauth] == nil #OmniAuth
        if verify_recaptcha
          puts("Verify captcha true")
          super
          session[:omniauth] = nil unless @user.new_record? #OmniAuth
        else
          puts("Verify captcha false")
          flash.delete :recaptcha_error
          build_resource
          clean_up_passwords(resource)
          flash[:alert] = "There was an error with the recaptcha code below. Please re-enter the code."
          
          render :new 
        end
    else
       super
       session[:omniauth] = nil unless @user.new_record? #OmniAuth
    end
  end

def createnormal
   
   puts("Email:#{params[:user][:email]} \n Password : #{params[:password]} \n Confirmation: #{params[:password_confirmation]}")
   
   user=User.new({:email => params[:user][:email], :password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation] })
   if user.save
      #@user=User.create!({:email => params[:user][:email], :password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation], :confirmed_at => Time.now })
      puts("User validation true")
      user.remove_role :admin
      user.add_role :normal
      user.account = current_user.account
      user.save
      flash[:notice] = "User #{user.email} created successfully"
      redirect_to events_url
   else
     puts("User validation false")
     flash[:error] = "#{user.errors.full_messages}"
     redirect_to default_user_new_path
    end     
        
  end
  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # You can put the params you want to permit in the empty array.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.for(:sign_up) << :attribute
  # end

  # You can put the params you want to permit in the empty array.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.for(:account_update) << :attribute
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
  
  private
   # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    #params.permit(:email, :password)
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
