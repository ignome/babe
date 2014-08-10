# coding: utf-8

class HomeController < ApplicationController
  
  def index
    @slider = Ad.includes(:position).where("positions.slug= 'homepage slider'").references(:positions).limit(4)
    @items  = Item.pins.fields_in_list.limit(40).includes([:user, :comments]).order('id desc')
    @styles = Style.last.limit(5).includes([:user,:photos])
    @promotions = Promotion.pins.limit(10)

    set_seo_meta(Settings.seo.title, Settings.seo.keywords, Settings.seo.description)
  end

  def search
    render text: "comming soon!"
  end

end