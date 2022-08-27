class AuthenticationsController < ApplicationController
  def create
    user = User.find_by(username: params[:username])

    if user.nil?
      user = User.new(user_params)

      if user.save
        session[:user_id] = user.id
        redirect_to root_path, notice: 'Successfully created user'
      else
        redirect_to root_path, flash: { error: user.errors.full_messages }
      end
    else
      if user.present? && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect_to root_path, notice: 'Logged in successfully'
      else
        redirect_to root_path, flash: { error: 'Invalid username or password' }
      end
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Logged out'
  end

  private

  def user_params
    params.permit(:username, :password)
  end
end