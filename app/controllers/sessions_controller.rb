class SessionsController < ApplicationController
  
  def new
    respond_to do |format|
      format.html
    end
  end
 
  def create
    login = params[:username]
    user = User.find_by_email(login)
    unless user
      user = User.find_by_username(login)
    end
    if user
      if user.authenticate(params[:password])
        session[:uid] = user.id
        redirect_to main_url, notice: "Welcome!"
      else
        flash[:notice] = "Try again"
        render 'new'
      end
    else
      flash[:notice] = "Try again"
       render 'new'
    end
  end

  def destroy
    reset_session
    redirect_to root_url, notice: "Bye!"
  end
  
end