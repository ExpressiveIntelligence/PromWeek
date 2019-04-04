<?
# Prom Week Includes! This is where all our stuff is :D
require_once 'global.php';
//require_once('FirePHPCore/FirePHP.class.php');
// @ini_set('log_errors','On'); // enable or disable php error logging (use 'On' or 'Off')
// @ini_set('display_errors','Off'); // enable or disable public display of errors (use 'On' or 'Off')
// @ini_set('error_log','/home/path/logs/php-errors.log'); // path to server-writable log file

/* function parseLevelTraceXMLForAnalysis($filecontents)
 * Parses a level trace's XML file and preps it for analysis
 * Input: a fully formed XML file contents(header and document root included)
 * **
 * file_get_contents("test.xml") << use that function for passage
 * **
 * that contains all of the SocialGameContext s of a level trace. Example like so:
 * 
<SocialGameContext gameName="Make Plans" initiator="Naomi" responder="Zack" other="" initiatorScore="11" responderScore="7" time="9" effectIndex="15" chosenItemCKB="null" socialGameContextReference="-1" performanceRealizationString="null"/>
 * Note: SimpleXML _REQUIRES_ that it be wrapped in a root tag. So before sending
 * it to this function, wrap it with <root> ... </root> or something. Maybe something
 * that's named correctly, like <LevelTrace>. 
 * 
 * Returns: an array of strings, where each element is some data for a SocialGame.
 * It goes in the format: GameName,Initiator,Responder,EffectID
 * Ex: Make Plans,Naomi,Zack,15
 * ;;Longest Function Spec Winner ^;;
 */
function parseLevelTraceXMLForAnalysis($filecontents){
  // practice safe coding
  try{
      $xml = simplexml_load_string($filecontents);
      // initialize the return array
      $result = array();
      $sfdb = $xml->SFDB;
      // start going through all the elements
      foreach($sfdb->children() as $child){
        $lineResult = "";
        // and now go through the attributes of these elements
        foreach($child->attributes() as $a => $b){
           // we want to take out gameName, initiator, responder, and effectID
           if($a == "gameName" || $a == "initiator" || 
              $a == "responder" || $a == "effectIndex"){
              // append them to lineResult
              $lineResult .= (strlen($lineResult)==0) ? "$b" : ",$b";
           }
        }
        // push it onto the end of the array
        array_push($result,$lineResult);
        // and empty the line for a new pass if necessary
        $lineResult = "";
     }
     if(count($result) == 0) {
      array_push($result, "Empty level trace detected");
    }
     return $result;
  } catch (Exception $e){
    $errNum = $e->getCode();
    // 2 is the error code for bad XML
    if($errNum == 2) return "Malformed XML file"; 
    else return "Unknown error";
  }
}



/* function getAchievements(UUID)
 * Given a UUID, returns a list of the achievements that user has
 */
function getAchievements($UUID){
    $connection = get_SQL_Connection();
    $query = sprintf("SELECT a.achievementId FROM AchievementsUnlocked a, Users u WHERE u.facebookid='%s' AND a.userId = u.id ORDER BY achievementId",
                        mysql_real_escape_string($UUID));
    $queryresult = mysql_query($query,$connection);
    mysql_close($connection);
    if(!$queryresult) die("Failed to getAchievements: $query $connection");
    else {
        $result = "";
        while($row = mysql_fetch_array($queryresult)){
            if($result != "") $result .= ",";
            $result .= $row['achievementId'];
        }
        return $result;
    }
}

/* function getUserInfo(UUID)
 * Given a UUID, returns data regarding that player in the form of 
 * an XML data structure. It will be formatted as such:
 * <user>
 *      <uuid>########</uuid>
 *      <playCount>#</playCount>
 *      <visits>#</visits>
 * </user>
 *
 */
