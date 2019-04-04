<?
include("toolkit.php");

if($_POST){
    if($_POST['uuid']){
        echo(getAchievements($_POST['uuid']));
    }
} else {
    write("No Post");
}
?>
