<div class="container">
  <div class="row">
    <div class="col-md-8 col-md-offset-2">
      <form action="pages.php" method="post" >
        <div class="form-group">
          <label  >网站</label>
          <label for="jd"><input type="radio" name="provider" id="jd" value="jd" >京东</label>
          <label for="tm"><input type="radio" name="provider" id="tm" value="tmall" >天猫</label>
          <label for="tb"><input type="radio" name="provider" id="tb" value="taobao" >淘宝</label>
        </div>

        <div class="form-group">
          <label  for="port">网址</label>
          <input type="text" name="url" class="form-control" id="url" placeholder="http://" >
        </div>

        <div class="form-group">
          <label  for="database">替换页码</label>
          <input type="text" name="symbol" class="form-control" id="symbol" placeholder="替换页码" value="">
        </div>

        <div class="form-group">
          <label  for="username">开始页码</label>
          <input type="text" name="start" class="form-control" id="start" placeholder="开始页码" value="">
        </div>

        <div class="form-group">
          <label  for="password">结束页码</label>
          <input type="text" name="end" class="form-control" id="end" placeholder="结束页码">
        </div>
        
        <div class="form-group pull-right">
          <button type="submit" class="btn btn-default" id="password-change">下一步</button>
        </div>
      </form>
    </div>
  </div>
</div>