function getUserInfo($UUID){
    $connection = get_SQL_Connection();
    $query = sprintf("SELECT * FROM Users WHERE facebookid='%s'",
                                mysql_real_escape_string($UUID));

    $queryresult = mysql_query($query,$connection);
    mysql_close($connection);
    if(!$queryresult) die("Failed in getUserInfo with Query: " . $query . "<br>");
    if(mysql_num_rows($queryresult) == 0) return "";
    else {
        #grab the first row of the query
        $row = mysql_fetch_array($queryresult);
        #format the result
        $result = sprintf(
"<user>
    <id>%s</id>
    <uuid>%s</uuid>
    <playCount>%s</playCount>
    <visits>%s</visits>
</user>",
         $row['id'],$row['facebookid'],
         $row['playCount'],$row['uniqueVisits']);
        return XMLify($result);
        
    }
}

/* function getEndingsSeen(UUID)
 * Given a UUID, returns data regarding which endings that 
 * player has seen.  it will be formatted as
 * <user>
 *      <uuid>########</uuid>
 *      <ending>title of ending</ending>
 *      <ending>title of ending</ending>
 *		...
 * </user>
 *
 */
function getEndingsSeen($UUID) {
	ob_start();
	//$firephp = FirePHP::getInstance(true);
	//$firephp->log("inside of getEndingsSeen inside of toolkit.php");
	
    $connection = get_SQL_Connection();
	$userId = getUserIdFromFacebookId($UUID);
    $query = sprintf("SELECT * FROM EndingsSeen WHERE userId='%s'",
                                mysql_real_escape_string($userId));

    $queryresult = mysql_query($query,$connection);
    mysql_close($connection);
    if(!$queryresult) die("Failed in getUserInfo with Query: " . $query . "<br>");
    if(mysql_num_rows($queryresult) == 0) return "";
    else {
	
	$result = "<user>";
	$result .= "<uuid>" . $UUID . "</uuid>";
	for ($i = 0; $i < mysql_num_rows($queryresult); $i++) {
	    #grab the first row of the query
        $row = mysql_fetch_array($queryresult);
        #format the result
        $result .= sprintf("
			<ending>%s</ending>",
			$row['ending_name']);
	}	
	$result .= "</user>";

	//$firephp->log($result, "This is what the XML result is! Fingers crossed!");
    return XMLify($result);
        
    }
}

/* function getGoalsSeen(UUID)
 * Given a UUID, returns data regarding which goals that 
 * player has seen.  it will be formatted as
 * <user>
 *      <uuid>########</uuid>
 *      <goal>title of goal</goal>
 *      <goal>title of goal</goal>
 *		...
 * </user>
 *
 */
function getGoalsSeen($UUID) {
	ob_start();
	//$firephp = FirePHP::getInstance(true);
	//$firephp->log("inside of getGoalsSeen inside of toolkit.php");
	
    $connection = get_SQL_Connection();
	$userId = getUserIdFromFacebookId($UUID);
    $query = sprintf("SELECT * FROM GoalsSeen WHERE userId='%s'",
                                mysql_real_escape_string($userId));

    $queryresult = mysql_query($query,$connection);
    mysql_close($connection);
    if(!$queryresult) die("Failed in getUserInfo with Query: " . $query . "<br>");
    if(mysql_num_rows($queryresult) == 0) return "";
    else {
	
	$result = "<user>";
	$result .= "<uuid>" . $UUID . "</uuid>";
	for ($i = 0; $i < mysql_num_rows($queryresult); $i++) {
	    #grab the first row of the query
        $row = mysql_fetch_array($queryresult);
        #format the result
        $result .= sprintf("
			<goal>%s</goal>",
			$row['goalName']);
	}	
	$result .= "</user>";

	//$firephp->log($result, "This is what the XML result is! Fingers crossed!");
    return XMLify($result);
        
    }
}

