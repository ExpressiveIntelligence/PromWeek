<?php
include("toolkit.php");
#//require_once('FirePHPCore/FirePHP.class.php');
#ob_start();
/*receives a Level Trace. The XML file *must* be passed in via $_POST
 * and under the entry $_POST['leveltracedata']. $_POST also must 
 * contain the following elements for this to work:
 * UUID - the un-hashed UUID of the player
 * TURNS - number of turns
 * STORY - what story they are playing
 * LEVEL - what level they are on
 * RULESTRUE - what rules were true
 *
 */
ob_start();
//$firephp = FirePHP::getInstance(true);


if($_POST){
    if (empty($_POST['data'])) die("No leveltracedata Specified!");
    if (empty($_POST['UUID'])) die("No UUID Specified!");
	
	//$firephp->log($_POST, "the _POST.");	
	insertBugTrace($_POST['UUID'],$_POST['data'], $_POST['debugInfo']);
} else {
    echo("There is no post data!");
}

?>
