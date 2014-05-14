window.User=
  Follow : 
    toggle : () ->
      $link = $('.user a.follow')
      method = if $link.hasClass('followed-by-current-user') then 'DELETE' else 'POST'

      $.ajax 
        type : method,
        data : {},
        url  : $link.attr('href'),
        beforeSend : () ->
          $link.addClass('processing')
        success : () ->
          $link.toggleClass('followed-by-current-user')
          label = if 'POST' == method then '取消关注' else '加关注'
          $link.find('span').html(label)
        always : () ->
          $link.removeClass('processing')

      false

$(document).on 'click', '.user a.follow', User.Follow.toggle