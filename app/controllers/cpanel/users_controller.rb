class Cpanel::UsersController < Cpanel::ApplicationController
  def index
    @users = User.order('id desc').paginate(per_page:20, page: params[:page])
  end

  def free
  end

  def admin
    if current_user.admin
      User.find(id: params[:id]).update_column(:admin, !params[:admin] )
      render nothing: true, status: 201
    else
      render text: 'failure'
    end
  end
end
