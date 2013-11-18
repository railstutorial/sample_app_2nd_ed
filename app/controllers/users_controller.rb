class UsersController < ApplicationController
  before_filter :signed_in_user,
                only: [:index, :edit, :update, :destroy, :following, :followers]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def toopher_create_pairing
    @user = User.find(params[:user_id])
    pairing_phrase = params[:pairing_phrase]
    toopher = ToopherAPI.new(ENV['TOOPHER_CONSUMER_KEY'], ENV['TOOPHER_CONSUMER_SECRET']) rescue nil

    if not session[:toopher_pairing_start]
      begin
        pairing = toopher.pair(pairing_phrase, @user.email)
      rescue
        return toopher_bad_pairing_phrase
      end
      session[:toopher_pairing_start] = Time.now
      session[:toopher_pairing_id] = pairing.id
    else
      pairing = toopher.get_pairing_status(session[:toopher_pairing_id])
    end

    if Time.now - session[:toopher_pairing_start] > 60
      return pairing_timeout
    end

    if pairing and pairing.enabled
      if @user.update_attribute(:toopher_pairing_id, session[:toopher_pairing_id])
        sign_in @user
        return toopher_pairing_enabled
      end
    end

    render :json => {:pairing_id => session[:toopher_pairing_id]}
  end

  def toopher_delete_pairing
    @user = User.find(params[:user_id])
    p "user = #{@user.inspect} | current_user = #{current_user.inspect}"
    if @user.update_attribute(:toopher_pairing_id, "")
      sign_in @user
      return toopher_pairing_disabled
    else
      render 'edit'
    end
  end

  private

    def toopher_pairing_disabled
      clear_toopher_session_data
      flash[:success] = "Toopher removed from this account."
      redirect_to edit_user_path(@user)
    end

    def toopher_pairing_enabled
      clear_toopher_session_data
      flash[:success] = "Toopher now active for this account."
      render :json => {:redirect => edit_user_path(@user)}
    end

    def pairing_timeout
      clear_toopher_session_data
      flash[:failure] = "Pairing timed out. Please try again."
      render :json => {:redirect => edit_user_path(@user)}
    end

    def toopher_bad_pairing_phrase
      clear_toopher_session_data
      flash[:failure] = "Incorrect pairing phrase. Please ensure you typed the pairing phrase correctly."
      render :json => {:redirect => edit_user_path(@user)}
    end

    def clear_toopher_session_data
      session.delete(:toopher_pairing_start)
      session.delete(:toopher_pairing_id)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
