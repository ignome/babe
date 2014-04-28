module UsersHelper
  def user_avatar_width_for_size(size)
    case size
      when :small then 24
      when :normal then 48
      when :middle then 32      
      when :large then 64
      when :big then 80
      else size
    end
  end

  def user_avatar_tag(user, size = :normal, opts = {})
    link = opts.has_key?(:link) ? opts[:link] : true
    #klass = opts[:class] || 'author-avatar-link'
    width = user_avatar_width_for_size(size)

    src = user[:avatar].blank? ?  "/images/avatar-default.gif" : user.avatar.url
    img = image_tag(src, alt: user[:name], class: "photo", size: "#{width}x#{width}")
    
    if opts[:text] 
      img << user.name
    end 

    if link
      raw %(<a href="#{user_path(user.login)}" class="url" rel="contact" title="#{user.name}">#{img}</a>)
    else
      img
    end
  end

  def follow_or_unfollow user
    return if current_user && current_user.id == user.id
    
    if current_user && current_user.followed(user)
      link_to content_tag(:span, t('users.unfollow')), user_follow_path(user.login), method: 'DELETE'
    else
      link_to content_tag(:span, t('users.follow')), user_follow_path(user.login)
    end
  end

end
