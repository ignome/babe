require 'net/http'
require 'nokogiri'

class Cpanel::TasksController < Cpanel::ApplicationController

  # items
  def index
    @items = TaskLink.available.order('id desc').paginate(per_page: 15, page: params[:page])
  end

  # for enter the link of page
  def new
  end

  # render the links of the page
  def create
    url   = params[:url]
    first = params[:start].to_i
    last  = params[:end].to_i
    pages = []

    if /jd\.com/.match(url)
       for page in first..last do
          pages << (url.sub /page=(\d+)/, "page=#{page}")
       end
    end

    if /tmall\.com/.match(url)
      while first < last do
        s = (first - 1) * 60
        pages << (url.sub /s=\d+/, "s=#{s}")
        first += 1
      end
    end

    if /taobao\.com/.match(url)
      for page in first..last do
        s = (page -1) * 96
        pages << (url.sub /&s=\d+/, "&s=#{s}")
      end
    end


    while not pages.empty? do
      news = pages.pop(10).collect{|u| {url: u}}
      TaskPage.create news
    end

    redirect_to pages_cpanel_tasks_path, notice: 'Genereated page success'
  end

  def promotion
    @items = Promotion.all.paginate(per_page:15, page: params[:page])
  end

  def todaypromo
    # Got the link of promotion site
    url = 'http://te.tejia.taobao.com/tenV2.htm?spm=a3109.2211525.0.0.JGDpv2&&nid=7984'
    page = Nokogiri::HTML(open(url), nil, 'GBK')
    item = []

    page.css('ul.clrfix li.par-item').each do |li|
      a = Hash.new
      a[:url] = li.css('dt a').attr('href').value
      a[:cover] = li.css('dt img').attr('src').value
      a[:title] = li.css('dd.title a').text
      a[:price] = li.css('dd strong').text
      a[:mprice] = li.css('dd del').text
      item << a
    end

    if item
      while not item.empty?
        Promotion.create item.pop(10)
      end
    else

    end

    redirect_to promotion_cpanel_tasks_path, notice: 'today promotion done'
  end

  def setpromo
  end

  def cancelpromo
  end

  def pages
    @pages = TaskPage.available.paginate(per_page:10, page: params[:page])
  end

  # crawl the items from the page
  def link2items
    links = TaskPage.where(['id in (?)', params[:id] ])

    links.each do |link|
      response = Net::HTTP.post_form(URI('http://localhost:8088'), {'url' => link.url})
      page = Nokogiri::HTML(response.body, nil, 'GBK')
      item = []

      if /jd\.com/.match link.url
        page.css('ul.list-h div.lh-wrap').each do |li|
          a = Hash.new
          a['url']   = li.css('div.p-img a').attr('href').value
          a['cover'] = li.css('div.p-img img').attr('data-lazyload').value
          a['title'] = li.css('div.p-name a').children[0].text.strip
          a['price'] = li.css('div.p-price strong').text.sub! /\D/,''
          item << a
        end
      elsif /tmall\.com/.match link.url
        page.css('div#J_ItemList div.product').each do |p|
          a = Hash.new
          a['url'] = p.css('div.productImg-wrap a').attr('href').value
          a['cover']  = p.css('div.productImg-wrap img').attr('src').value
          a['title'] = p.css('p.productTitle a').text.strip
          a['price'] = p.css('p.productPrice em').attr('title').value
          item << a
        end
      else
        page.css('div.m-items li.item').each do |li|
          a = Hash.new
          a['url'] = li.css('a.J_AtpLog').attr('href').value
          a['cover'] = li.css('img.J_ItemMainImg').attr('src').value
          a['title'] = li.css('li.title a.J_AtpLog').children[0].text
          a['price'] = li.css('li.price strong').text
          item << a
        end
      end

      if item
        while not item.empty?
          TaskLink.create item.pop(10)
        end
        TaskPage.update_all("status=1", ["id in (?)", params[:id]])
        Rails.logger.info "create items of link #{link.url}"
      else
        Rails.logger.debug "empty items of link #{link.url}"
      end        
    end
    if request.xhr?
      render nothing: true, status: 201
    else
      redirect_to pages_cpanel_tasks_path
    end
  end

  def destroy
  end

end