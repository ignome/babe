module ItemsHelper
  def who_liked_this?
    if current_user 
      @item.who_liked(current_user.id) ? 'current-user-likes' : 'current-user-liked'
    else
      'need-login'
    end
  end
end