class Cpanel::UsersController < Cpanel::ApplicationController
  def index
    @users = User.order('id desc').paginate(per_page:20, page: params[:page])
  end

  def suspend
  end

  def free
  end
end
