
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
                h = document.body.scrollHeight;
                window.document.body.scrollTop = h;
            }

            html = page.content;
            //console.log(html);
            /*
            file = fs.open( request.post.id + '.html', 'w');
            file.write(page.content);
            file.close();
            //*/
            response.statusCode = 200;
            //response.setEncoding('gbk');
            response.write(html);
            response.close();

            //page.sendEvent('mousemove', 100, 2000);
            /*
            var h =0;

            interval = window.setInterval(function(){
                s = page.evaluate(function(){
                    t = window.document.body.scrollTop += 450;
                    h = document.body.scrollHeight;
                    return h;
                });

                h += 450;
                console.log(h + '==' + s);
                //if( s[0] >= s[1] ) {
                    //clearInterval(interval);
                
                if( h >= s){
                    clearInterval(interval);
                    
                    console.log('--------------------');
                    page.render('html.png');
                    
                }
                //page.sendEvent('mousemove', 100, h);
            }, 2000);
            */
            
          }

        });
    }
});