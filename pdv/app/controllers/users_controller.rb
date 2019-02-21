class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    if params[:username] && params[:password]
      user = User.find_by(username: params[:username])

      if user && user.authenticate(params[:password])
        response = {
          name: user.name,
          access: user.access
        }
        render json: response, status: 200
      else
        render json: { error: 'Dados inválidos.' }, status: :unauthorized
      end
    else
      render json: { error: 'Dados inválidos.' }, status: :unauthorized
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:username, :password, :access, :name)
    end
end
