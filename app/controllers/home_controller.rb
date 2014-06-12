# coding: utf-8

class HomeController < ApplicationController
  
  def index
    @slider = Position.find_by(slug: 'homepage slider').ads.available.limit(4)
    @items  = Item.limit(50).order('id desc').includes([:user, :comments])
    @styles = Style.last.limit(5).includes([:user,:photos])
    @promotions = Promotion.today.limit(10)
  end

end
