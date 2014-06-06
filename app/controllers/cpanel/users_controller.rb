class Cpanel::UsersController < Cpanel::ApplicationController
  def index
    @users = User.order('id desc').paginate(per_page:20, page: params[:page])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
  end

  def update
    @user = User.find(params[:id])
    @user.email = params[:user][:email]
    @user.login = params[:user][:login]
    #@user.state = params[:user][:state]
    #@user.verified = params[:user][:verified]

    if @user.update_attributes(params[:user].permit!)
      redirect_to(edit_cpanel_user_path(@user.id), :notice => 'User was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @user = User.find(params[:id])
    #@user.soft_delete

    redirect_to(cpanel_users_url)
  end
end
