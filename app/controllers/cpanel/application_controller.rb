# coding: utf-8
class Cpanel::ApplicationController < ApplicationController
  layout "cpanel"
  
  before_filter :authenticate_user!
  before_filter :require_admin

  def require_admin
    if !current_user.admin
      render_403
    end
  end

end