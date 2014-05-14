<?php
error_reporting(E_ALL ^ E_NOTICE);
// crawl items rom page
require 'include/db.inc.php';
require 'include/mycurl.php';

if ( isset($_POST['ids']) && is_array($_POST['ids']) ){
  $ids = implode(',', $_POST['ids']); 
}

if ( isset($_GET['id']) && $id = intval($_GET['id']) ){
  $ids = $id;
}

$result = mysql_query("select id, url from task_pages where status=0 and id in ($ids);");

while ($row = mysql_fetch_assoc($result)) {
  
  echo 'crawl '. $row['url'].'<br>';

  if (preg_match('/jd\.com/', $row['url'])){
    //crawl all items in url
    echo 'jd.com matched <br/>';

    $item = parse_jd_item($row['url']);

  }elseif( preg_match('/tmall\.com/', $row['url'])){
    $item = parse_tm_item($row['url']);


  }elseif( preg_match('/taobao\.com/', $row['url'])){
    $item = parse_tb_item($row['url']);
  }

  //set as crawled if done
  if( $item ){
    //mysql_query("update pages set status=1 where id=$row['id'];");
    for($i=0, $e=count($item); $i < $e; $i++){
      echo "<br/>". $item[$i][2];
      mysql_query("insert into task_links( url,title, cover) values('".$item[$i][1]."', '".$item[$i][2]."','".$item[$i][3]."');");
    }
    mysql_query("update task_pages set status=1 where id=". $row['id']);
  }
}

mysql_free_result($result);

// array( 'url', 'title', 'thumbnail' )
function parse_jd_item($url){
  $html = crawl($url);

  // ul class='list-h'
  $found = preg_match('|<ul class=\\\\"list-h\\\\">(.*)</ul></div>|s', $html, $block);
  //print_r($block[1]);
  //print_r($block);
  if($found){
    $li = preg_match_all('|<div class=\\\\"p-img\\\\"><a target=\\\\"_blank\\\\" href=\\\\"([^"]+)\\\\"><img width=\\\\"220\\\\" height=\\\\"220\\\\" alt=\\\\"([^"]+)\\\\" data-lazyload=\\\\"([^"]+)\\\\" [^>]+>|ms', $block[1], $out, PREG_SET_ORDER);
    if( $li ){
      //echo count($li[1]);
      //print_r($out);
      //return array($out[0], $out[1], $out[2]);
      return $out;
    }
  }
  return array();
}

function parse_tb_item($url){

}

function parse_tm_item($url){

}

function crawl($url){
  $curl = new mycurl($url);
  $curl->createCurl();
  return $curl->response();
}
?>