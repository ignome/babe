class HelpController < ApplicationController
  def index
    @pages = Page.recent.limit(10)
  end

  def about
    @catalog = Catalog.find_by(slug: params[:slug])
    @page = @catalog.pages.first if @catalog
  end
end
