<?php
	include("toolkit.php");
	// require_once('FirePHPCore/FirePHP.class.php');
	// $firephp->log("before getNewLoginIDAndCreateUser");
	
	$loginID = getNewLoginIDAndCreateUser();	
	
	// $firephp->log("after getNewLoginIDAndCreateUser");
	
	header("Content-Type: text/xml");
	
	// $firephp->log("set content type");
	
	$info = sprintf("<data><loginID>%s</loginID></data>",$loginID);
	
	// $firephp->log("info set");
	
	echo $info;
	// echo "!!!!!!!!";
?>
