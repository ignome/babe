class ProfileController < ApplicationController
  
  before_action :authenticate_user!

  def edit
    @user = current_user
    render 'account/password'
  end

  def update
    @user = User.find(current_user.id)
    if params[:password].to_s.length < 5 || params[:password] != params[:confirm_password]
      @user.errors.add(:password, '两次密码不同')
      render 'account/password'
    else
      if @user.update_with_password(params.require(:user).permit(:password, :current_password, :password_confirmation))
        sign_in @user, :bypass => true
        redirect_to account_password_path, notice: 'password had been changed'
      else
        render 'account/password'
      end
    end
  end

  def avatar
    @user = current_user
    render "account/avatar"
  end

  def upload
    @user = current_user
    if params[:user]
      @user.avatar = params[:user][:avatar]
      if @user.save
        redirect_to edit_user_registration_path, :notice => 'update avatar success'
      end
    else
      redirect_to edit_user_registration_path, :alert => 'update avatar error'
    end
  end

  def cover
    @user = current_user
    @user.cover = params[:files]
    
    if @user.save
      render json: [0, @user.cover.default.url].to_json
    else
      render json: [-1, 'error'].to_json
    end
  end
end