/**
*
*/
function getContinueLevelTrace($UUID) {
	ob_start();
	//$firephp = FirePHP::getInstance(true);
	//$firephp->log("inside of getContinueLevelTrace inside of toolkit.php");
	
    $connection = get_SQL_Connection();
	$userId = getUserIdFromFacebookId($UUID);
	$queryForTraceId = sprintf("SELECT Users.continue FROM Users WHERE id='%s'",
                                mysql_real_escape_string($userId));
								

	$queryresult = mysql_query($queryForTraceId,$connection);
	
	$levelTraceId = -1;

	//$firephp->log("Got Users.continue for a specific userId.");
	
	if(!$queryresult) {
		//$firephp->log("Failed in getContinueLevelTrace with Query: " . $queryForTraceId . "<br>");
		die("Failed in getContinueLevelTrace with Query: " . $queryForTraceId . "<br>");
	}
    if(mysql_num_rows($queryresult) == 0) return "";
    else {
	    $row = mysql_fetch_array($queryresult);
		$levelTraceId = $row['continue'];
	}
	
	//$firephp->log("The continue trace id is $levelTraceId.");
	
	if(-1 == $levelTraceId) {
		mysql_close($connection);
		return "<LevelTraces empty=\"true\" />\n";
	}
	
	 $queryForSpecificTrace = sprintf("SELECT * FROM LevelTraces WHERE id='%s'",
                                mysql_real_escape_string($levelTraceId));
	 $queryresult = mysql_query($queryForSpecificTrace,$connection);
	 
	 //$firephp->log("Got row from LevelTraces for a specfic levelTraceId.");
    mysql_close($connection);
    if(!$queryresult) {
		//$firephp->log("Failed in getContinueLevelTrace with Query: " . $query . "<br>");
		die("Failed in getContinueLevelTrace with Query: " . $query . "<br>");
	}
    if(mysql_num_rows($queryresult) == 0) return "";
    else {
		//$firephp->log($queryresult, "The query result for getting a specific row for a level trace.");
		$row = mysql_fetch_array($queryresult);
		//$firephp->log($row, "The a row from query result for getting a specific row for a level trace.");
		$filename = $row['filename'];
		//$firephp->log("The filename for the continue level trace: $filename");
	}	
    //XXX here! The $filename is not being set and is coming back as an empty string.
	//$firephp->log($filename, "This is what the continue level trace file name is!");
	$handle = fopen($filename, 'r');
	$traceXMLString = fread($handle, filesize($filename));
	fclose($handle);
	//$firephp->log($traceXMLString, "This is what the XML string is.");
	return $traceXMLString;

}


/**
*
*/
function getFreeplayState($UUID) {
	ob_start();
	//$firephp = FirePHP::getInstance(true);
	//$firephp->log("inside of getFreeplayState inside of toolkit.php");
	
    $connection = get_SQL_Connection();
	$userId = getUserIdFromFacebookId($UUID);
	$queryForTraceId = sprintf("SELECT Users.freeplay FROM Users WHERE id='%s'",
                                mysql_real_escape_string($userId));
	
	 $queryresult = mysql_query($queryForTraceId,$connection);
	
	$levelTraceId = -1;

	
	if(!$queryresult) die("Failed in getFreeplayState with Query: " . $queryForTraceId . "<br>");
    if(mysql_num_rows($queryresult) == 0) return "";
    else {
	    $row = mysql_fetch_array($queryresult);
		$levelTraceId = $row['freeplay'];
		}
	
	if(-1 == $levelTraceId) {
		mysql_close($connection);
		return "<LevelTraces empty=\"true\" />\n";
	}
	
	 $queryForSpecificTrace = sprintf("SELECT * FROM LevelTraces WHERE id='%s'",
                                mysql_real_escape_string($levelTraceId));
	 $queryresult = mysql_query($queryForSpecificTrace,$connection);
	 
    mysql_close($connection);
    if(!$queryresult) die("Failed in getFreeplayState with Query: " . $query . "<br>");
    if(mysql_num_rows($queryresult) == 0) return "";
    else {
		//$row = mysql_fetch_array($queryresult);
		//$traceFileName = $row['filename'];
		//$firephp->log($queryresult, "The query result for getting a specific row for a level trace.");
		$row = mysql_fetch_array($queryresult);
		//$firephp->log($row, "The a row from query result for getting a specific row for a level trace.");
		$filename = $row['filename'];
		//$firephp->log("The filename for the continue level trace: $filename");
	}	

	//$firephp->log($filename, "This is what the freeplay level trace file name is!");
	$handle = fopen($filename, 'r');
	$traceXMLString = fread($handle, filesize($filename));
	fclose($handle);
	//$firephp->log($traceXMLString, "This is what the XML string is.");
	return $traceXMLString;

}

/* function getNewLoginID(UUID)
 *
 */
