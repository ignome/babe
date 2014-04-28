# coding: utf-8

class HomeController < ApplicationController
  
  def index
    @items  = Item.all()
    @styles = Style.last.limit(4)
  end

end
