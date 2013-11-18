class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.toopher_enabled?
        toopher_auth(user)
      else
        pass_login(user)
      end
    else
      fail_login
    end
  end

  def toopher_auth(user=nil)
    toopher = ToopherAPI.new(ENV['TOOPHER_CONSUMER_KEY'], ENV['TOOPHER_CONSUMER_SECRET']) rescue nil

    terminal_name = user.toopher_terminals.where(:cookie_value => cookies[:toopher]).first.terminal_name rescue nil
    if terminal_name.nil?
      return name_terminal
    end

    if not session[:toopher_auth_start] # we have a request pending
      begin
        auth_status = toopher.authenticate(user.toopher_pairing_id, terminal_name, 'login', { terminal_name_extra: cookies[:toopher] })
      rescue
        return fail_login
      end
      session[:toopher_auth_start] = Time.now
      session[:toopher_auth_id] = auth_status.id
    else
      auth_status = toopher.get_authentication_status(session[:toopher_auth_id])
    end

    if (Time.now - session[:toopher_auth_start] > 60)
      return toopher_timeout
    end

    if !auth_status.pending
      if auth_status.granted
        return pass_login(user)
      else
        return fail_login
      end
    end

    render :json => { :pairing_id => session[:toopher_pairing_id] }
    return
  end

  def destroy
    sign_out
    clear_toopher_session_data
    redirect_to root_url
  end

  def pass_login(user)
    clear_toopher_session_data
    sign_in user
    flash[:success] = 'Logged in successfully.'
    render :json => {:redirect => user_path(user)}
  end

  def fail_login
    clear_toopher_session_data
    flash[:failure] = 'Invalid email/password combination.'
    render :json => {:redirect => signin_path}
  end

  def toopher_timeout
    clear_toopher_session_data
    flash[:failure] = 'Toopher authentication timed out. Please allow the request from your mobile device.'
    render :json => {:redirect => signin_path}
  end

  def name_terminal
    clear_toopher_session_data
    render :json => { :exception => "no_terminal" }
  end

  def clear_toopher_session_data
    session.delete(:toopher_auth_start)
    session.delete(:toopher_auth_id)
  end
end
