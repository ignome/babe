// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap.min
//= require users
//= require items
//= require social-share-button

function water(){
  var items = $('.items li'),
      width = 215 + 16,
      mxw = $('.container').eq(1).width(),
      cols = Math.round(mxw / width),
      tops = [];
  
  //init with 0
  for(var i=0; i<cols; i++) tops[i] = 0;

  $.each(items, function(i){
    var col = i % cols,
        row = Math.floor(i / cols),
        x = 0, y = 0;

    x = Math.floor(col * width);
    // on width not plus the space width 16
    //x += col == 0 ? 0 : 16;
    y = row > 0 ? tops[col] : 0;
    //y +=  20;//space
    tops[col] += items.eq(i).height() + 20;

    items.eq(i).css({left: x +'px', top: y + 'px'});
  });

  // more 50 for explore more ...
  var h = tops.sort(function(a,b){return a-b})[tops.length-1] + 50;
  
  items.parent().css('height', h +"px");
}

window.onload = water;
//window.onresize = water;