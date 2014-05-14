<?php
require 'include/mycurl.php';

$server = 'http://localhost/api/item/get?url='.urldecode($_GET['url']);

$curl = new mycurl($server);
//$curl->setPost(array('url' => urldecode($_GET['url'])));
$curl->createCurl();
?>