# coding: utf-8

class HomeController < ApplicationController
  
  def index
    @slider = Position.find_by(slug: 'homepage slider').ads.available.limit(4)
    @items  = Item.pins.fields_in_list.limit(30).includes([:user, :comments]).order('id desc')
    @styles = Style.last.limit(5).includes([:user,:photos])
    @promotions = Promotion.today.pins.limit(10)
  end

end