<?php 
include("toolkit.php");
/*
 * Receives a level error file (as spec'd by Josh) and places it into 
 * ROOTDIR/Errors/{useridhash}/date.xml
 * Very similar to receiveLevelTrace.php, except it doesn't communicate to 
 * the database at all. 
 * What should be sent over POST:
 *  UUID - The un-hashed UUID for the player
 *  ERRDATA - The raw text for the error data. Should be formatted already
 *
 */
if($_POST){
  echo("Found some code!");
    #do some content testing:
    if(empty($_POST['UUID'])) die("No User ID Specified! Check the docs");
    if(empty($_POST['ERRDATA'])) die("No Error Data Specified! Czech the docs");
    #make the errors directory
    $dir = makeDir($_POST['UUID'],"Errors");
    #if all is well, start pooping data into the directory we just made
    if($dir){
        #grab the time
        $time = time();
        #format: $dir/$time_$UUID.xml
        $filename = "$dir/$time" . "_ " . $_POST['UUID'] . ".xml";
        file_put_contents($filename, $_POST['ERRDATA']);
    } else {
      die("Was not able to make directory, something went horribly wrong");
    }
} else {
    die("There was no post data!");
}

?>