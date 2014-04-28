# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
window.User=
  Follow : 
    toggle : () ->
      $link = $('.user a.follow')
      method = if $link.hasClass('followed-by-current-user') then 'POST' else 'DELETE'

      $.ajax 
        type : method,
        data : {},
        url  : $link.attr('href'),
        beforeSend : () ->
          $link.addClass('processing')
        success : () ->
          $link.toggleClass('followed-by-current-user')
        always : () ->
          $link.removeClass('processing')

      false

$('document').on 'click', '.user a.follow', User.Follow.toggle