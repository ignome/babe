# coding: utf-8

class HomeController < ApplicationController
  
  def index
    @slider = Position.find_by(slug: 'homepage slider').ads.available.limit(4)
    @items  = Item.all()
    @styles = Style.last.limit(5)
    @promotions = Promotion.today.limit(10)
  end

end
