<?php 

echo("Grabbing the achievements data for a user with user id '1'<br>\n");
$postdata = array('uuid'=>'1'); 

$ch = curl_init(); 
curl_setopt($ch, CURLOPT_URL,"http://promweek.soe.ucsc.edu/getachievements.php"); 
curl_setopt($ch, CURLOPT_POST,1); 
curl_setopt($ch, CURLOPT_POSTFIELDS, $postdata); 

$result=curl_exec ($ch);
curl_close ($ch);

echo("\n<br>Grabbing the achievements data for a user with user id '2'<br>\n");
$postdata = array('uuid'=>'2'); 

$ch = curl_init(); 
curl_setopt($ch, CURLOPT_URL,"http://promweek.soe.ucsc.edu/getachievements.php"); 
curl_setopt($ch, CURLOPT_POST,1); 
curl_setopt($ch, CURLOPT_POSTFIELDS, $postdata); 

$result=curl_exec ($ch);
curl_close ($ch);
?>
