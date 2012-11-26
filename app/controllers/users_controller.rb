class UsersController < ApplicationController
  load_and_authorize_resource :except => [:index]
  respond_to :html, :json
   
  # GET /users
  def index
    authorize! :list, User
    respond_with(@users = User.all)
  end

  # GET /users/1
  def show
    respond_with(@user = User.find(params[:id]))
  end

  # GET /users/new
  def new
    @user = User.new
    respond_with(@user)
  end

  # POST /users
  def create
    @user = User.new
    assign_parameters()

    respond_to do |format|
      if @user.save
        format.html { redirect_to(@user, :notice => 'User was successfully created.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /users/1/edit
  def edit
    respond_with(@user = User.find(params[:id]))  
  end
  
  # PUT /users/1
  def update
    @user = User.find(params[:id])
    if assign_parameters
      flash[:notice] = t(:user_updated)
    end
    respond_with(@user)
  end

  # DELETE /users/1
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    respond_with(@user)
  end

private
  def assign_parameters
    if current_user.is_admin?
      return true if @user.assign_attributes(params[:user], :as => :admin)
    else
      return true if @user.assign_attributes(params[:user])
    end
  end
end
