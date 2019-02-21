class AuthController < ApplicationController
  skip_before_action :authenticate_request

  def authenticate
    command = AuthenticateUser.call(params[:username], params[:password])
    
    if command.success?
      user = User.find_by(username: params[:username])
      response = {
        name: user.name,
        access: user.access,
        auth_token: command.result
      }
      render json: response, status: 200
    else
      render json: { error: command.errors }, status: :unauthorized
    end
  end

#  def create
#    if params[:username] && params[:password]
#      user = User.find_by(username: params[:username])

#      if user && user.authenticate(params[:password])
#        response = {
#          name: user.name,
#          access: user.access
#        }
#        render json: response, status: 200
#      else
#        render json: { error: 'Dados inválidos.' }, status: :unauthorized
#      end
#    else
#      render json: { error: 'Dados inválidos.' }, status: :unauthorized
#    end
#  end

end
