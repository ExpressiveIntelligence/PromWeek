<?php
include("toolkit.php");
//require_once('FirePHPCore/FirePHP.class.php');
ob_start();

//$firephp = FirePHP::getInstance(true);
 
$var = array('i'=>10, 'j'=>20);
 
//$firephp->log($var, 'Iterators');

/*receives an ending that has just been seen. $_POST also must 
 * contain the following elements for this to work:
 * UUID - the un-hashed UUID of the player
 * ENDING - The ending that the player just saw
 *
 */
if($_POST){
    #test if UUID is there
    if(empty($_POST['UUID'])) die("No UUID Specified");
    if (empty($_POST['ENDING'])) die("No ENDING Specified");
	//$firephp->log($_POST['UUID'], "UUID Value");
	//$firephp->log($_POST['ENDING'], "ENDING Value");
	//$firephp->log($_POST['ENDING'], "ENDING Value a SECOND TIME");
    # update the database
    insertEndingSeen($_POST['UUID'], $_POST['ENDING']);   
	//$firephp->log($_POST['ENDING'], "ENDING Value a THIRD TIME AFTER CALLING INSERT ENDNG SEEN");
} else {
    echo("There is no post data!");
}

?>
