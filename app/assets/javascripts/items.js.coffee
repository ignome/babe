window.Item =
  Like :
    toggle : () ->
      if $('.fav a.fav-toggle.processing').length == 0
        $link = $('.fav a.fav-toggle')

        $.ajax
          type: if $link.hasClass('current-user-likes') then 'DELETE' else 'POST',
          url: $link.attr('href'),
          data: {},
          beforeSend : () ->
            $('.fav-toggle').addClass('processing')
            $link.text('...')

          success : (responseHtml) ->
            $('.fav').replaceWith(responseHtml)

        false

  Thumbnail :
    select : () ->
      src = $(this).find('img').attr('url')
      $('.zoom img').attr('src', src)
      $(this).addClass('active')
      $(this).siblings('.active').removeClass('active')


# Like or unlike a item
$(document).on 'click', '.fav a.fav-toggle', Item.Like.toggle
$(document).on 'mouseover', '.thumb li', Item.Thumbnail.select