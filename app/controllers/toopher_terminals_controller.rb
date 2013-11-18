class ToopherTerminalsController < ApplicationController
  # GET /toopher_terminals
  # GET /toopher_terminals.json
  def index
    @toopher_terminals = ToopherTerminal.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @toopher_terminals }
    end
  end

  # GET /toopher_terminals/1
  # GET /toopher_terminals/1.json
  def show
    @toopher_terminal = ToopherTerminal.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @toopher_terminal }
    end
  end

  # GET /toopher_terminals/new
  # GET /toopher_terminals/new.json
  def new
    @toopher_terminal = ToopherTerminal.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @toopher_terminal }
    end
  end

  # GET /toopher_terminals/1/edit
  def edit
    @toopher_terminal = ToopherTerminal.find(params[:id])
  end

  # POST /toopher_terminals
  # POST /toopher_terminals.json
  def create
    @user = User.find_by_email(params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      @toopher_terminal = ToopherTerminal.new(:terminal_name => params[:terminal_name])
      @toopher_terminal.user = @user
      if cookies[:toopher]
        @toopher_terminal.cookie_value = cookies[:toopher]
      else
        @toopher_terminal.cookie_value = SecureRandom.hex(32).to_s
        cookies[:toopher] = @toopher_terminal.cookie_value
      end
      @toopher_terminal.save
      # format.json { render json: @toopher_terminal }
      render :json => { :terminal => @toopher_terminal.cookie_value }
      return
    else
      render :json => { :errors => @toopher_terminal.errors, status: :unprocessable_entity }
      return
    end
  end

  # PUT /toopher_terminals/1
  # PUT /toopher_terminals/1.json
  def update
    @toopher_terminal = ToopherTerminal.find(params[:id])

    respond_to do |format|
      if @toopher_terminal.update_attributes(params[:toopher_terminal])
        format.html { redirect_to @toopher_terminal, notice: 'Toopher terminal was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @toopher_terminal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /toopher_terminals/1
  # DELETE /toopher_terminals/1.json
  def destroy
    @toopher_terminal = ToopherTerminal.find(params[:id])
    @toopher_terminal.destroy

    respond_to do |format|
      format.html { redirect_to toopher_terminals_url }
      format.json { head :no_content }
    end
  end
end
