<?
include("toolkit.php");

if($_POST){
    if($_POST['uuid'] && $_POST['aid']){
        insertAchievement($_POST['uuid'],$_POST['aid']);
    } else {
        write("Wrong input dawg");
    }
} else {
    write("No Post");
}

?>
