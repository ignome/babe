<?php
error_reporting(E_ALL ^ E_NOTICE);
require 'templates/header.inc.php';
?>

<?php
if ( !empty($_POST['url']) ){
  require 'include/db.inc.php';

  $provider = $_POST['provider'];
  $start = intval($_POST['start']);
  $end   = intval($_POST['end']);
  $url = $_POST['url'];
  $values = array();

  // page=n, n=pages
  if( 'jd' == $provider ){
    for($page = $start; $page <= $end; $page++){
      // save on each 10 pages
      $values[] = preg_replace('/page=(\d+)/', "page=$page", $url);
    }
  // s=n, n = page * 60
  }elseif ( 'tmall' == $provider ){
    for($page = $start; $page <= $end; $page++){
      $pages = 60 * $page -1;
      $values[] = preg_replace("/s=\d+/", "s=$pages", $url);
    }

  // s=n, n = page * 96
  }elseif ( 'taobao' == $provider ){
    for($page = $start; $page <= $end; $page++){
      $pages = 96 * $page -1;
      $values[] = preg_replace("/s=\d+/", "s=$pages", $url);
    }
  }else{
    echo "<h2> Not supported </h2>";
  }

  // saving into db on batch 10
  $new = array_chunk($values, 10);
  for($i = 0, $e = count($new); $i < $e; $i++){
    $urls = implode("'),('", $new[$i]);
    ///*
    $result = mysql_query("insert into task_pages(url) values('$urls');");
    //mysql_query("insert into pages values($urls);");
 
    if (!$result) {
      die('Invalid query: ' . mysql_error());
    }
    //*/
    echo $urls;
  }

}
?>
<?php require 'templates/pages.inc.php'; ?>
<?php require 'templates/footer.inc.php'; ?>