<?php

$html = "<html><head><link href=\"sgTranscriptCSS.css\" rel=\"stylesheet\" type=\"text/css\"/> <title></title></head><body class=\"gradientV\">";

//$html .= "This is my great new webpage! <br/><br/>";

//$name = $_GET['name'];





//$html .= "<br/><br/>GET STUFF:<br/><br/>";
foreach($_GET as $key => $value) {
//$html .= "$key-$value<br/>";
$name = $key; // apparantl this is where the name lives I guess?
}

/*
$html .= "<br/><br/>POST STUFF:<br/><br/>";
foreach($_POST as $key => $value) {
$html .= "$key-$value<br/>";
}
*/

//$html .= "this is the name of the file: " . $name . "<br/><br/>";

$url = "\"http://promweek.soe.ucsc.edu/sgTranscriptImages/" . $name . ".jpg\"";

$clickLink = "\"http://apps.facebook.com/promweek\"";

//$html .= "<br/><br/> this is the url: $url";

$logoURL = "\"http://promweek.soe.ucsc.edu/images/logo.png\"";
$playnowURL = "\"http://promweek.soe.ucsc.edu/images/clickToPlaySmall.png\"";

//$html .= "<center>";

$html .= "<div id=\"wrap\">";


$html .= "<div id=\"left\">";

$html .= "<br/><br/><a href=$clickLink> <img src=$logoURL height=\"20%\" width=\"60%\"  /> </a>";

$html .= "</div>";


$html .= "<div id=\"right\">";
$html .= "<br/><bR/><a href=$clickLink> <img src=$playnowURL height=\"20%\" width=\"60%\"   /></a>";
$html .= "</div>"; // close 'right'


$html .= "<div id=\"footer\">";
$html .= "<br/><bR/><a href=$clickLink> <img src=$url /></a>";
$html .= "</div>"; // close 'footer'

$html .= "</div>"; // close 'wrap'

//$html .= "</center>";


$newFileName = $name . ".html";

$html .= "</body></html>";


//echo $html;

$fp = fopen($newFileName, "wb");
fwrite($fp, $html);
fclose($fp);

?>