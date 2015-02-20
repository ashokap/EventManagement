class DefaultUserController < ApplicationController
  
  def new
     @user=User.new 
  end

  def create
    @user=User.new(user_params)
    
    puts("Email:#{params[:user][:email]} \n Password : #{params[:password]} \n Confirmation: #{params[:password_confirmation]}")
    
    
   @user=User.create!({:email => params[:user][:email], :password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation], :confirmed_at => Time.now })
   #@defaultuser=User.create!()
    # @user.remove_role :admin
    # @user.add_role :normal
    # Change role from admin to normal
    @user.switch_role
    flash[:notice] = "User #{@user.email} created successfully"
    redirect_to events_url
        
  end
  
  private
   # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    #params.permit(:email, :password)
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
  
end
