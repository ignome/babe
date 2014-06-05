<?php error_reporting(E_ALL ^ E_NOTICE); ?>
<?php require 'templates/header.inc.php';?>
<?php require 'include/db.inc.php';?>
<?php require 'include/page.php';?>

<div class="container">
  <div class="row">
    <div class="col-md-12">
      <form action="item.php" method="post" >
        <table class="table table-hover">
          <thead>
            <tr>
              <th><inpu type="checkbox" name="ids[]" /></th>
              <th></th>
              <th>网址</th>
              <th></th>
            </tr>
          </thead>

          <?php
          $limit  = 10;
          $page   = isset($_GET['page']) ? intval($_GET['page']) : 1;
          $offset = ($page - 1) * $limit;
          $result = mysql_query("select count(*) as total from task_links where status=0");
          $total  = mysql_fetch_array($result);

          $params = array(
                'total_rows'=> $total[0],
                'method'    =>'html',
                'parameter' =>'./items.php?page=[?]',
                'now_page'  => $page,
                'list_rows' => $limit);

          $pager = new Page($params);
          $result = mysql_query("select id,title,cover, url from task_links where status=0 limit $offset, $limit");
          
          while ($row = mysql_fetch_assoc($result)) {
          ?>
          <tr>
            <td><input type="checkbox" name="ids[]" value="<?php echo $row['id'];?>" /></td>
            <td><img src="<?php echo $row['cover'];?>" width="50" height="50" /></td>
            <td><a href="<?php echo $row['url'];?>" target="_blank"><?php echo $row['title'];?></a></td>
            <td><a href="./get-item.php?url=<?php echo urlencode($row['url']);?>">下载</a></td>
          </tr>
          <?php
          }
          mysql_free_result($result);
          mysql_close($conn);
          ?>
          <tr>
            <td colspan="4">
              <?php echo $pager->show(1);?>
            </td>
          </tr>
        </table>
      </form>
    </div>
  </div>
</div>