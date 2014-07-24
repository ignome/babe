
var server = require('webserver').create(),
    webpage   = require('webpage'),
    system = require('system'),
    fs = require('fs');

if (system.args.length < 2){
  console.log('Usage: CrawlServer.js portNumber');
  phantom.exit(1);
}

var port = system.args[1];

service = server.listen(port, function(request, response){
  var html = '<html><head><title>PhantomJS</title></head><body>OK</body></html>';
  
  if ( request.method == 'POST'){
    var target = request.post.url;
    console.log('Request crawl : ' + target );
    var page = webpage.create();
        page.onLoadFinished =  function(){
            console.log('finished and closed');
            //page.close();
        }
        page.open(target, function(status){
          
          if ('success' == status){
            console.log('Request ' + target + ' is ' + status);
            
            h = page.evaluate(function(){
                var h = document.body.scrollHeight;
                window.document.body.scrollTop = h;
                return h;
            });
            console.log(h);

            html = page.content;
            
            response.statusCode = 200;
            //response.setEncoding('gbk');
            response.write(html);
            response.close();
            
          }
        });
    }
});