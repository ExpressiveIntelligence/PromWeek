<?php 
$app_id = "229227247093324";
$canvas_page = "http://apps.facebook.com/promweek/";

$auth_url = "https://www.facebook.com/dialog/oauth?client_id=" . $app_id . "&redirect_uri=" . urlencode($canvas_page) . "&scope=email,read_stream";

$signed_request = $_REQUEST["signed_request"];
list($encoded_sig, $payload) = explode('.', $signed_request, 2); 

$data = json_decode(base64_decode(strtr($payload, '-_', '+/')), true);
if (empty($data["user_id"])) {
       echo("<script> top.location.href='" . $auth_url . "'</script>");
} else {
  ?>
  <html xmlns="http://www.w3.org/1999/xhtml" xmlns:fb="http://www.facebook.com/2008/fbml">
  	<head>
  	 	<!-- Include support librarys first -->
  		<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/swfobject/2.2/swfobject.js"></script>
  		<script type="text/javascript" src="http://connect.facebook.net/en_US/all.js"></script>

  		<script type="text/javascript">	
  			//Note we are passing in attribute object with a 'name' property that is same value as the 'id'. This is REQUIRED for Chrome/Mozilla browsers		
  			swfobject.embedSWF("TheProm.swf", "FlashContent", "760", "600", "9.0", null, null, {wmode:"opaque"}, {name:"FlashContent"});
  		</script>
  		
  		<style type="text/css">
  		  body {
  		    margin: 0px;
  		    height: 600px;
  		    width: 760px;
  		  }
  		  
  		  #FlashContent {
  		    overflow: hidden;
  		  }
  		</style>
  	</head>
  	<body>
  		<div id="fb-root"></div><!-- required div tag -->
  		<div id="FlashContent"></div>
  	</body>
  </html>
<?
} 
?>