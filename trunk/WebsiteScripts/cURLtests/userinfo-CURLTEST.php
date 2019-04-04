<?php 

echo("Grabbing the data for a user with facebook id '123456789'<br>\n");
$postdata = array('uuid'=>'123456789'); 

$ch = curl_init(); 
curl_setopt($ch, CURLOPT_URL,"http://promweek.soe.ucsc.edu/userinfo.php"); 
curl_setopt($ch, CURLOPT_POST,1); 
curl_setopt($ch, CURLOPT_POSTFIELDS, $postdata); 

$result=curl_exec ($ch);
curl_close ($ch);
?>
