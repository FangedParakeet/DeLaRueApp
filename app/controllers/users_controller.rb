class UsersController < ApplicationController
  
  before_filter :require_login, :only => [:show, :edit, :update, :destroy]
  
  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.js
      format.json { render json: @user }
    end
  end

  def new
    @user = User.new
    respond_to do |format|
      format.html
    end
  end
  
  def edit
    @user = User.find(params[:id])
    respond_to do |format|
      if @user
        format.js
      else
        format.html {render action: "edit"}
        format.json {render json: @user.errors}
      end
    end
  end

  def create
    parameters = params[:user]
    @user = User.new
    @user.email = parameters[:email]
    @user.password = parameters[:password]
    @user.password_confirmation = parameters[:password_confirmation]
    unless parameters[:firstname].empty?
      @user.firstname = parameters[:firstname]
      @user.display_name = true
    end
    unless parameters[:lastname].empty?
      @user.lastname = parameters[:lastname]
    end
    unless parameters[:username].empty?
      @user.username = parameters[:username]
      @user.use_uid = true
    end
    unless parameters[:city].empty?
      @user.city = parameters[:city]
      @user.display_location = true
    end
    unless parameters[:country].empty?
      @user.country = parameters[:country]
    end
    unless parameters[:user_type] == "Artist"
      @user.user_type = parameters[:user_type]
      @artist = Artist.new
    else
      @user.user_type = "Follower"
      @artist = false
    end
    
    respond_to do |format|
      if @user.save
        if @artist
          @artist.user_id = @user.id
          if @artist.save
            session[:id] = @user.id
            format.html { redirect_to main_url, notice: 'All set!' }
          else
            format.html { render action: "new" }
            format.json { render json: @artist.errors, status: :unproccessable_entity}
          end
        else
          session[:id] = @user.id
          format.html { redirect_to main_url, notice: 'All set!' }
        end
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unproccessable_entity}
      end
    end
  end

  def update
      if @user.user_type == "Artist"
        respond_to do |format|
          if @user.update_attributes(params[:user])
            if @user.user_type == "Fan"
              @user.artists.first.destroy
            end
            format.js
          else
            format.js {render json: @user.errors, status: :unprocessable_entity}
          end
        end
      else
        respond_to do |format|
          if @user.update_attributes(params[:user])
            if @user.user_type == "Artist"
              @artist = Artist.new
              @artist.user_id = @user.id
              if @artist.save
                session[:uid] = @user.id
                format.js
              else
                format.js {render json: @artist.errors, status: :unprocessable_entity}
              end 
            else
            format.js
            end
          else
            format.js {render json: @user.errors, status: :unprocessable_entity}
          end
        end
      end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.user_type == "Artist"
      @artist = @user.artists.first
    end
    @user.destroy
    @artist.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
end
