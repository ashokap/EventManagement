class DefaultUserController < ApplicationController
  #rolify

  # def new
    # @defaultuser=User.new
    # puts("User input: #{:email}")
    # self.create
#     
  # end

  def create
    @defaultuser=User.new(user_params)
    puts("Current User: #{params[:user]}")
    puts("Email: #{@defaultuser.email}")
    if @defaultuser.save
      add_role :user
      puts("Inside user create function")
    end
    puts("outside user create function")
  end
  
  private
   # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    #params.permit(:email, :password)
    params.permit(:email, :password)
  end
end
