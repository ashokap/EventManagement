class DefaultUserController < ApplicationController
  
  def new
     @user=User.new 
  end

  def index
    @users=current_user.account.users
  end
  
  def edit
    @user=User.find(params[:id])
  end
  
  def update
    respond_to do |format|
      
      @user=User.find(params[:id])
      #This fetches the rarray of roles assiged to the user and gets the first element of this array as current role.
      current_role=@user.roles.first.name
      
      puts("current_role: #{current_role}")
      @user.remove_role current_role
       @user.add_role params[:role]
       
       if @user.update
         format.html { redirect_to users_path, :notice => "User Role updated." }
       else
         format.html { render action: 'edit' }
         format.json { render json: @user.errors, status: :unprocessable_entity }
       end
    end
  end
  
  def destroy
    user = User.find(params[:id])
    if user.destroy
      flash[:notice] = "Successfully deleted User #{user.email}."
      redirect_to default_user_index_path
    end
  end
  
  private
   # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    #params.permit(:email, :password)
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
  
end