function getNewLoginIDAndCreateUser() {
	ob_start();
	//$firephp = FirePHP::getInstance(true);
	//$firephp->log("inside of getGoalsSeen inside of toolkit.php");
	
    $connection = get_SQL_Connection();

	$numResults = 1;
	while ($numResults > 0)
	{	
		$randomNumber = rand(0,100000000);
		$getUserQuery = sprintf("SELECT * FROM Users WHERE facebookid='%s'",
						mysql_real_escape_string($randomNumber));
						
		$queryresult = mysql_query($getUserQuery,$connection);
		$numResults = mysql_num_rows($queryresult);
	}

	$insertQuery = sprintf("INSERT INTO * FROM Users WHERE facebookid='%s'");

	# need to add a user, set playcount to 1
	$insertUserQuery = sprintf("INSERT INTO Users (facebookid, playCount, uniqueVisits) VALUES('%s', %d, %d)"
									,mysql_real_escape_string($randomNumber),0,0);
	if(!mysql_query($insertUserQuery)){
		echo("Could not execute SQL query, '$insertUserQuery' in updatePlayCount");
	}
	
    mysql_close($connection);
	
	return $randomNumber;
}







/* function XMLify(input)
 * puts the XML tag at the front of the string
 */
function XMLify($input){
    return '<?xml version="1.0" encoding="ISO-8859-1"?>' . "\n" . $input;

}

/* function makeDir(UUID, SUBDIR)
 * given a UUID, it will create a folder that is an MD5 hash of that
 * UUID if one doesn't exist already. It will use the first two digits
 * of the UUID as the first level of folders, then make a folder that 
 * is the full MD5 hash of the UUID inside that folder.
 * For example, if the hash is 1234567, it will make:
 * 12/1234567/
 * Returns the directory if it was successful, returns false otherwise.
 * Update: Changed it to handle specifying subdirectories
 */
function makeDir($UUID, $SUBDIR){
    #make a hash of the UUID
    $hash = md5($UUID);
    #specify the path to the directory to be made
    $dir = "./" . $SUBDIR . "/" . substr($hash,0,2) . "/$hash";
    # a if it already exits, return
    if(is_dir($dir)) { return $dir; }
    #otherwise, attempt to make it-
    if(!mkdir($dir,0777,true)){
        echo("Failed to create '$dir'. Function makeDir\n");
        return false;
    }
    else
        return $dir;
}

/* Function: insertAchievement(UUID, AID,LTID=0)
 * Inserts a new achievement into the database. If there is no 3rd arg,
 * it means this occurred before the level trace exists and will be
 * called again once there exists a leveltrace
 */
function insertAchievement($UUID,$AID,$LTID=0){
   $connection = get_SQL_Connection();
   $query = "";
   if($LTID == 0){ # no LTID exists yet
      $query = sprintf("INSERT INTO AchievementsUnlocked (userId,achievementId,levelTraceId) 
                        VALUES ( %s,%s, NULL)",
               mysql_real_escape_string($UUID),
               mysql_real_escape_string($AID));
    
   } else {
      // $query = sprintf("INSERT INTO AchievementsUnlocked (userId, achievementId, levelTraceId) VALUES ( '%s','%s','%s')",
      $query = sprintf("UPDATE AchievementsUnlocked 
                        SET levelTraceId = '%s' 
                        WHERE userId = '%s' AND achievementId = '%s'",
               mysql_real_escape_string($LTID),
               mysql_real_escape_string($UUID),
               mysql_real_escape_string($AID));
   }
   //write("<br>".$query);
   if(!mysql_query($query, $connection)){
    echo("FAILED");
   }
   mysql_close($connection);
}

/* Function: getUserIdFromFacebookId(fbid)
 * Returns the internal user id for a user given his facebook id
 */
function getUserIdFromFacebookId($fbid) {
  $uid_query = sprintf("SELECT id FROM Users WHERE facebookid = '%s'",
    mysql_real_escape_string($fbid));
  $res = mysql_query($uid_query);
  if (mysql_num_rows($res) != 1)
    return null;
  else
    return mysql_result($res, 0);
}

/**
 * Inserts the incoming bug trace XML into the bug trace directory.
 */
