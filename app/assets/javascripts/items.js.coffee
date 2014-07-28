window.Item =
  Like :
    toggle : () ->
      self = $(this)
      if self.hasClass('need-login')
        window.location.href = '/account/sign_in'

      if not self.hasClass('processing')
        count = $(this).siblings('.social-count')
        method = if self.hasClass('current-user-likes') then 'DELETE' else 'POST'

        $.ajax
          type: method,
          url: self.attr('href'),
          data: {},
          beforeSend : () ->
            self.addClass('processing')
            count.text('...')

          success : (responseHtml) ->
            count.text(responseHtml)
            self.removeClass('processing')
            self.toggleClass('current-user-likes')

      false

  Favourite : ()->
    self = $(this)
    $('#pop').modal()
    false

  Thumbnail :
    select : () ->
      src = $(this).find('img').attr('url')
      $('.zoom img').attr('src', src)
      $(this).addClass('active')
      $(this).siblings('.active').removeClass('active')

  share : ()->
    $.ajax
      dataType: 'html',
      url: $(this).attr('href'),
      success: (html) ->
        $('#share .modal-body').html( html )
        $('#share').modal()
    false


# Like or unlike a item
$(document).on 'click', '.navbar a.share', Item.share
$(document).on 'click', '.tools a.like', Item.Like.toggle
$(document).on 'mouseover', '.thumb li', Item.Thumbnail.select
$(document).on 'click', '.tools a.favourite', Item.Favourite