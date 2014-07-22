#coding:utf-8
require 'net/http'
require 'nokogiri'

class Cpanel::TasksController < Cpanel::ApplicationController

  before_filter :set_page, only: [:recommend, :cancel]
  # items
  def index
    #@items = TaskLink.available.order('id desc').paginate(per_page: 15, page: params[:page])
    @pages = TaskPage.available.paginate(per_page:10, page: params[:page])
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
        s = (first - 1) * 30
        pages << (url.sub /s=\d+/, "s=#{s}")
        first += 1
      end
    end

    if /taobao\.com/.match(url)
      for page in first..last do
        s = (page -1) * 30
        pages << (url.sub /&s=\d+/, "&s=#{s}")
      end
    end


    while not pages.empty? do
      news = pages.pop(10).collect{|u| {url: u}}
      TaskPage.create news
    end

    redirect_to cpanel_tasks_path, notice: 'Genereated page success'

  end

  def promotion
    @items = Promotion.order('id desc').paginate(per_page:15, page: params[:page])
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

  def recommend
    Promotion.where('id in (?)', params[:id]).update_all('status=status+1')
    redirect_to promotion_cpanel_tasks_path(page: params[:page]), notice: 'Recommend success'
  end

  def cancel
    Promotion.where('id in (?)', params[:id]).update_all('status=0')
    redirect_to promotion_cpanel_tasks_path(page: params[:page]), notice: 'Cancel recommend success'
  end

  def fetch
    links = TaskPage.find(params[:id])
    Rails.logger.info '*' * 80
    #begin
      links.each do |link|
        Rails.logger.info link.url
        response = Net::HTTP.post_form(URI('http://localhost:8088'), {'url' => link.url})
        html = response.body.force_encoding('GBK')
        page = Nokogiri::HTML(html, nil, 'utf-8')
        urls = []

        if /jd\.com/.match link.url
          page.css('ul.list-h div.lh-wrap').each do |div|
            urls << div.css('div.p-img a').attr('href').value
          end
        elsif /tmall\.com/.match link.url
          page.css('div#J_ItemList div.product').each do |p|
            url = p.css('div.productImg-wrap a').attr('href').value
            url = "http:#{url}" if not url.start_with?('http')
            urls << url
          end
        else
          slug = link.url.split('.')[0][7..-1]
          if "s" == slug
            page.css('div.tb-content .item').each do |div|
              urls << div.css('h3.summary a').attr('href').value
            end
          else
            page.css('div.m-items li.item').each do |li|
              urls << li.css('a.J_AtpLog').attr('href').value
            end
          end
        end

        # Get the item from url
        Rails.logger.info '#' * 80
        
        urls.each do |url|
          item  = Item.parse(url)
          Rails.logger.info url
          Rails.logger.info item.id.to_i
          if nil == item
            Rails.logger.info 'item not found'
          elsif item.id.to_i > 0
            Rails.logger.info 'item was already exists'
          else
            # A random user, id > 1,000 and < 10,000
            #rand(900) + 100
            item.user_id = 1
            item.save
          end
        end
      end

    #rescue Exception => e
      Rails.logger.info '*' * 80
      Rails.logger.info e.message
    #end
    # Set as finished
    #TaskPage.where(["id in (?)", params[:id]]).update_all("status=1")

    #render text: 'done'
    redirect_to cpanel_tasks_path, notice: '采完了'

  end

  def destroy
    TaskPage.find(params[:id]).destroy
    redirect_to cpanel_tasks_path(page: params[:page]), notice: 'remove a crawl page'
  end

  private

  def set_page
    params[:page] = params[:page].to_i > 0 ? params[:page] : 1
  end
end
