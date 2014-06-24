module ItemsHelper
  def who_liked_this?(target)
    if current_user 
      target.who_liked(current_user.id) ? 'current-user-likes' : 'current-user-liked'
    else
      'need-login'
    end
  end

  def render_buy_tag url
    # secret+"app_key"+app_key+"timestamp"+timestamp+secret, secret
    app_secret = 'e1274b605c5bf851f78871d2668e854a'
    app_key = '21744169'
    key = "#{app_key}"
    if /(taobao|tmall)\.com/.match url
      id = /id=(\d+)/.match url
      raw %Q{<a data-type="0" biz-itemid="#{id[1]}" data-tmpl="192x40" data-tmplid="625" data-rd="2" data-style="2" data-border="1" href="#{url}">去购买</a>}
    else
      link_to '去购买', url
    end
  end
end