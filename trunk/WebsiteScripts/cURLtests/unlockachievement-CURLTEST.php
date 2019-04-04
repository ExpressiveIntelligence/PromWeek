<?php 

echo("inserting achievement! Giving it aid of '4' and adding it to userId '6'");
$postdata = array('uuid'=>'6','aid'=>'4'); 

$ch = curl_init(); 
curl_setopt($ch, CURLOPT_URL,"http://promweek.soe.ucsc.edu/unlockachievement.php"); 
curl_setopt($ch, CURLOPT_POST,1); 
curl_setopt($ch, CURLOPT_POSTFIELDS, $postdata); 

$result=curl_exec ($ch);
curl_close ($ch);
?>
