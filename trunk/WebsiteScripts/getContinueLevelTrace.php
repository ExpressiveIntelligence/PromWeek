<?php
include("toolkit.php");
//require_once('FirePHPCore/FirePHP.class.php');
ob_start();

//$firephp = FirePHP::getInstance(true);
//$firephp->log("At the top of getContinueLevelTRace seen");

if($_GET) {
	//$firephp->log("Inside the first PoSt");
	// $firephp->log($_GET, "this is the contents of get, I think?");
    if ($_GET['UUID']) {
		//$firephp->log("Inside the second PoSt");
        $traceXMLString = getContinueLevelTrace($_GET['UUID']);
		//$firephp->log($traceXMLString, "The level trace.");
		header("Content-Type: text/xml");
		echo $traceXMLString;
        // echo "doneFile=".urlencode($info);
    } else {
		//$firephp->log("no uuid I guess... hmm, Iwonder about the capitilization of uuid maybe");
        echo("Query formulated incorrectly, please refer to the documentation for usage<br>\n");
    }
} else {
//$firephp->log("No post at all, perhaps");
echo("No Post");
}

?>
