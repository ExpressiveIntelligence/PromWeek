<?
include("toolkit.php");

if($_POST){
    if(isset($_POST['UUID'])) {
        $playCounter = isset($_POST['newLevel']) && $_POST['newLevel'] == 1;
        $uniqueVisitCounter = isset($_POST['gameLoaded']) && $_POST['gameLoaded'] == 1;
        updateCounters($_POST['UUID'], $playCounter, $uniqueVisitCounter);
		// error_log("toolkit.php::updateCounters() - $_POST['UUID'], $playCounter, $uniqueVisitCounter\n", 3, "php_error.log");
    }
} else {
	updateCounters("987654321", 6, 9);
    write("No Post");
}
?>
