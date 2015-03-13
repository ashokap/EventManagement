class AccountsController < ApplicationController
      
  def index
    @account = current_user.account
       
    if(@account.nil?)
      if(current_user.has_role? :admin)
        redirect_to new_account_path, :notice => "No Account details found. Please Create one"
      else
        redirect_to events_path, :alert => "No Account details found. Please inform administrator to create one"
      end
    else
           
      puts("Current account's image url: #{@account.file_url}")
      #fetch all users
      @users =  current_user.account.users
    end
     
  end


  
  def show
  end

  
  def new
    @account=Account.new
  end

def create
    @account=Account.new(account_params)
    
    if @account.save
      current_user.account=@account
      current_user.save
      redirect_to accounts_url
    else
      render 'new', :error =>"#{@account.errors.full_messages}"
    end
    
  end
  
  def edit
    @account = Account.find(params[:id])
  end
  
  def update
    @account = Account.find(params[:id])
    respond_to do |format|
      if @account.update(account_params)
       format.html { redirect_to accounts_path, :notice => "Account updated." }
      else
        format.html { render action: 'edit' }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
  def account_params
    params.require(:account).permit(:name,:company, :file, :remove_file)
  end
 
end
