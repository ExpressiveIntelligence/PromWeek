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
    #test if UUID is there
    if(empty($_POST['UUID'])) die("No UUID Specified");
    if(empty($_POST['TURNS'])) die("No TURNS Specified");
    if(empty($_POST['STORY'])) die("No STORY Specified");
    if(empty($_POST['LEVEL'])) die("No LEVEL Specified");
    if (empty($_POST['leveltracedata'])) die("No leveltracedata Specified!");
    if (empty($_POST['CONTINUABLE'])) die("No CONTINUABLE Specified!");
	
	
	//$firephp->log($_POST, "the _POST.");
    //make a directory to place it and grab where it goes
    $dir = makeDir($_POST['UUID'],"LevelTraceStorage");
    #if all is well, dump the XML file to where it should go and update
    # the database
    if($dir){
        #the time is NOW!
        $time = time();
        #put the data into $dir/TIME_UUID.xml
        $filename = "$dir/$time" . "_" . $_POST['UUID'] . ".xml";
        file_put_contents($filename,
                           $_POST['leveltracedata']);
        #toss the trace data into the database!
		//$firephp->log("calling toolkit.php's insertLevelTrace().");
        insertLevelTrace($_POST['UUID'], $time, $_POST['TURNS'],
                         $_POST['STORY'], $_POST['LEVEL'], $filename, $_POST['CONTINUABLE']);
        
    } else {
        echo("Was not able to make directory, something went wrong!");
    }
    
} else {
    echo("There is no post data!");
}

?>
