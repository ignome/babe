<?php
require 'include/mycurl.php';

$url = 'http://list.taobao.com/itemlist/baby.htm?_input_charset=utf-8&json=on&cat=50023997&isprepay=1&user_type=0&viewIndex=1&as=0&atype=b&style=grid&same_info=1&olu=yes&isnew=2&src_t=home&tid=0&pSize=96&data-key=s&data-value=192&data-action&module=page&_ksTS=1400145645485_703&callback=jsonp704';
//*
$curl = new mycurl($url);
$curl->createCurl();
$html = trim($curl->response());

$json = json_decode( iconv('GBK', 'utf-8', substr($html, strpos($html, '(') + 1, -1) ) , true) ;
$items = $json['itemList'];
print_r($items[0]);
/*
for($i=0, $e=count($items); $i < $e; $i++){
	echo '<br>'.$i.'==='.$items[$i]['title'];
	echo $items[$i]['currentPrice']
	$url = $items[$i]['href'];
	$cover = $items[$i]['image'];

}
//*/
