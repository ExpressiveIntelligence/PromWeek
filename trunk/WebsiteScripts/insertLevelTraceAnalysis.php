<?

function insertLevelTraceAnalysis($trace, $LTID) {
  $connection = get_SQL_Connection();
  $newtrace = implode($",", $trace);
  echo $newtrace;
  $hashkey = hash('md5', $newtrace);
  
  $insertquery = sprintf("INSERT INTO LevelTraceAnalysis VALUES('%s', '%s')",
                 $hashkey,
                 mysql_real_escape_string($LTID));
  mysql_query($insertquery,$connection);
  
?>
