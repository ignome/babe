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

function water(){
  var items = $('.items li'),
      width = 215,
      mxw = $('.container').eq(1).width(),
      cols = Math.floor(mxw / (width + 4)),
      tops = [];
  
  //init with 0
  for(var i=0; i<cols; i++) tops[i] = 0;

  $.each(items, function(i){
    col = i % cols;
    row = Math.floor(i / cols);

    x = Math.floor(col * width);
    x += col == 0 ? 0 : 16 * col;
    y = row > 0 ? tops[col] : 0;
    y += row * 20;//space

    tops[col] += items.eq(i).height();
    items.eq(i).css({left: x +'px', top: y + 'px'});
  });

  h = tops.sort(function(a,b){return a-b})[tops.length-1] + Math.floor( items.length / cols * 20 );
  console.log(h);
  
  items.parent().css('height', h +"px");
}

window.onload = water;
window.onresize = water;