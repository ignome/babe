window.User=
  Follow : 
    toggle : () ->
      if $('body').hasClass "signin"
        $link = $('.user a.follow')
        method = if $link.hasClass('followed-by-current-user') then 'DELETE' else 'POST'

        $.ajax 
          type : method,
          data : {},
          url  : $link.attr('href'),
          beforeSend : () ->
            $link.addClass('processing')
          success : (data,xhr) ->
            console.log(data);
            console.log(xhr);
            $link.toggleClass('followed-by-current-user')
            label = if 'POST' == method then '取消关注' else '加关注'
            $link.find('span').html(label)
          always : () ->
            $link.removeClass('processing')
      else
        window.location.href = "/account/sign_in"

      false

$(document).on 'click', '.user a.follow', User.Follow.toggle