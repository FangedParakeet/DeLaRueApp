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
    @user = User.new(params[:user])
    if @user.type == "Artist"
      @artist = Artist.new
    else
      @artist = nil
    end

    respond_to do |format|
      if @artist
        if @user.save
          @artist.user_id = @user.id
          if @artist.save
            session[:uid] = @user.id
            format.html { redirect_to main_url, notice: 'User was successfully created.' }
          else
            format.html { render action: "new" }
            format.json { render json: @artist.errors, status: :unprocessable_entity }
          end
        else
          format.html { render action: "new" }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      else
        if @user.save
          session[:uid] = @user.id
          format.html { redirect_to main_url, notice: 'User was successfully created.' }
          format.json { render json: @user, status: :created, location: @user }
        else
          format.html { render action: "new" }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def update
      if @user.type == "Artist"
        respond_to do |format|
          if @user.update_attributes(params[:user])
            if @user.ftype == "Fan"
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
            if @user.type == "Artist"
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
    if @user.type == "Artist"
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