function insertBugTrace($UUID, $data, $debugInfo) {
	ob_start();
	//$firephp = FirePHP::getInstance(true);
	//$firephp->log("insertBugTrace entered.");
	$time = time();
	$fullTrace =  "$data\n<!-- $debugInfo -->";
	$filename = "bugtraces/$time" . "_" . $UUID . ".xml";
	// $firephp->log("putting bug trace ($filename) to disk: $fullTrace");
	//$firephp->log("putting bug trace ($filename) to disk.");
    file_put_contents($filename, $fullTrace);
}

/* Function: insertLevelTrace(UUID,DATE,TURNS,STORY,LEVEL,RULESTRUE)
 * Inserts an SQL entry for a level trace into the LevelTraces db
 * using the provided arguments
 */
function insertLevelTrace($UUID,$DATE,$TURNS,$STORY,$LEVEL,$filename, $CONTINUABLE){
	ob_start();
	//$firephp = FirePHP::getInstance(true);
	//$firephp->log("now we are attempting to actually insert level trace inside of toolkit.php story: $STORY continuable: $CONTINUABLE");
    #this is the function we'll use once we have a DB to connect to
    $connection = get_SQL_Connection();
    #select the LevelTraces database to work with 
    //mysql_select_db("LevelTraces",$connection);
    $uid = getUserIdFromFacebookId($UUID);
    
    $query = sprintf("INSERT INTO LevelTraces (userId, createdAt, numTurns, level, story, filename) VALUES('%s', FROM_UNIXTIME(%s), '%s', '%s', '%s', '%s')",
            $uid, 
            mysql_real_escape_string($DATE), 
            mysql_real_escape_string($TURNS), 
            mysql_real_escape_string($LEVEL),
            mysql_real_escape_string($STORY),
            $filename
            ); 
         #there's gotta be a prettier way to do that ^
    if(!mysql_query($query,$connection)) {
        //$firephp->log("Could not execute SQL query '$query' in insertLevelTrace");
        die("Could not execute SQL query '$query' in insertLevelTrace");
	}
	//if it is continuable, get the uid of the level trace
	if($CONTINUABLE == "true") {
		//$firephp->log("CONTINUABLE is true");
		$query = sprintf("SELECT id FROM LevelTraces WHERE userId = '%s' AND filename = '%s'",
				$uid,
				$filename);
		$result = mysql_query($query,$connection);
		$levelTraceId = mysql_result($result, 0);
		if("" == $STORY) {
			//$firephp->log("Error: The STORY type is an empty string.");
		} else {
			//if continuable and $STORY is a story name, update Users.continuable with the level trace's uid
			//if continuable and $STORY is "freeplay", update Users.freeplay with the level trace's uid
			//$firephp->log("insertLevelTrace() setting a continuable level trace id to Users.freeplay or Users.continue.");
			if("freeplay" == $STORY) {
				$field = "freeplay";
			} else {
				$field = "continue";
			}
			
			$query = sprintf("UPDATE Users SET Users.%s = '%s' WHERE Users.id = '%s'",
				$field,
				$levelTraceId,
				$uid);
			if(!mysql_query($query,$connection)) {
				//$firephp->log("insertLevelTrace() query failed: $query");
			}		
		}
	}else{
		if("freeplay" != $STORY && "" != $STORY) { 
			//if it is not continuable and story is a story name (not "" or "freeplay"), set Users.continuable = -1
			$query = sprintf("UPDATE Users SET Users.continue = '-1' WHERE id = '%s'",
					$uid);
			if(!mysql_query($query,$connection)) {
				//$firephp->log("insertLevelTrace() query failed: $query");
			}
			//$firephp->log("insertLevelTrace() story is not continuable. Users.continue is now -1.");
		}else{
			//if it is not continuable and story is "freeplay", the case makes not sense in the game design
			//$firephp->log("insertLevelTrace() %story is freeplay and it is not continuable -- this is an error as freeplay should always be continuable.");
		}
	}
	
    mysql_close($connection);
}

