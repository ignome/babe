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

  def render_404
    @page_body_id = "page-not-found"
    render_optional_error_file(404)
  end

  def render_403
    render_optional_error_file(403)
  end

  def render_optional_error_file(status_code)
    status = status_code.to_s
    if ["404","403", "422", "500"].include?(status)
      render :template => "/errors/#{status}", :format => [:html], :handler => [:erb], :status => status, :layout => "application"
    else
      render :template => "/errors/unknown", :format => [:html], :handler => [:erb], :status => status, :layout => "application"
    end
  end
end