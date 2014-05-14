module ItemsHelper
  def who_liked_this?(target)
    if current_user 
      target.who_liked(current_user.id) ? 'current-user-likes' : 'current-user-liked'
    else
      'need-login'
    end
  end
end