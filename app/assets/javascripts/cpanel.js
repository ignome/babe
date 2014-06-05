//= require jquery
//= require jquery_ujs
//= require bootstrap.min
//= require_self

$(document).on('click', '#chkall', function(){
  checked = $(this).prop('checked');
  $('input[type="checkbox"]').prop('checked', checked);
});