/*
Function: insertEndingsSeen($UUID, $ENDING)
This is a nifty little function that, given the user id and an ending,
will create a new record in the table that links the ending that the
user just saw.
*/
function insertEndingSeen($UUID,$ENDING){
	ob_start();
	//$firephp = FirePHP::getInstance(true);
	//$firephp->log($UUID, "uuid now that I'm in toolkit.php");
	//$firephp->log($ENDING, "ending now that I'm in toolkit.php");
	$connection = get_SQL_Connection();
	$uid = getUserIdFromFacebookId($UUID);
	//$firephp->log($uid, "uid value (no longer facebook id I think");
	$query = sprintf("INSERT INTO EndingsSeen (userId, ending_name) VALUES('%s', '%s')",
		$uid, 
		mysql_real_escape_string($ENDING)
		); 
	if (!mysql_query($query,$connection)) {
		//$firephp->log($query, "uid value (no longer facebook id I think");
          echo("Could not execute SQL query, '$query' in updatePlayCount");
    }
}

/*
Function: insertGoalsSeen($UUID, $ENDING)
This is a nifty little function that, given the user id and an goal,
will create a new record in the table that links the goal that the
user just saw.
*/
function insertGoalSeen($UUID,$GOAL){
	ob_start();
	//$firephp = FirePHP::getInstance(true);
	//$firephp->log($UUID, "uuid now that I'm in toolkit.php");
	//$firephp->log($GOAL, "ending now that I'm in toolkit.php");
	$connection = get_SQL_Connection();
	$uid = getUserIdFromFacebookId($UUID);
	//$firephp->log($uid, "uid value (no longer facebook id I think");
	$query = sprintf("INSERT INTO GoalsSeen (userId, goalName) VALUES('%s', '%s')",
		$uid, 
		mysql_real_escape_string($GOAL)
		); 
	if (!mysql_query($query,$connection)) {
		//$firephp->log($query, "uid value (no longer facebook id I think");
          echo("Could not execute SQL query, '$query' in updatePlayCount");
    }
}


/* Function: updatePlayCount(UUID)
 * Adds a user to the users table if they are a new user and sets playCount to 1
 * If the user exists, their playCount is updated by 1
 */

function updateCounters($UUID, $playCount = false, $uniqueVisit = false) {
	// error_log("toolkit.php::updateCounters() - got here.\n", 3, "php_err	or.log");
    $connection = get_SQL_Connection();
    //mysql_select_db("Users", $connection);
    # see if there is a user in the db with the requested userID
    $getUserQuery = sprintf("SELECT * FROM Users WHERE facebookid='%s'",
                    mysql_real_escape_string($UUID));
    $getUser = mysql_query($getUserQuery,$connection);
    # count the number of results
    $num = mysql_num_rows($getUser);
    if ($num != 0) {
      # user already exists, update counters
      $updates = array();
      if ($playCount)
        $updates[] = "playCount = playCount + 1";
      if ($uniqueVisit)
        $updates[] = "uniqueVisits = uniqueVisits + 1";
        
      if (count($updates) > 0) {
        $query = sprintf("UPDATE Users SET %s WHERE facebookid = '%s'",
                      implode(",", $updates),
                      mysql_real_escape_string($UUID));
        
        if (!mysql_query($query)) {
          echo("Could not execute SQL query, '$query' in updatePlayCount");
        }
      }
    } else {
      # need to add a user, set playcount to 1
      $insertUserQuery = sprintf("INSERT INTO Users (facebookid, playCount, uniqueVisits) VALUES('%s', %d, %d)",
                         mysql_real_escape_string($UUID),
                         $playCount ? 1 : 0,
                         $uniqueVisit ? 1 : 0);
      if(!mysql_query($insertUserQuery)){
        echo("Could not execute SQL query, '$insertUserQuery' in updatePlayCount");
      }
    }
    # close connection
    mysql_close($connection);
}

/* function: get_SQL_Connection()
 * returns a connection to an sql database to be used for SQL shenanegans
 */
function get_SQL_Connection(){
  global $dbConfig;

   $con = mysql_connect($dbConfig['host'], $dbConfig['user'], $dbConfig['pass']);
   if(!$con){
      die('Could not connect to db: ' . mysql_error());
   }
   mysql_select_db($dbConfig['db']);
   
   return $con;
}

/* function write(string)
 * used to formulate strings easily. Makes things nice.
 */
function write($string){
    echo $string . "<br>\n";
}