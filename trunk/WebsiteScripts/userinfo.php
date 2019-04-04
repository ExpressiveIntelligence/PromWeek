<?php
include("toolkit.php");

if($_POST){
    if($_POST['uuid']){
        $info = getUserInfo($_POST['uuid']);
        echo($info);
    } else {
        echo("Query formulated incorrectly, please refer to the documentation for usage<br>\n");
    }
} else {
echo("No Post");
}

?>
